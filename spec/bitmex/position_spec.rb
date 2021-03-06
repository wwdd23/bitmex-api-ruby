require 'spec_helper'

RSpec.describe Bitmex::Position do
  let(:client) { Bitmex::Client.new testnet: true, api_key: ENV['API_KEY'], api_secret: ENV['API_SECRET'] }

  describe '#all' do
    it 'with rest api' do
      positions = client.positions.all
      expect(positions.size).to eq 1
      expect(positions.first.symbol).to eq 'XBTUSD'
      expect(positions.first.currentQty).to eq -10
    end
    it 'with websocket api' do
      client.positions.all do |position|
        expect(position.symbol).to eq 'XBTUSD'
        expect(position.currentQty).to eq -10
        client.websocket.stop
      end
    end
  end

  it '#isolate' do
    position = client.position('XBTUSD').isolate
    expect(position.crossMargin).to be_falsey
  end

  it '#leverage' do
    leverage = rand(10..50)
    position = client.position('XBTUSD').leverage leverage
    expect(position.leverage).to eq leverage
  end

  it '#risk_limit' do
    risk_limit = 30000000000
    position = client.position('XBTUSD').risk_limit risk_limit
    expect(position.riskLimit).to eq risk_limit
  end

  it '#transfer_margin' do
    margin = 10_000
    position = client.position('XBTUSD').transfer_margin margin
    expect(position.maintMargin).to be > 10_000
  end
end

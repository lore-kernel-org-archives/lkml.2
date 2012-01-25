Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2AYAXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:23:08 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:51928 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2AYAXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:23:05 -0500
Date: Wed, 25 Jan 2012 09:22:51 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120125002250.GA20431@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at> <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Emmanuel,

On Mo, 23 Jan 2012, Emmanuel Grumbach wrote:
> Can you please run with debug flags 0x80000000 ?

Here we go. Booting into 3.3-rc1 tries to connect, the connection seems
to be established, but nothing actually goes out/in.
Main problem seems to be:
	iwlagn_tx_agg_stop Can't proceed: ssn 340, next_recl = 329

rfkill block wifi ; sleep 10; rfkill unblock wifi

helps.

I attach the dmesg of all wifi related things since boot.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
WHAPLODE DROVE (n.)
A homicidal golf stroke.
			--- Douglas Adams, The Meaning of Liff

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[   35.768085] cfg80211: Calling CRDA to update world regulatory domain
[   35.980591] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   35.982187] Copyright(c) 2003-2011 Intel Corporation
[   35.983888] iwlwifi 0000:06:00.0: pci_resource_len = 0x00002000
[   35.985471] iwlwifi 0000:06:00.0: pci_resource_base = ffffc900041bc000
[   35.986981] iwlwifi 0000:06:00.0: HW Revision ID = 0x0
[   35.988618] iwlwifi 0000:06:00.0: irq 47 for MSI/MSI-X
[   35.988681] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   35.990170] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[   35.991651] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   35.993136] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   35.994616] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_P2P disabled
[   35.996112] iwlwifi 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   35.997658] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   36.012102] firewire_core: created device fw0: GUID 0800460302b0163b, S400
[   36.020947] iwlwifi 0000:06:00.0: device EEPROM VER=0x11e, CALIB=0x4
[   36.022379] iwlwifi 0000:06:00.0: Device SKU: 0xF0
[   36.023793] iwlwifi 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   36.623830] iwlwifi 0000:06:00.0: loaded firmware version 8.83.5.1 build 33692 (EXP)
[   36.625485] Registered led device: phy0-led
[   36.653785] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'

...

[   37.015237] cfg80211: World regulatory domain updated:
[   37.016730] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   37.018157] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   37.019581] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   37.021011] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   37.022390] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   37.023744] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

...

[   45.598110] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   45.602018] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   45.642289] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 4  WrPtr: 0
[   45.642359] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[   45.642424] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[   45.642486] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[   45.642549] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[   45.642610] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[   45.717238] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   45.720267] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   45.762302] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 4  WrPtr: 0
[   45.762335] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[   45.762347] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[   45.762360] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[   45.762372] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[   45.762385] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7

...

[   53.589698] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[   53.598039] wlan0: authenticated
[   53.602978] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[   53.616050] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=3)
[   53.616054] wlan0: associated
[   53.616058] wlan0: moving STA 00:0a:79:eb:56:10 to state 1
[   53.616060] wlan0: moving STA 00:0a:79:eb:56:10 to state 2
[   53.625011] cfg80211: Calling CRDA for country: JP
[   53.629833] cfg80211: Regulatory domain changed to country: JP
[   53.629836] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   53.629839] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   53.629842] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   53.629844] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   53.629846] cfg80211:   (4910000 KHz - 4930000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   53.629849] cfg80211:   (4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[   53.629851] cfg80211:   (4930000 KHz - 4950000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   53.629854] cfg80211:   (5030000 KHz - 5045000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   53.629856] cfg80211:   (5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[   53.629859] cfg80211:   (5050000 KHz - 5060000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   53.629861] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   53.629864] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   53.629866] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[   53.891052] wlan0: moving STA 00:0a:79:eb:56:10 to state 3
[   54.149647] Rx A-MPDU request on tid 0 result 0
[   65.575106] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[   65.592289] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 66
[   65.592307] activated addBA response timer on tid 0
[   65.594292] switched off addBA timer for tid 0
[   65.594300] Aggregation is on for tid 0
[   65.594397] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 66
[   65.594486] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 1
[   65.594496] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[   73.331722] Rx A-MPDU request on tid 6 result 0
[   73.331806] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 6
[   73.331815] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 6 recipient reason: 32
[   73.333589] Rx A-MPDU request on tid 6 result 0
[   74.417278] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[   74.440231] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 13
[   74.440252] activated addBA response timer on tid 6
[   74.442198] switched off addBA timer for tid 6
[   74.442204] Aggregation is on for tid 6
[   74.442331] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 12  WrPtr: 13
[   74.442436] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 12 on FIFO 3
[   74.442446] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[   74.629141] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   74.629151] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   89.536080] tx session timer expired on tid 6
[   89.536109] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[   89.560113] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 26
[   89.560172] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 12  WrPtr: 0
[   89.560251] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 12 on FIFO 0
[   89.560273] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  102.896068] tx session timer expired on tid 0
[  102.896116] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  102.916116] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 163
[  102.916176] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  102.916253] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  102.916273] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  108.838002] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  108.856257] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 167
[  108.856276] activated addBA response timer on tid 0
[  109.856064] addBA response timer expired on tid 0
[  109.856110] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  109.872130] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 167
[  109.872177] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  109.872232] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  112.755165] switched off addBA timer for tid 0
[  112.755168] got addBA resp for tid 0 but we already gave up
[  112.755178] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  114.418021] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  114.448976] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 27
[  114.448994] activated addBA response timer on tid 6
[  114.452114] switched off addBA timer for tid 6
[  114.452122] Aggregation is on for tid 6
[  114.452230] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 27
[  114.452319] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 3
[  114.452329] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[  119.381587] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  119.400274] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 184
[  119.400293] activated addBA response timer on tid 0
[  119.402287] switched off addBA timer for tid 0
[  119.402294] Aggregation is on for tid 0
[  119.402390] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 12  WrPtr: 184
[  119.402479] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 12 on FIFO 1
[  119.402489] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  119.584066] tx session timer expired on tid 6
[  119.584109] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  119.604111] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 27
[  119.604168] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  119.604246] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  119.604265] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  131.184092] tx session timer expired on tid 0
[  131.184141] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  131.204121] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 255
[  131.204180] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 12  WrPtr: 0
[  131.204258] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 12 on FIFO 0
[  131.204280] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  139.198746] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  139.220255] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 262
[  139.220273] activated addBA response timer on tid 0
[  139.222218] switched off addBA timer for tid 0
[  139.222225] Aggregation is on for tid 0
[  139.222322] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 6
[  139.222411] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 1
[  139.222421] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  144.352068] tx session timer expired on tid 0
[  144.352114] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  144.368114] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 263
[  144.368172] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  144.368249] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  144.368269] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  150.289509] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  150.308286] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 268
[  150.308307] activated addBA response timer on tid 0
[  150.310290] switched off addBA timer for tid 0
[  150.310296] Aggregation is on for tid 0
[  150.310393] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 12
[  150.310483] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 1
[  150.310493] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  170.640067] tx session timer expired on tid 0
[  170.640114] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  170.660139] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 280
[  170.660198] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  170.660276] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  172.557483] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  177.553796] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  177.572273] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 286
[  177.572291] activated addBA response timer on tid 0
[  177.574282] switched off addBA timer for tid 0
[  177.574289] Aggregation is on for tid 0
[  177.574385] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 30
[  177.574476] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 1
[  177.574486] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  184.688066] tx session timer expired on tid 0
[  184.688111] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  184.708131] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 289
[  184.708188] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  184.708266] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  184.708286] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  192.842284] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  192.868302] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 298
[  192.868320] activated addBA response timer on tid 0
[  192.870209] switched off addBA timer for tid 0
[  192.870216] Aggregation is on for tid 0
[  192.870312] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 42
[  192.870402] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 1
[  192.870412] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  206.418315] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  206.436268] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 37
[  206.436287] activated addBA response timer on tid 6
[  206.438335] switched off addBA timer for tid 6
[  206.438342] Aggregation is on for tid 6
[  206.438437] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 12  WrPtr: 37
[  206.438527] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 12 on FIFO 3
[  206.438537] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[  212.544076] tx session timer expired on tid 6
[  212.544125] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  212.560113] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 38
[  212.560172] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 12  WrPtr: 0
[  212.560250] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 12 on FIFO 0
[  212.560270] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  218.304086] tx session timer expired on tid 0
[  218.304131] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  218.324119] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 317
[  218.324176] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  218.324254] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  218.324274] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  230.017770] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  230.036272] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 326
[  230.036290] activated addBA response timer on tid 0
[  230.038258] switched off addBA timer for tid 0
[  230.038265] Aggregation is on for tid 0
[  230.038361] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 70
[  230.038450] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 1
[  230.038461] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  239.584087] tx session timer expired on tid 0
[  239.584134] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  239.604118] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 331
[  239.604176] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 0
[  239.604253] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  239.604273] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  241.484939] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  241.512277] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start Can proceed: ssn = next_recl = 333
[  241.512282] activated addBA response timer on tid 0
[  241.514167] switched off addBA timer for tid 0
[  241.514169] Aggregation is on for tid 0
[  241.514252] iwlwifi 0000:06:00.0: U iwl_trans_set_wr_ptrs Q 11  WrPtr: 77
[  241.514336] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 11 on FIFO 1
[  241.514339] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  253.808089] tx session timer expired on tid 0
[  253.808111] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  253.828117] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_stop Can't proceed: ssn 340, next_recl = 329

--qMm9M+Fa2AknHoGS--

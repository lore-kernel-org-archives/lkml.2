Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2AXBgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:36:39 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60783 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2AXBgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:36:38 -0500
Date: Tue, 24 Jan 2012 10:36:25 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all, 

(please cc)

long time ago we had a long discussion about iwlagn regressions in 3.1.0
Up to 3.2 I still have regular problems on the university network
with stuck iwl driver not even realizing that nothing goes out or in.

Today I switched to 3.3-rc1 to see it is getting even worse, now on my
home network I get stuck queue and no connection:

Here a bit of dmsg:
[   59.074751] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[   59.077291] wlan0: authenticated
[   59.082048] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[   59.088907] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
[   59.088911] wlan0: associated
[   59.088914] wlan0: moving STA 00:0a:79:eb:56:10 to state 1
[   59.088916] wlan0: moving STA 00:0a:79:eb:56:10 to state 2
[   59.094289] cfg80211: Calling CRDA for country: JP
....
[   59.100462] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[   59.640945] wlan0: moving STA 00:0a:79:eb:56:10 to state 3
[   59.893618] Rx A-MPDU request on tid 0 result 0
[   67.500767] type=1305 audit(1327367378.735:34933): auid=4294967295 ses=4294967295 op="remove rule" key=(null) list=4 res=1
[   67.500772] type=1305 audit(1327367378.735:34934): audit_enabled=0 old=1 auid=4294967295 ses=4294967295 res=1
[   70.367923] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[   70.380150] activated addBA response timer on tid 0
[   70.382052] switched off addBA timer for tid 0
[   70.382054] Aggregation is on for tid 0
[   70.382193] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[   79.307470] Rx A-MPDU request on tid 6 result 0
[   88.975687] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[   88.996195] activated addBA response timer on tid 6
[   88.998130] switched off addBA timer for tid 6
[   88.998132] Aggregation is on for tid 6
[   88.998294] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[   94.128034] tx session timer expired on tid 6
[   94.128059] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[   94.144199] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  204.928067] tx session timer expired on tid 0
[  204.928080] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  204.952166] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  213.387258] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  213.404237] activated addBA response timer on tid 0
[  213.406212] switched off addBA timer for tid 0
[  213.406214] Aggregation is on for tid 0
[  213.406375] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  226.208032] tx session timer expired on tid 0
[  226.208043] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  226.240201] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  228.599092] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  228.624228] activated addBA response timer on tid 0
[  228.626198] switched off addBA timer for tid 0
[  228.626200] Aggregation is on for tid 0
[  228.626317] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  258.908018] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  258.908022] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  258.908024] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  258.908027] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  258.908030] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  259.316067] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  259.316071] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  259.316073] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  259.316076] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  259.316078] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  259.827797] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  259.828087] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 6 inititator reason: 0
[  259.828856] Rx A-MPDU request on tid 0 result 0
[  282.159584] Rx A-MPDU request on tid 6 result 0
[  317.440056] tx session timer expired on tid 0
[  317.440092] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  317.460203] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  319.344568] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  319.364211] activated addBA response timer on tid 0
[  319.366199] switched off addBA timer for tid 0
[  319.366201] Aggregation is on for tid 0
[  319.366376] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  331.616071] tx session timer expired on tid 0
[  331.616118] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  331.636237] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  335.560927] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  335.592265] activated addBA response timer on tid 0
[  335.594210] switched off addBA timer for tid 0
[  335.594217] Aggregation is on for tid 0
[  335.594374] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  352.912068] tx session timer expired on tid 0
[  352.912099] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  358.537559] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  358.542672] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  358.564308] activated addBA response timer on tid 0
[  358.566251] switched off addBA timer for tid 0
[  358.566259] Aggregation is on for tid 0
[  358.566414] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  376.928052] tx session timer expired on tid 0
[  376.928078] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  376.952178] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  389.583167] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  389.596155] activated addBA response timer on tid 0
[  389.598079] switched off addBA timer for tid 0
[  389.598081] Aggregation is on for tid 0
[  389.598211] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  472.736062] tx session timer expired on tid 0
[  472.736103] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  478.343144] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  483.817635] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  483.832171] activated addBA response timer on tid 0
[  483.834122] switched off addBA timer for tid 0
[  483.834124] Aggregation is on for tid 0
[  483.834251] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  559.520070] tx session timer expired on tid 0
[  559.520118] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  559.540222] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  564.472540] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  564.496123] activated addBA response timer on tid 0
[  564.498038] switched off addBA timer for tid 0
[  564.498041] Aggregation is on for tid 0
[  564.498179] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  580.800050] tx session timer expired on tid 0
[  580.800077] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  580.820245] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  589.529736] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  589.540229] activated addBA response timer on tid 0
[  589.542081] switched off addBA timer for tid 0
[  589.542089] Aggregation is on for tid 0
[  589.542247] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  602.128033] tx session timer expired on tid 0
[  602.128077] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0

Here everything stopped working without any reaction or signal
from kernel, driver, whatsoever.

After some time I decided to reset (echo 1 > ...../force_reset):

[  685.975706] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  686.000235] activated addBA response timer on tid 6
[  686.002201] switched off addBA timer for tid 6
[  686.002203] Aggregation is on for tid 6
[  686.002393] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[  688.643598] iwlwifi 0000:06:00.0: On demand firmware reload
[  688.644044] ieee80211 phy0: Hardware restart was requested
[  688.644147] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  688.647179] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[  688.700816] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 36
[  688.700983] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  688.701115] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 6 recipient reason: 36
[  688.701124] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6

Still no success!!! So rfkill on and off:
[  725.234448] iwlwifi 0000:06:00.0: RF_KILL bit toggled to disable radio.
[  725.816063] iwlwifi 0000:06:00.0: Not sending command - RF KILL
[  725.816100] iwlwifi 0000:06:00.0: Not sending command - RF KILL
[  726.816121] iwlwifi 0000:06:00.0: Not sending command - RF KILL
[  726.816158] iwlwifi 0000:06:00.0: Not sending command - RF KILL
[  727.232124] iwlwifi 0000:06:00.0: Command REPLY_RXON aborted: RF KILL Switch
[  727.232151] iwlwifi 0000:06:00.0: Command REPLY_RXON aborted: RF KILL Switch
[  727.232161] iwlwifi 0000:06:00.0: Command REPLY_RXON aborted: RF KILL Switch
[  727.232177] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
[  727.264074] iwlwifi 0000:06:00.0: Command REPLY_ADD_STA aborted: RF KILL Switch
[  727.264088] ieee80211 phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-125)
[  727.288133] iwlwifi 0000:06:00.0: Command REPLY_ADD_STA aborted: RF KILL Switch
[  727.288146] ieee80211 phy0: failed to remove key (0, 00:0a:79:eb:56:10) from hardware (-125)
[  727.288221] wlan0: moving STA 00:0a:79:eb:56:10 to state 2
[  727.288227] wlan0: moving STA 00:0a:79:eb:56:10 to state 1
[  727.288234] wlan0: moving STA 00:0a:79:eb:56:10 to state 0
[  727.288243] iwlwifi 0000:06:00.0: Command REPLY_REMOVE_STA aborted: RF KILL Switch
[  727.320227] ieee80211 phy0: TX A-MPDU  purging 264 packets for tid=0
[  727.320461] iwlwifi 0000:06:00.0: Command REPLY_RXON aborted: RF KILL Switch
[  727.320497] iwlwifi 0000:06:00.0: Not sending command - RF KILL
[  727.320510] iwlwifi 0000:06:00.0: Command REPLY_RXON aborted: RF KILL Switch
[  727.320557] cfg80211: Calling CRDA to update world regulatory domain
[  727.340111] iwlwifi 0000:06:00.0: Command REPLY_RXON aborted: RF KILL Switch
[  727.345213] cfg80211: World regulatory domain updated:
[  727.345222] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  727.345232] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  727.345241] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  727.345249] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  727.345257] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  727.345266] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  735.347967] iwlwifi 0000:06:00.0: RF_KILL bit toggled to enable radio.
[  735.350637] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  735.353938] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[  742.984202] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[  742.989491] wlan0: authenticated
[  742.991201] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[  742.997018] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
[  742.997037] wlan0: moving STA 00:0a:79:eb:56:10 to state 1
[  742.997044] wlan0: moving STA 00:0a:79:eb:56:10 to state 2
[  743.003883] cfg80211: Calling CRDA for country: JP
[  743.013936] cfg80211: Regulatory domain changed to country: JP
[  743.013946] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  743.013955] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  743.013964] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  743.013971] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  743.013979] cfg80211:   (4910000 KHz - 4930000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[  743.013987] cfg80211:   (4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[  743.013994] cfg80211:   (4930000 KHz - 4950000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[  743.014002] cfg80211:   (5030000 KHz - 5045000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[  743.014010] cfg80211:   (5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[  743.014017] cfg80211:   (5050000 KHz - 5060000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[  743.014025] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  743.014033] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  743.014040] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[  743.641206] wlan0: moving STA 00:0a:79:eb:56:10 to state 3
[  743.707121] Rx A-MPDU request on tid 0 result 0
[  754.151203] Rx A-MPDU request on tid 6 result 0
[  757.526560] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  757.544182] activated addBA response timer on tid 0
[  758.544087] addBA response timer expired on tid 0
[  758.544135] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  765.471766] switched off addBA timer for tid 0
[  765.471773] got addBA resp for tid 0 but we already gave up
[  765.471812] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  766.117423] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  766.137379] activated addBA response timer on tid 0
[  766.139746] switched off addBA timer for tid 0
[  766.139752] Aggregation is on for tid 0
[  766.139895] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  807.975974] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  807.996257] activated addBA response timer on tid 6
[  807.998205] switched off addBA timer for tid 6
[  807.998212] Aggregation is on for tid 6
[  807.998370] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[  814.112068] tx session timer expired on tid 6
[  814.112118] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  814.132223] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  869.975764] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  869.992279] activated addBA response timer on tid 6

etc etc etc etc etc ... but at least now it is working.

Seems that iwlwifi is not really improving in any way.

Please let me know if you want me to test more patches or debugging.

Thanks

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
ADRIGOLE (n.)
The centrepiece of a merry-go-round on which the man with the tickets
stands unnervingly still.
			--- Douglas Adams, The Meaning of Liff

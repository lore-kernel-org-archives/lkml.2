Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2GLIPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:15:13 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:35820 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GLIPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:15:07 -0400
Date: Thu, 12 Jul 2012 17:14:58 +0900
From: Norbert Preining <preining@logic.at>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
        "Lin, Hsien KuoX" <hsien.kuox.lin@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: [Ilw]  Re: 3.4-rc2, ilwagn still most of the time completely
	unusable
Message-ID: <20120712081457.GA32465@gamma.logic.tuwien.ac.at>
References: <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com> <20120413014047.GB25681@gamma.logic.tuwien.ac.at> <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <20120628072512.GF31944@gamma.logic.tuwien.ac.at> <1340869868.4491.4.camel@jlt3.sipsolutions.net> <20120628081607.GG31944@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628081607.GG31944@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preach for decent iwl driver ...

On Do, 28 Jun 2012, Norbert Preining wrote:
> > You seem to be on 3.5.0-rc now, is that really no different from 3.4?
> 
> The feeling is that it is definitely better.
> 
> I can actually work now wirelessly, and in case of hangs an rfkill block
> rfkill unblock practically always, and mostly is not needed.

Ok, that was said *UNTIL* I reenabled 11n. Up to now I was loading the
iwlwifi module with
	11n_disable=1

Now, latest git from today, I though, let us try to enable 11n again,
and there we go, boot from cold machine and after short time everything
is dead without reaction. Dmesg gives many many funny messages:

[   30.047943] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   30.051933] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   30.164836] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   30.167876] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   37.533619] wlan0: authenticate with 00:0a:79:eb:56:10
[   37.536433] wlan0: send auth to 00:0a:79:eb:56:10 (try 1/3)
[   37.538241] wlan0: authenticated
[   37.538391] wlan0: associating with AP with corrupt beacon
[   37.540056] wlan0: associate with 00:0a:79:eb:56:10 (try 1/3)
[   37.543844] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=3)
[   37.543848] wlan0: associated
[   37.547219] cfg80211: Calling CRDA for country: JP
[   37.551474] cfg80211: Regulatory domain changed to country: JP
[   37.551477] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   37.551479] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   37.551481] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   37.551483] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   37.551485] cfg80211:   (4910000 KHz - 4930000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   37.551486] cfg80211:   (4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[   37.551488] cfg80211:   (4930000 KHz - 4950000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   37.551490] cfg80211:   (5030000 KHz - 5045000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   37.551492] cfg80211:   (5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[   37.551494] cfg80211:   (5050000 KHz - 5060000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[   37.551495] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   37.551497] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   37.551499] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[   39.526929] Rx A-MPDU request on tid 0 result 0
[   46.907606] type=1305 audit(1342079160.633:43563): auid=4294967295 ses=4294967295 op="remove rule" key=(null) list=4 res=1
[   46.907619] type=1305 audit(1342079160.633:43564): audit_enabled=0 old=1 auid=4294967295 ses=4294967295 res=1
[   49.372661] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[   49.392528] activated addBA response timer on tid 0
[   49.394760] switched off addBA timer for tid 0
[   49.394769] Aggregation is on for tid 0
[   52.416068] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416081] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416089] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416096] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416103] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416110] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416117] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416124] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416131] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   52.416138] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[   69.252057] tx session timer expired on tid 0
[   69.252125] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[   69.272673] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[   99.933558] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[   99.952530] activated addBA response timer on tid 0
[   99.954667] switched off addBA timer for tid 0
[   99.954676] Aggregation is on for tid 0
[  115.075768] net_ratelimit: 25 callbacks suppressed
[  115.075783] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  122.721571] Rx A-MPDU request on tid 0 result 0
[  132.008042] tx session timer expired on tid 0
[  132.008099] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  132.028663] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  150.396166] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  150.416568] activated addBA response timer on tid 0
[  150.418855] switched off addBA timer for tid 0
[  150.418864] Aggregation is on for tid 0
[  155.648232] tx session timer expired on tid 0
[  155.648344] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  155.712077] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  174.770400] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  174.788589] activated addBA response timer on tid 0
[  174.790924] switched off addBA timer for tid 0
[  174.790933] Aggregation is on for tid 0
[  179.952240] tx session timer expired on tid 0
[  179.952309] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  179.988674] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  190.379820] Monitor-Mwait will be used to enter C-2 state
[  190.464417] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  194.899310] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  198.557158] Rx A-MPDU request on tid 0 result 0
[  199.857800] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  199.876203] activated addBA response timer on tid 0
[  199.878134] switched off addBA timer for tid 0
[  199.878137] Aggregation is on for tid 0
[  205.012031] tx session timer expired on tid 0
[  205.012059] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  205.028154] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  231.043030] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  231.068189] activated addBA response timer on tid 0
[  232.068013] addBA response timer expired on tid 0
[  232.070445] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  232.172044] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  236.076079] switched off addBA timer for tid 0
[  236.076083] got addBA resp for tid 0 but we already gave up
[  236.076108] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  236.077505] Rx A-MPDU request on tid 0 result 0
[  236.077522] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  236.085520] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  236.100112] activated addBA response timer on tid 0
[  236.101931] switched off addBA timer for tid 0
[  236.101934] Aggregation is on for tid 0
[  250.832035] tx session timer expired on tid 0
[  250.832062] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  250.848187] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  256.749542] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  256.768199] activated addBA response timer on tid 0
[  256.770132] switched off addBA timer for tid 0
[  256.770134] Aggregation is on for tid 0
[  267.328057] tx session timer expired on tid 0
[  267.328076] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  267.344218] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  269.719144] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  269.732239] activated addBA response timer on tid 0
[  269.734184] switched off addBA timer for tid 0
[  269.734186] Aggregation is on for tid 0
[  274.936071] tx session timer expired on tid 0
[  274.936105] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  274.952285] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  278.160167] usb 8-2: USB disconnect, device number 2
[  281.245767] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  281.256213] activated addBA response timer on tid 0
[  281.258078] switched off addBA timer for tid 0
[  281.258081] Aggregation is on for tid 0
[  320.855956] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  320.880286] activated addBA response timer on tid 6
[  320.882267] switched off addBA timer for tid 6
[  320.882272] Aggregation is on for tid 6
[  322.428079] tx session timer expired on tid 0
[  322.428090] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  322.452276] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  332.088032] tx session timer expired on tid 6
[  332.088085] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  335.900144] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  350.580037] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  350.592129] activated addBA response timer on tid 0
[  350.593928] switched off addBA timer for tid 0
[  350.593930] Aggregation is on for tid 0
[  364.040010] tx session timer expired on tid 0
[  364.040034] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  364.060167] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  391.857778] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  391.876229] activated addBA response timer on tid 0
[  391.878181] switched off addBA timer for tid 0
[  391.878188] Aggregation is on for tid 0
[  397.100028] tx session timer expired on tid 0
[  397.100052] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  397.124294] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  447.952847] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  447.968288] activated addBA response timer on tid 0
[  447.970265] switched off addBA timer for tid 0
[  447.970271] Aggregation is on for tid 0
[  453.116013] tx session timer expired on tid 0
[  453.116042] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  455.904124] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  469.983154] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  470.004246] activated addBA response timer on tid 0
[  470.006181] switched off addBA timer for tid 0
[  470.006186] Aggregation is on for tid 0
[  475.320065] tx session timer expired on tid 0
[  475.320103] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  475.352211] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  525.855950] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  525.872237] activated addBA response timer on tid 6
[  525.874154] switched off addBA timer for tid 6
[  525.874160] Aggregation is on for tid 6
[  531.008066] tx session timer expired on tid 6
[  531.008101] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  531.036289] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  591.614347] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  591.628233] activated addBA response timer on tid 0
[  591.630127] switched off addBA timer for tid 0
[  591.630132] Aggregation is on for tid 0
[  675.970533] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  676.123652] Rx A-MPDU request on tid 0 result 0
[  678.176189] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  678.219031] Rx A-MPDU request on tid 0 result 0
[  678.240242] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  683.166179] Rx A-MPDU request on tid 0 result 0
[  688.800013] tx session timer expired on tid 0
[  688.800036] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  688.820256] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  715.753804] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  715.784268] activated addBA response timer on tid 0
[  715.786266] switched off addBA timer for tid 0
[  715.786272] Aggregation is on for tid 0
[  728.776062] tx session timer expired on tid 0
[  728.776091] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  728.796221] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  737.754033] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  737.776299] activated addBA response timer on tid 0
[  737.778264] switched off addBA timer for tid 0
[  737.778270] Aggregation is on for tid 0
[  758.980031] tx session timer expired on tid 0
[  758.980082] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  759.016307] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  788.578489] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  788.600254] activated addBA response timer on tid 0
[  788.602218] switched off addBA timer for tid 0
[  788.602224] Aggregation is on for tid 0
[  803.504097] tx session timer expired on tid 0
[  803.504138] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  803.524276] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  824.510495] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  824.528269] activated addBA response timer on tid 6
[  824.530247] switched off addBA timer for tid 6
[  824.530253] Aggregation is on for tid 6
[  829.712080] tx session timer expired on tid 6
[  829.712129] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  829.728181] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  858.453300] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  858.472261] activated addBA response timer on tid 0
[  858.474165] switched off addBA timer for tid 0
[  858.474172] Aggregation is on for tid 0
[  863.688071] tx session timer expired on tid 0
[  863.688121] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  863.708290] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  903.634792] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  903.664267] activated addBA response timer on tid 0
[  903.666272] switched off addBA timer for tid 0
[  903.666279] Aggregation is on for tid 0
[  911.992023] tx session timer expired on tid 0
[  911.992057] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  912.012298] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  931.478394] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  931.496346] activated addBA response timer on tid 0
[  932.496100] addBA response timer expired on tid 0
[  932.496149] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  935.892151] switched off addBA timer for tid 0
[  935.892160] got addBA resp for tid 0 but we already gave up
[  935.892207] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  935.902372] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  935.912202] activated addBA response timer on tid 0
[  935.914010] switched off addBA timer for tid 0
[  935.914012] Aggregation is on for tid 0
[  946.972030] tx session timer expired on tid 0
[  946.972079] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  946.996293] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  957.025964] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  957.056276] activated addBA response timer on tid 0
[  957.058143] switched off addBA timer for tid 0
[  957.058149] Aggregation is on for tid 0
[  967.472028] tx session timer expired on tid 0
[  967.472069] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  967.508296] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  996.664073] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  996.672202] activated addBA response timer on tid 0
[  996.674167] switched off addBA timer for tid 0
[  996.674173] Aggregation is on for tid 0
[ 1002.008033] tx session timer expired on tid 0
[ 1002.008076] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1002.028299] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1051.699694] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1051.732280] activated addBA response timer on tid 0
[ 1052.732077] addBA response timer expired on tid 0
[ 1052.732105] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1055.908118] switched off addBA timer for tid 0
[ 1055.908126] got addBA resp for tid 0 but we already gave up
[ 1055.908173] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1068.701488] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1068.732250] activated addBA response timer on tid 0
[ 1068.734110] switched off addBA timer for tid 0
[ 1068.734116] Aggregation is on for tid 0
[ 1079.024062] tx session timer expired on tid 0
[ 1079.024109] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1079.056276] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1116.716696] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1116.736346] activated addBA response timer on tid 0
[ 1116.738258] switched off addBA timer for tid 0
[ 1116.738265] Aggregation is on for tid 0
[ 1121.908042] tx session timer expired on tid 0
[ 1121.908084] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1121.920195] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1130.839113] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1130.856186] activated addBA response timer on tid 0
[ 1130.858090] switched off addBA timer for tid 0
[ 1130.858092] Aggregation is on for tid 0
[ 1137.504065] tx session timer expired on tid 0
[ 1137.504094] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1137.528217] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1188.853434] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1188.868312] activated addBA response timer on tid 0
[ 1188.870219] switched off addBA timer for tid 0
[ 1188.870225] Aggregation is on for tid 0
[ 1202.572069] tx session timer expired on tid 0
[ 1202.572112] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1202.588311] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1205.842236] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1205.860248] activated addBA response timer on tid 0
[ 1205.862276] switched off addBA timer for tid 0
[ 1205.862281] Aggregation is on for tid 0
[ 1219.611200] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1219.640915] Rx A-MPDU request on tid 0 result 0
[ 1219.652704] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1219.668255] Rx A-MPDU request on tid 0 result 0
[ 1220.183679] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1220.192230] Rx A-MPDU request on tid 0 result 0
[ 1220.633590] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1220.787950] Rx A-MPDU request on tid 0 result 0
[ 1228.728530] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1228.809410] Rx A-MPDU request on tid 0 result 0
[ 1228.852826] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1229.085139] Rx A-MPDU request on tid 0 result 0
[ 1230.503937] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1230.745132] Rx A-MPDU request on tid 0 result 0
[ 1250.604674] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1251.863016] Rx A-MPDU request on tid 0 result 0
[ 1251.947364] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1252.290963] Rx A-MPDU request on tid 0 result 0
[ 1252.329981] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1253.455024] Rx A-MPDU request on tid 0 result 0
[ 1253.935912] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1255.279219] Rx A-MPDU request on tid 0 result 0
[ 1255.448164] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1256.083286] Rx A-MPDU request on tid 0 result 0
[ 1256.307717] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1256.763290] Rx A-MPDU request on tid 0 result 0
[ 1257.059071] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1257.267242] Rx A-MPDU request on tid 0 result 0
[ 1257.916762] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1258.235389] Rx A-MPDU request on tid 0 result 0
[ 1258.421010] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1260.151685] Rx A-MPDU request on tid 0 result 0
[ 1261.537236] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1265.396031] tx session timer expired on tid 0
[ 1265.396091] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1265.420304] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1267.540420] Rx A-MPDU request on tid 0 result 0
[ 1268.112599] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1269.888616] Rx A-MPDU request on tid 0 result 0
[ 1271.879324] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1272.472915] Rx A-MPDU request on tid 0 result 0
[ 1272.834556] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1278.962095] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1278.992238] activated addBA response timer on tid 0
[ 1278.994465] switched off addBA timer for tid 0
[ 1278.994471] Aggregation is on for tid 0
[ 1284.128028] tx session timer expired on tid 0
[ 1284.128081] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1284.136166] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1291.113670] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1291.128236] activated addBA response timer on tid 0
[ 1292.128061] addBA response timer expired on tid 0
[ 1292.128090] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 1295.952061] switched off addBA timer for tid 0
[ 1295.952069] got addBA resp for tid 0 but we already gave up
[ 1295.952139] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 1301.997218] Rx A-MPDU request on tid 0 result 0
[ 1302.311441] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1302.695714] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 1302.712940] activated addBA response timer on tid 0
[ 1302.714749] switched off addBA timer for tid 0
[ 1302.714751] Aggregation is on for tid 0
[ 1302.868055] Rx A-MPDU request on tid 0 result 0
[ 1305.905814] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1306.304384] Rx A-MPDU request on tid 0 result 0
[ 1308.044965] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1309.005987] Rx A-MPDU request on tid 0 result 0
[ 1309.138988] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1310.512800] Rx A-MPDU request on tid 0 result 0
[ 1311.568780] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1312.180963] Rx A-MPDU request on tid 0 result 0
[ 1312.595070] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1314.345134] Rx A-MPDU request on tid 0 result 0
[ 1314.871701] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1315.317486] Rx A-MPDU request on tid 0 result 0
[ 1315.455485] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1315.617855] Rx A-MPDU request on tid 0 result 0
[ 1315.759023] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1315.913446] Rx A-MPDU request on tid 0 result 0
[ 1316.051602] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1316.105381] Rx A-MPDU request on tid 0 result 0
[ 1316.246593] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1316.453412] Rx A-MPDU request on tid 0 result 0
[ 1316.645651] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1316.765334] Rx A-MPDU request on tid 0 result 0
[ 1316.879960] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1317.341497] Rx A-MPDU request on tid 0 result 0
[ 1317.698354] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1318.137662] Rx A-MPDU request on tid 0 result 0
[ 1318.282442] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1318.337572] Rx A-MPDU request on tid 0 result 0
[ 1318.602768] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1318.689813] Rx A-MPDU request on tid 0 result 0
[ 1318.829183] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1318.885552] Rx A-MPDU request on tid 0 result 0
[ 1318.897440] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1318.998340] Rx A-MPDU request on tid 0 result 0
[ 1319.849545] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
[ 1319.849820] Rx A-MPDU request on tid 0 result 0
[ 1320.024218] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1321.285843] Rx A-MPDU request on tid 0 result 0
[ 1321.354509] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1321.813911] Rx A-MPDU request on tid 0 result 0
[ 1321.958338] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1324.502158] Rx A-MPDU request on tid 0 result 0
[ 1324.781588] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1327.882374] Rx A-MPDU request on tid 0 result 0
[ 1328.851063] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1334.359659] Rx A-MPDU request on tid 0 result 0
[ 1334.442784] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
[ 1334.443055] Rx A-MPDU request on tid 0 result 0
[ 1335.236228] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1336.279440] Rx A-MPDU request on tid 0 result 0
[ 1337.359458] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1338.787441] Rx A-MPDU request on tid 0 result 0
[ 1338.902301] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1338.951462] Rx A-MPDU request on tid 0 result 0
[ 1339.114149] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1339.143323] Rx A-MPDU request on tid 0 result 0
[ 1339.614671] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1339.888483] Rx A-MPDU request on tid 0 result 0
[ 1340.520279] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1341.028517] Rx A-MPDU request on tid 0 result 0
[ 1341.282571] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1341.588025] Rx A-MPDU request on tid 0 result 0
[ 1341.794666] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1342.039485] Rx A-MPDU request on tid 0 result 0
[ 1342.620671] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1343.067653] Rx A-MPDU request on tid 0 result 0
[ 1343.072591] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1343.455750] Rx A-MPDU request on tid 0 result 0
[ 1343.461169] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1344.015842] Rx A-MPDU request on tid 0 result 0
[ 1344.020901] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1344.035804] Rx A-MPDU request on tid 0 result 0
[ 1344.046268] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1344.497040] Rx A-MPDU request on tid 0 result 0
[ 1344.501908] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1346.240193] Rx A-MPDU request on tid 0 result 0
[ 1346.292049] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1348.252199] Rx A-MPDU request on tid 0 result 0
[ 1348.382382] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1348.508178] Rx A-MPDU request on tid 0 result 0
[ 1348.769494] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1348.788090] Rx A-MPDU request on tid 0 result 0
[ 1348.938350] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1349.105715] Rx A-MPDU request on tid 0 result 0
[ 1349.169052] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1349.692245] Rx A-MPDU request on tid 0 result 0
[ 1351.188910] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 1351.392419] Rx A-MPDU request on tid 0 result 0
[ 1354.645239] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0

At that point I removed the iwlwifi module, and reloaded it with 
11n_disable=1 again, otherwise nothing would work at all...

It is a pity that this is a problem now since 2.6.38 when I reported it
the first time as far as I remember, it is such a long time ...

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CONDOVER (n.)
One who is employed to stand about all day browsing through the
magazine racks in the newsagent.
			--- Douglas Adams, The Meaning of Liff

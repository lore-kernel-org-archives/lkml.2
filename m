Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1KHAbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:31:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:54579 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab1KHAbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:31:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208,223";a="72153466"
Subject: Re: iwlagn is getting very shaky
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20111107123812.GB23508@gamma.logic.tuwien.ac.at>
References: <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	 <1319119852.2111.2.camel@wwguy-ubuntu>
	 <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
	 <20111026025014.GB24956@gamma.logic.tuwien.ac.at>
	 <1319601333.14693.19.camel@wwguy-ubuntu>
	 <20111026040332.GF24956@gamma.logic.tuwien.ac.at>
	 <20111102031345.GA10851@gamma.logic.tuwien.ac.at>
	 <1320204101.31823.140.camel@wwguy-huron>
	 <20111104045817.GA25778@gamma.logic.tuwien.ac.at>
	 <20111107123812.GB23508@gamma.logic.tuwien.ac.at>
Content-Type: multipart/mixed; boundary="=-65tkLizIybG1GJvZe6Ah"
Date: Mon, 07 Nov 2011 15:37:27 -0800
Message-ID: <1320709047.31823.188.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-65tkLizIybG1GJvZe6Ah
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi Norbert,

Could you please try with this patch?

Thanks
Wey

On Mon, 2011-11-07 at 04:38 -0800, Norbert Preining wrote:
> Hi Wey, hi all,
> 
> On Fr, 04 Nov 2011, Norbert Preining wrote:
> > > after the firmware reloaded, is the traffic resume? or it is continuous
> > > without traffic?
> > 
> > Ok, I compiled a new kernel from todays git, and I see that there 
> > are kernel bugs, but after the hardware restart traffic gets through.
> 
> Well, not always actually. I just had *at*home*, were it used to work
> without any flaws till 3.1, I saw that after resume it worked for a 
> short time, then the queue got stuck, then not even forcing a reset via
> the /ss/kernel/debug/..../iwlwifi/debug/force_reset did work. Only 
> an unload and reload of the module, followed by a few more hickups,
> restarted the wlan card:
> 
> [ 6564.905884] PM: Finishing wakeup.
> [ 6564.905889] Restarting tasks ... done.
> [ 6564.924087] video LNXVIDEO:00: Restoring backlight state
> [ 6566.045358] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [ 6566.100108] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [ 6566.101277] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [ 6566.105210] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [ 6573.822081] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
> [ 6573.829824] wlan0: authenticated
> [ 6573.835543] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
> [ 6573.841527] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
> [ 6573.841537] wlan0: associated
> 
> Here it worked for a bit, 20secs
> 
> [ 6593.731625] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
> [ 6603.704072] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
> [ 6603.704084] iwlwifi 0000:06:00.0: Current read_ptr 249 write_ptr 14
> [ 6603.704092] iwlwifi 0000:06:00.0: On demand firmware reload
> [ 6603.704566] ieee80211 phy0: Hardware restart was requested
> [ 6603.704680] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [ 6603.707700] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> 
> Here I forced the reset
> 
> [ 6774.772656] iwlwifi 0000:06:00.0: On demand firmware reload
> [ 6774.773868] ieee80211 phy0: Hardware restart was requested
> [ 6774.773958] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [ 6774.777053] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> 
> unloading and reloading
> 
> [ 6823.909282] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
> [ 6823.976417] cfg80211: Calling CRDA for country: JP
> [ 6824.037466] iwlwifi 0000:06:00.0: PCI INT A disabled
> [ 6830.344831] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
> [ 6830.344835] Copyright(c) 2003-2011 Intel Corporation
> [ 6830.344941] iwlwifi 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 6830.344974] iwlwifi 0000:06:00.0: setting latency timer to 64
> [ 6830.345174] iwlwifi 0000:06:00.0: pci_resource_len = 0x00002000
> [ 6830.345176] iwlwifi 0000:06:00.0: pci_resource_base = ffffc90000048000
> [ 6830.345179] iwlwifi 0000:06:00.0: HW Revision ID = 0x0
> [ 6830.345292] iwlwifi 0000:06:00.0: irq 46 for MSI/MSI-X
> [ 6830.345369] iwlwifi 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
> [ 6830.345467] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [ 6830.367544] iwlwifi 0000:06:00.0: device EEPROM VER=0x11e, CALIB=0x4
> [ 6830.367547] iwlwifi 0000:06:00.0: Device SKU: 0Xf0
> [ 6830.367557] iwlwifi 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [ 6830.425994] iwlwifi 0000:06:00.0: loaded firmware version 8.83.5.1 build 33692 (EXP)
> [ 6830.426214] Registered led device: phy1-led
> [ 6830.426519] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
> 
> more hickups
> 
> [ 6830.518627] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [ 6830.522336] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [ 6830.636966] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [ 6830.640324] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [ 6838.327066] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
> [ 6838.330447] wlan0: authenticated
> [ 6838.335890] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
> [ 6838.341503] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
> [ 6838.341507] wlan0: associated
> 
> finally got it working, one more final hickup
> 
> [ 6860.602423] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
> 
> from now on working
> 
> Would be great to fix that for 3.2
> 
> Herzliche Grüße
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> PEEBLES (pl.n.)
> Small, carefully rolled pellets of skegness (q.v.)
> 			--- Douglas Adams, The Meaning of Liff


--=-65tkLizIybG1GJvZe6Ah
Content-Type: application/mbox; name*0="[Internal-wifi-devel]_[PATCH]_iwlwifi:_check_the_HW_when_a_queue_"; name*1="is_stuck"
Content-Disposition: attachment; filename*0="[Internal-wifi-devel]_[PATCH]_iwlwifi:_check_the_HW_when_a_qu"; filename*1="eue_is_stuck"
Content-Transfer-Encoding: 7bit

>From internal-wifi-devel-bounces@linux.intel.com Mon Nov  7 06:21:29 2011
Received: from fmsmga001.fm.intel.com (10.253.24.23) by
 orsmsx601-2.jf.intel.com (10.22.226.227) with Microsoft SMTP Server id
 8.2.255.0; Mon, 7 Nov 2011 06:21:29 -0800
Received: from linux.jf.intel.com (HELO linux.intel.com) ([10.23.219.25]) 
 by fmsmga001.fm.intel.com with ESMTP; 07 Nov 2011 06:21:11 -0800
Received: from linux.intel.com (linux.intel.com [127.0.0.1])	by
 linux.intel.com (Postfix) with ESMTP id 5EAC06A4087;	Mon,  7 Nov 2011
 06:21:08 -0800 (PST)
Received: from orsmga001.jf.intel.com (orsmga001.jf.intel.com
 [10.7.209.18]) by linux.intel.com (Postfix) with ESMTP id 8ADB22C8001	for
 <internal-wifi-devel@linux.intel.com>;	Mon,  7 Nov 2011 06:21:07 -0800 (PST)
Received: from iapp029.jer.intel.com (HELO localhost.localdomain)
 ([10.12.252.35])	by orsmga001.jf.intel.com with ESMTP; 07 Nov 2011 06:21:09
 -0800
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "internal-wifi-devel@linux.intel.com" <internal-wifi-devel@linux.intel.com>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Sender: "internal-wifi-devel-bounces@linux.intel.com"
 <internal-wifi-devel-bounces@linux.intel.com>
Date: Mon, 7 Nov 2011 06:21:09 -0800
Subject: [Internal-wifi-devel] [PATCH] iwlwifi: check the HW when a queue
 is stuck
Thread-Topic: [Internal-wifi-devel] [PATCH] iwlwifi: check the HW when a
 queue is	stuck
Thread-Index: AcydWIoLYpp5tuudToSAcN3uQH6MhA==
Message-ID: <1320675669-22656-1-git-send-email-emmanuel.grumbach@intel.com>
List-Help: <mailto:internal-wifi-devel-request@linux.intel.com?subject=help>
List-Subscribe:
 <http://linux.intel.com/mailman/listinfo/internal-wifi-devel>,
 <mailto:internal-wifi-devel-request@linux.intel.com?subject=subscribe>
List-Unsubscribe:
 <http://linux.intel.com/mailman/listinfo/internal-wifi-devel>,
 <mailto:internal-wifi-devel-request@linux.intel.com?subject=unsubscribe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: orsmsx601.amr.corp.intel.com
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.67,352,1309762800"; d="scan'208";a="71924412"
x-extloop1: 1
x-extloopcount2: 2 from 10.23.219.25
errors-to: internal-wifi-devel-bounces@linux.intel.com
list-id: internal wifi development mailing list
 <internal-wifi-devel.linux.intel.com>
list-post: <mailto:internal-wifi-devel@linux.intel.com>
list-archive: <http://linux.intel.com/pipermail/internal-wifi-devel>
x-original-to: internal-wifi-devel@linux.intel.com
delivered-to: internal-wifi-devel@localhost.localdomain
x-beenthere: internal-wifi-devel@linux.intel.com
x-mailman-version: 2.1.5
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Evolution-Source: imap://wwguy@imapmail.intel.com/
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add more information when a queue is stuck and actually get
information from the scheduler instead of looking at internal
variables.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 93c4f56..f415477 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1516,8 +1516,12 @@ static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
 	if (time_after(jiffies, timeout)) {
 		IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
 			hw_params(trans).wd_timeout);
-		IWL_ERR(trans, "Current read_ptr %d write_ptr %d\n",
+		IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
 			q->read_ptr, q->write_ptr);
+		IWL_ERR(trans, "Current HW read_ptr %d write_ptr %d\n",
+			iwl_read_prph(bus(trans), SCD_QUEUE_RDPTR(cnt))
+				& (TFD_QUEUE_SIZE_MAX - 1),
+			iwl_read_prph(bus(trans), SCD_QUEUE_WRPTR(cnt)));
 		return 1;
 	}
 
-- 
1.7.1

_______________________________________________
internal-wifi-devel mailing list
internal-wifi-devel@linux.intel.com
http://linux.intel.com/mailman/listinfo/internal-wifi-devel


--=-65tkLizIybG1GJvZe6Ah--


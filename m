Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1KGMi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:38:26 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:39687 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1KGMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:38:24 -0500
Date: Mon, 7 Nov 2011 21:38:12 +0900
From: Norbert Preining <preining@logic.at>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111107123812.GB23508@gamma.logic.tuwien.ac.at>
References: <20111020045927.GB23044@gamma.logic.tuwien.ac.at> <1319119852.2111.2.camel@wwguy-ubuntu> <20111021012442.GB26758@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com> <20111026025014.GB24956@gamma.logic.tuwien.ac.at> <1319601333.14693.19.camel@wwguy-ubuntu> <20111026040332.GF24956@gamma.logic.tuwien.ac.at> <20111102031345.GA10851@gamma.logic.tuwien.ac.at> <1320204101.31823.140.camel@wwguy-huron> <20111104045817.GA25778@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111104045817.GA25778@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wey, hi all,

On Fr, 04 Nov 2011, Norbert Preining wrote:
> > after the firmware reloaded, is the traffic resume? or it is continuous
> > without traffic?
> 
> Ok, I compiled a new kernel from todays git, and I see that there 
> are kernel bugs, but after the hardware restart traffic gets through.

Well, not always actually. I just had *at*home*, were it used to work
without any flaws till 3.1, I saw that after resume it worked for a 
short time, then the queue got stuck, then not even forcing a reset via
the /ss/kernel/debug/..../iwlwifi/debug/force_reset did work. Only 
an unload and reload of the module, followed by a few more hickups,
restarted the wlan card:

[ 6564.905884] PM: Finishing wakeup.
[ 6564.905889] Restarting tasks ... done.
[ 6564.924087] video LNXVIDEO:00: Restoring backlight state
[ 6566.045358] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[ 6566.100108] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[ 6566.101277] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 6566.105210] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[ 6573.822081] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[ 6573.829824] wlan0: authenticated
[ 6573.835543] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[ 6573.841527] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
[ 6573.841537] wlan0: associated

Here it worked for a bit, 20secs

[ 6593.731625] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[ 6603.704072] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[ 6603.704084] iwlwifi 0000:06:00.0: Current read_ptr 249 write_ptr 14
[ 6603.704092] iwlwifi 0000:06:00.0: On demand firmware reload
[ 6603.704566] ieee80211 phy0: Hardware restart was requested
[ 6603.704680] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 6603.707700] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0

Here I forced the reset

[ 6774.772656] iwlwifi 0000:06:00.0: On demand firmware reload
[ 6774.773868] ieee80211 phy0: Hardware restart was requested
[ 6774.773958] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 6774.777053] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0

unloading and reloading

[ 6823.909282] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
[ 6823.976417] cfg80211: Calling CRDA for country: JP
[ 6824.037466] iwlwifi 0000:06:00.0: PCI INT A disabled
[ 6830.344831] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[ 6830.344835] Copyright(c) 2003-2011 Intel Corporation
[ 6830.344941] iwlwifi 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 6830.344974] iwlwifi 0000:06:00.0: setting latency timer to 64
[ 6830.345174] iwlwifi 0000:06:00.0: pci_resource_len = 0x00002000
[ 6830.345176] iwlwifi 0000:06:00.0: pci_resource_base = ffffc90000048000
[ 6830.345179] iwlwifi 0000:06:00.0: HW Revision ID = 0x0
[ 6830.345292] iwlwifi 0000:06:00.0: irq 46 for MSI/MSI-X
[ 6830.345369] iwlwifi 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[ 6830.345467] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 6830.367544] iwlwifi 0000:06:00.0: device EEPROM VER=0x11e, CALIB=0x4
[ 6830.367547] iwlwifi 0000:06:00.0: Device SKU: 0Xf0
[ 6830.367557] iwlwifi 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[ 6830.425994] iwlwifi 0000:06:00.0: loaded firmware version 8.83.5.1 build 33692 (EXP)
[ 6830.426214] Registered led device: phy1-led
[ 6830.426519] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'

more hickups

[ 6830.518627] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 6830.522336] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[ 6830.636966] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 6830.640324] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[ 6838.327066] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[ 6838.330447] wlan0: authenticated
[ 6838.335890] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[ 6838.341503] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
[ 6838.341507] wlan0: associated

finally got it working, one more final hickup

[ 6860.602423] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0

from now on working

Would be great to fix that for 3.2

Herzliche Grüße

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
PEEBLES (pl.n.)
Small, carefully rolled pellets of skegness (q.v.)
			--- Douglas Adams, The Meaning of Liff

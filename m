Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2AZX0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:26:13 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53713 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2AZX0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:26:12 -0500
Date: Fri, 27 Jan 2012 08:25:55 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120126232555.GB16330@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at> <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com> <20120125002250.GA20431@gamma.logic.tuwien.ac.at> <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com> <20120126003735.GA2346@gamma.logic.tuwien.ac.at> <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com> <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

On Do, 26 Jan 2012, Emmanuel Grumbach wrote:
> are suffering from the same issue. I am merging the mail threads here.

First tests are promising, after reboot it was working immediately
without need to rfkill block/unblock. lso after suspend and resume.

Will test more the next days and report back.

dmesg output without debugging still the same, but connection 
continues without any problem:
[   62.437916] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[   62.456184] activated addBA response timer on tid 0
[   63.456042] addBA response timer expired on tid 0
[   63.456063] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[   67.008297] switched off addBA timer for tid 0
[   67.008305] got addBA resp for tid 0 but we already gave up
[   67.008340] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[   67.015503] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[   67.031648] activated addBA response timer on tid 0
[   67.129907] switched off addBA timer for tid 0
[   67.129914] Aggregation is on for tid 0
[   67.130076] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  100.288018] tx session timer expired on tid 0
[  100.288032] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  106.347302] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  106.374760] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  106.388178] activated addBA response timer on tid 0
[  106.390041] switched off addBA timer for tid 0
[  106.390044] Aggregation is on for tid 0
[  106.390193] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[  135.786765] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[  135.804164] activated addBA response timer on tid 6
[  135.806088] switched off addBA timer for tid 6
[  135.806092] Aggregation is on for tid 6
[  135.806241] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[  146.912031] tx session timer expired on tid 6
[  146.912071] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[  146.924187] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[  256.560100] tx session timer expired on tid 0
[  256.560132] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[  256.584379] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[  258.477345] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[  258.500189] activated addBA response timer on tid 0
[  258.502148] switched off addBA timer for tid 0
[  258.502151] Aggregation is on for tid 0
[  258.502340] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0

Later on after resume I got a few hickups but the connection just
hang for a shor ttime, then came back:
[  589.895086] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
[  589.895095] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  589.900879] Rx A-MPDU request on tid 0 result 0
[  589.900950] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
[  589.900958] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
[  589.902649] Rx A-MPDU request on tid 0 result 0
[  589.902690] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
[  589.902698] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
[  589.903732] Rx A-MPDU request on tid 0 result 0
[  589.903810] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
[  589.903817] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
[  589.904965] Rx A-MPDU request on tid 0 result 0
[  589.905045] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
[  589.905053] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
[  589.906510] Rx A-MPDU request on tid 0 result 0
[  590.456062] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  590.456075] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  590.456083] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
[  594.413810] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
[  594.413822] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  594.428073] Rx A-MPDU request on tid 0 result 0


Generally fine.

Thanks, more reports later.

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
FAIRYMOUNT (vb.n.)
Polite word for buggery.
			--- Douglas Adams, The Meaning of Liff

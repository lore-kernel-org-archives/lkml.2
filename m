Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1K1XZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:25:44 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56998 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab1K1XZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:25:43 -0500
Date: Tue, 29 Nov 2011 08:25:25 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111128232525.GA12719@gamma.logic.tuwien.ac.at>
References: <20111125122143.GA30404@gamma.logic.tuwien.ac.at> <CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com> <20111125123720.GA31564@gamma.logic.tuwien.ac.at> <CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com> <CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com> <1322387175.4044.16.camel@jlt3.sipsolutions.net> <CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com> <20111128035627.GH1422@gamma.logic.tuwien.ac.at> <CANUX_P2kYiFCP8uAhLZC_kVEjoyxabRBx3Pn+ndtFus=6hJN7Q@mail.gmail.com> <20111128042343.GA4619@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128042343.GA4619@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel, hi all,

On Mo, 28 Nov 2011, Norbert Preining wrote:
> I will report more after a few suspend/resume iteations.

Ok, here we go. First of all, it seems that the problem is solved
inthe sense that the connection stays alive all the time and does not
disappear. OTOH, I now get quite a lot of messages, that might point
either to a broken AP here, or something else:

After resume I see:
[ 3995.266230] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 3995.270239] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[ 4002.943037] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[ 4002.945672] wlan0: authenticated
[ 4002.951806] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[ 4002.964652] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
[ 4002.964662] wlan0: associated
[ 4007.088934] Rx A-MPDU request on tid 0 result 0

then it starts with these, and there are *many* of them, literally
several hundreds 
[ 4019.340036] ieee80211 phy1: release an RX reorder frame due to timeout on earlier frames

Intersperesed I see some other messages that are new to me:
[ 4019.443129] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 4019.500149] activated addBA response timer on tid 0
[ 4020.500033] addBA response timer expired on tid 0
[ 4020.501626] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 4023.740570] switched off addBA timer for tid 0
[ 4023.740578] got addBA resp for tid 0 but we already gave up
[ 4023.740619] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 4023.768544] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 4023.784292] activated addBA response timer on tid 0
[ 4023.786294] switched off addBA timer for tid 0
[ 4023.786301] Aggregation is on for tid 0
[ 4023.786480] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0


[ 4107.143615] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[ 4107.180359] activated addBA response timer on tid 6
[ 4107.182333] switched off addBA timer for tid 6
[ 4107.182338] Aggregation is on for tid 6
[ 4107.182567] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[ 4124.093846] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
[ 4124.093856] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 4124.094270] Rx A-MPDU request on tid 0 result 0
[ 4210.670921] wlan0: deauthenticated from 00:0a:79:eb:56:10 (Reason: 6)
[ 4210.670941] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 4210.671083] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 4210.671258] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[ 4210.685078] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 4210.685091] iwlwifi 0000:06:00.0: Stopping AGG while state not ON or starting for 0 on 0 (0)
[ 4210.685105] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
[ 4210.685114] iwlwifi 0000:06:00.0: Stopping AGG while state not ON or starting for 0 on 6 (0)
[ 4210.808184] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[ 4210.808192] Could not find station: 00:0a:79:eb:56:10
[ 4210.808200] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
[ 4210.808205] Could not find station: 00:0a:79:eb:56:10
[ 4210.808257] cfg80211: Calling CRDA for country: JP
[ 4214.051615] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[ 4214.054149] wlan0: authenticated
[ 4214.057681] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[ 4214.063430] wlan0: RX ReassocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
[ 4214.063434] wlan0: associated
[ 4218.780329] Rx A-MPDU request on tid 0 result 0
[ 4219.800527] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[ 4219.816203] activated addBA response timer on tid 0
[ 4219.818148] switched off addBA timer for tid 0
[ 4219.818156] Aggregation is on for tid 0
[ 4219.818365] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0


[ 4329.425781] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
[ 4329.425791] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 4334.433017] Rx A-MPDU request on tid 0 result 0
[ 4438.143959] Open BA session requested for 00:0a:79:eb:56:10 tid 6
[ 4438.176193] activated addBA response timer on tid 6
[ 4438.178140] switched off addBA timer for tid 6
[ 4438.178146] Aggregation is on for tid 6
[ 4438.178343] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6



[ 4966.073860] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
[ 4966.073870] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[ 4966.116071] Rx A-MPDU request on tid 0 result 0


At the end there are mostly two lines, the
[ 5983.321525] net_ratelimit: 1 callbacks suppressed
[ 5983.321537] ieee80211 phy1: release an RX reorder frame due to timeout on earlier frames

Where for every 10-20 of the second one there is one of the first one.

=============================
Anyway, the connection might stumble now and then a bit, but it does
not break down, so I don't complain ;-)

BIG THANKS to everyone!!!


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
Prostetnic Vogon Jeltz smiled very slowly. This was done
not so much for effect as because he was trying to remember
the sequence of muscle movements.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy

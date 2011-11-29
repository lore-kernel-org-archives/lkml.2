Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1K2Ie2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:34:28 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:36455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1K2Ie1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:34:27 -0500
Subject: Re: iwlagn is getting very shaky
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Norbert Preining <preining@logic.at>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
In-Reply-To: <CANUX_P2b_ZYr4hHigA+tGa9uakcq3hQXnOiP5isQtfcYxCaxcw@mail.gmail.com> (sfid-20111129_075940_672404_AD87EAAF)
References: <20111125122143.GA30404@gamma.logic.tuwien.ac.at>
	 <CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
	 <20111125123720.GA31564@gamma.logic.tuwien.ac.at>
	 <CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
	 <CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com>
	 <1322387175.4044.16.camel@jlt3.sipsolutions.net>
	 <CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com>
	 <20111128035627.GH1422@gamma.logic.tuwien.ac.at>
	 <CANUX_P2kYiFCP8uAhLZC_kVEjoyxabRBx3Pn+ndtFus=6hJN7Q@mail.gmail.com>
	 <20111128042343.GA4619@gamma.logic.tuwien.ac.at>
	 <20111128232525.GA12719@gamma.logic.tuwien.ac.at>
	 <CANUX_P2b_ZYr4hHigA+tGa9uakcq3hQXnOiP5isQtfcYxCaxcw@mail.gmail.com>
	 (sfid-20111129_075940_672404_AD87EAAF)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 09:31:12 +0100
Message-ID: <1322555472.4110.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the logs are a bit odd wrt. timing.

> > Intersperesed I see some other messages that are new to me:
> > [ 4019.443129] Open BA session requested for 00:0a:79:eb:56:10 tid 0
> > [ 4019.500149] activated addBA response timer on tid 0
> > [ 4020.500033] addBA response timer expired on tid 0

I guess the delay here is due to the synchronize_net()? That can take a
while, 57ms seems a lot but I suppose it's possible.

> > [ 4020.501626] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
> > [ 4023.740570] switched off addBA timer for tid 0
> > [ 4023.740578] got addBA resp for tid 0 but we already gave up
> 
> Here is the AP is finally replying

It's kinda hard to believe that the AP took 4 seconds (!) to reply to
the frame. Where could the frame get stuck? I don't see any other work
processing happening etc. either. It's also curious that in those 3
seconds between these messages, we didn't actually get around to
stopping the session, that only happens just after:

> > [ 4023.740619] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0

(here)

> > [ 4023.768544] Open BA session requested for 00:0a:79:eb:56:10 tid 0
> 
> Here we are trying again
> 
> > [ 4023.784292] activated addBA response timer on tid 0
> > [ 4023.786294] switched off addBA timer for tid 0

20ms response time here, that's much more reasonable.


Could something be hogging the workqueues?

johannes


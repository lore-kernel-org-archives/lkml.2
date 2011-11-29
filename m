Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1K2JTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:19:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48495 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1K2JTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:19:02 -0500
MIME-Version: 1.0
In-Reply-To: <1322555472.4110.8.camel@jlt3.sipsolutions.net>
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
	<1322555472.4110.8.camel@jlt3.sipsolutions.net>
Date: Tue, 29 Nov 2011 11:19:00 +0200
Message-ID: <CANUX_P0z9HmZSj_13Fv0LHUgy2UDXWMaj8L2Tgqz2jQC2mbpZw@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Norbert Preining <preining@logic.at>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:31, Johannes Berg <johannes@sipsolutions.net> wrote:
> I noticed that the logs are a bit odd wrt. timing.
>
>> > Intersperesed I see some other messages that are new to me:
>> > [ 4019.443129] Open BA session requested for 00:0a:79:eb:56:10 tid 0
>> > [ 4019.500149] activated addBA response timer on tid 0
>> > [ 4020.500033] addBA response timer expired on tid 0
>
> I guess the delay here is due to the synchronize_net()? That can take a
> while, 57ms seems a lot but I suppose it's possible.
>
>> > [ 4020.501626] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
>> > [ 4023.740570] switched off addBA timer for tid 0
>> > [ 4023.740578] got addBA resp for tid 0 but we already gave up
>>
>> Here is the AP is finally replying
>
> It's kinda hard to believe that the AP took 4 seconds (!) to reply to
> the frame. Where could the frame get stuck? I don't see any other work
> processing happening etc. either. It's also curious that in those 3
> seconds between these messages, we didn't actually get around to
> stopping the session, that only happens just after:

Yeah you are right, didn't look at the timestamps. Not sure you would
see work being processed though.

>
>> > [ 4023.740619] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
>
> (here)
>
>> > [ 4023.768544] Open BA session requested for 00:0a:79:eb:56:10 tid 0
>>
>> Here we are trying again
>>
>> > [ 4023.784292] activated addBA response timer on tid 0
>> > [ 4023.786294] switched off addBA timer for tid 0
>
> 20ms response time here, that's much more reasonable.
>
>
> Could something be hogging the workqueues?
>

Frankly, I am seeing issues that seem to point to workqueues too.
Sometimes mac80211 seems just not responsive.
Sometimes I come back to mac80211 for the AGG callback (start or
stop), and it takes ages (5 seconds !) until it actually move to
operationnal / stopped state.

It might that we are holding the mac80211 workqueue in the driver too...
I guess we could try to enable MAC80211 debug flag with timestamps to check.

> johannes
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0ICODw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:03:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0ICODv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:03:51 -0400
Date: Fri, 3 Sep 2010 10:03:30 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second event
 on intel perf counter
Message-ID: <20100903140330.GW4879@redhat.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
 <20100901145728.GM22783@erda.amd.com>
 <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
 <20100902141900.GG4879@redhat.com>
 <AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
 <1283502783.1783.172.camel@laptop>
 <AANLkTimyk1PvCBQzqcmcqL7HetXso=_akKvrUM0+hOoD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimyk1PvCBQzqcmcqL7HetXso=_akKvrUM0+hOoD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 01:02:49PM +0200, Stephane Eranian wrote:
> Here is an example of what I gathered on a Westmere:
> 
> This is coming into the interrupt handler:
> - status   = overflow status coming from GLOBAL_OVF_STATUS
> - status2 = inspection of the counters
> - act = cpuc->active_mask[0]
> 
> In case both status don't match, I dump the state of the active events
> incl. the counter values(val).
> 
> [  822.813808] CPU2 irqin status=0x6 status2=0x4 act=0x7
> [  822.813818] CPU2 cfg=0x13003c idx=0 sel=53003c val=ffffa833f298
> [  822.813821] CPU2 cfg=0x12003c idx=1 sel=52003c val=fffffe130229
> [  822.813823] CPU2 cfg=0x11003c idx=2 sel=51003c val=5e9
> 
> Here only counter2 has overflowed, yet the handler will also process counter1
> which is wrong.

Hmm, the test case I used was 'perf top'.  This was only using perf
counter0.  So I am not sure, at least in my case, it was a stale event.
Though I don't think I remember checking the status immediately after
acking it just to verify the ack worked.

I'll poke some more on my machine today.

Cheers,
Don

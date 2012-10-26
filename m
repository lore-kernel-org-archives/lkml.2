Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2JZKET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:04:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45589 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2JZKER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:04:17 -0400
Date: Fri, 26 Oct 2012 12:04:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
Message-ID: <20121026100410.GA2661@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
 <1351172849.12171.10.camel@twins>
 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
 <1351241389.12171.45.camel@twins>
 <20121026092421.GB628@gmail.com>
 <1351244130.16863.7.camel@twins>
 <20121026094207.GA2179@gmail.com>
 <1351245264.16863.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351245264.16863.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2012-10-26 at 11:42 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2012-10-26 at 11:24 +0200, Ingo Molnar wrote:
> > > 
> > > > So can we control this by restricting the users and avoiding 
> > > > the overflow?
> > > > 
> > > > A 2^64 result should be a *huge* amount of space already for 
> > > > just about anything.
> > > 
> > > I _think_ something like: dl_runtime * dl_deadline < U64_MAX, 
> > > might do that. The question is, is this constraint usable? 
> > > Simplified that boils down to about 4 seconds each, which 
> > > sounds pretty much ok for most people -- but such statements 
> > > usually come back to bite you (640kb anybody...).
> > 
> > We could constrain the precision, not the maximum value.
> > 
> > Having a 4 seconds hard limit is one thing, only having 10 nsecs 
> > precision at 40 seconds is another.
> 
> That gets to be rather ugly I think.. for one it might 
> surprise people, secondly you get to have a bunch of 
> conditionals and shifts in that code path.

I don't think a limitation of precision to about 64 bits is a 
"surprise": it's high grade precision of 0.00000005 parts per 
trillion...

( As a comparison, there's ~13 parts per trillion amount of pure 
  gold dissolved in ocean water. )

> Personally I'd prefer to do the simple thing, esp. for a new 
> interface. So either do the hard limit or the u128 thing.

Given that the u128 thing, once it gets converted to machine 
instructions, is not simple *at all*, that leaves us with the 
hard limit.

> If we go with the hard limit, we can always address things 
> when people run into it and complain, at such a time we also 
> have a better view of people's uses and expectations methinks.

Indeed.

Thanks,

	Ingo

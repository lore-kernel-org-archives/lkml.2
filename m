Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab2JZJzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:55:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:40454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2JZJzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:55:20 -0400
Message-ID: <1351245264.16863.12.camel@twins>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
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
Date: Fri, 26 Oct 2012 11:54:24 +0200
In-Reply-To: <20121026094207.GA2179@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
	 <1351172849.12171.10.camel@twins>
	 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
	 <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>
	 <1351244130.16863.7.camel@twins> <20121026094207.GA2179@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 11:42 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2012-10-26 at 11:24 +0200, Ingo Molnar wrote:
> > 
> > > So can we control this by restricting the users and avoiding 
> > > the overflow?
> > > 
> > > A 2^64 result should be a *huge* amount of space already for 
> > > just about anything.
> > 
> > I _think_ something like: dl_runtime * dl_deadline < U64_MAX, 
> > might do that. The question is, is this constraint usable? 
> > Simplified that boils down to about 4 seconds each, which 
> > sounds pretty much ok for most people -- but such statements 
> > usually come back to bite you (640kb anybody...).
> 
> We could constrain the precision, not the maximum value.
> 
> Having a 4 seconds hard limit is one thing, only having 10 nsecs 
> precision at 40 seconds is another.

That gets to be rather ugly I think.. for one it might surprise people,
secondly you get to have a bunch of conditionals and shifts in that code
path.

Personally I'd prefer to do the simple thing, esp. for a new interface.
So either do the hard limit or the u128 thing.

If we go with the hard limit, we can always address things when people
run into it and complain, at such a time we also have a better view of
people's uses and expectations methinks.



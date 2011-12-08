Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855Ab1LHFZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 00:25:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33634 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1LHFZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 00:25:42 -0500
Date: Thu, 8 Dec 2011 06:23:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111208052354.GC9485@elte.hu>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
 <20111201221404.GC3365@kroah.com>
 <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
 <20111205141749.GC28866@elte.hu>
 <20111206214446.GD1247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206214446.GD1247@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> > Same goes for a whole lot of other crap that distros are 
> > carrying. Would we want to merge a different CPU scheduler 
> > or the 4g:4g patch or a completely new networking stack into 
> > drivers/staging/? I don't think so.
> 
> Distros have new CPU schedulers and are still dragging the 4g 
> split around?  A whole new networking stack would be 
> interesting, and if self-contained, possible :)

The point being, there's legitimate reasons to refuse crap to an 
area that *people care about* in a constructive manner.

There's no rejection of LTTNG in the "hey, go away, you are 
doing it wrong" fashion - we are not holding a monopoly on how 
instrumentation is supposed to be done and we've been wrong 
before.

There's a highly constructive, open attitude towards LTTNG and 
has been for years:

 " Mathieu, please split it up and integrate/unify it with the 
   existing instrumentation features of Linux - and if it 
   replaces existing stuff because an LTTNG component is 
   superior then so be it. "

Let me repeat it: there's no lack of willingness of cooperation 
from the kernel instrumentation subsystem side. There's a lack 
of movement from Mathieu - *he* is keeping LTTNG fragmented for 
barely justifyable technological reasons.

Thus there's absolutely no forward movement from having this in 
drivers/staging/ - in fact there's backwards movement: yet 
another instrumentation gadget with its own separate ABI and 
highly overlapping functionality, plus even less incentive for 
it to cooperate...

It is not the typical drivers/staging/ situation where there's 
either lack of work on a piece of code or some fundamental 
disagreement about the right model. LTTNG has been 
*intentionally* kept a separate entity, a separate brand, for 
whatever non-technical reasons. How will drivers/staging/ change 
that? It won't. It's a bit like VirtualBox really.

In short: this move only *increases* the incentive for LTTNG to 
stay fragmented and/or force modularization crap like the highly 
unfortunate situation of security modules ...

> > I.e. putting LTTNG into drivers/staging/ will not really 
> > solve anything - and in may in fact delay any sane technical 
> > resolution:
> > 
> > There's a difference between a driver that has to go into 
> > drivers/staging/ because nobody cares enough [and the driver 
> > isnt high quality enough yet], and a core kernel feature 
> > that we DO care about and which HAS BEEN REJECTED IN ITS 
> > FORM.
> 
> I didn't realize that lttng was rejected, when was that done?  
> I couldn't find it in the archives anywhere.

It wasnt resubmitted for years - see the pattern and see the 
problem? :-)

Merging it will cause even *less* cooperation, because of the 
reasons above and because LTTNG adds a parallel ABI.

> The fact that distros have been shipping and relying on it for 
> years shows that it is something that is needed, and it being 
> self-contained, makes it eligible for the staging tree.

LTT(NG) was simply the historically first tracing toolkit that 
embedded people got used to and there's still some inertia - and 
distros add a lot of crap that people find marginally useful
which perpetuates the fork if there's at least one active
developer behind it. Most of its functionality is available via
existing upstream functionality - and where not we are more than
willing to accomodate patches!

drivers/staging/ is a tool that i support in many (in fact most) 
cases - but i don't support it if it does harm.

I'm supposed to say 'no' to extra complexity more often, and 
this is definitely one of those cases:

Nacked-by: Ingo Molnar <mingo@elte.hu>

Also obviously NAK to the scheduler symbol export - that alone 
should tell you that it's not just a "driver" - it deeply hooks 
into the core kernel...

Please respect the NAK.

Thanks,

	Ingo

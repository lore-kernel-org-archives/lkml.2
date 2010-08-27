Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0H0ITt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:19:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43497 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752322Ab0H0ITr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:19:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18YV5Nt6fAYo97gEuKZqYjLFmCIpHb6uDmwnMsDZQ
	y5Azi+5E/Fn7Fg
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1282894960.1975.1666.camel@laptop>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop>  <20100826234910.GB4194@Krystal>
	 <1282894960.1975.1666.camel@laptop>
Content-Type: text/plain
Date: Fri, 27 Aug 2010 10:19:52 +0200
Message-Id: <1282897192.7185.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 09:42 +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-26 at 19:49 -0400, Mathieu Desnoyers wrote:
> > AFAIK, I don't think we would end up starving the system in any possible way.
> 
> Correct, it does maintain fairness.
> 
> > So far I cannot see a situation where selecting the next buddy would _not_ make
> > sense in any kind of input-driven wakeups (interactive, timer, disk, network,
> > etc). But maybe it's just a lack of imagination on my part. 
> 
> The risk is that you end up with always using next-buddy, and we tried
> that a while back and that didn't work well for some, Mike might
> remember.

I turned it off because it was ripping spread apart badly, and last
buddy did a better job of improving scalability without it.

> Also, when you use timers things like time-outs you really couldn't care
> less if its handled sooner rather than later.
> 
> Disk is usually so slow you really don't want to consider it
> interactive, but then sometimes you might,.. its a really hard problem.

(very hard)

> The only clear situation is the direct input, that's a direct link
> between the user and our wakeup chain and the user is always important.

Yeah, directly linked wakeups using next could be a good thing, but the
trouble with using any linkage to the user is that you have to pass it
on to reap benefit.. so when do you disconnect?

	-Mike


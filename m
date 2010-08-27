Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0H0Sco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:32:44 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41065 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752048Ab0H0Scm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:32:42 -0400
Date: Fri, 27 Aug 2010 14:32:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827183240.GC22679@Krystal>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain> <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826230934.GA4194@Krystal> <1282894655.1975.1650.camel@laptop> <20100827152125.GB14926@Krystal> <1282923686.1975.2780.camel@laptop> <20100827160946.GG14926@Krystal> <1282930072.1975.2962.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282930072.1975.2962.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:25:59 up 216 days, 21:02,  4 users,  load average: 0.04, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-08-27 at 12:09 -0400, Mathieu Desnoyers wrote:
> > > The specification also doesn't cover the case where the handler takes
> > > more time to execute than the timer interval.
> > 
> > Why should it ? It seems valid for a workload to result in spawning many threads
> > bound to more than a single core on a multi-core system. So concurrency
> > management should be performed by the application. 
> 
> The problem with allowing concurrency is that the moment you want to do
> that you get the spawner context and error propagation problems.

These are problems you get only when you allow spawning any number of threads.
If, instead, you create a thread pool at timer creation, then you can allow
concurrency without problems with spawner context and error proparation.

> Thus we're limited to spawning a single thread at timer_create() and
> handling expirations in there. At that point you have to specify what
> happens to an expiration while the handler is running, will it queue
> handlers or will you have to carefully craft your handler using
> timer_getoverrun().

With my statement above in mind, it's true that we'd have to handle what happens
when the thread pool is exhausted. But couldn't we simply increment an overrun
counter from userland ? (It might be a different counter than kernel space kept
internally in userland)

> But I really don't understand why POSIX would provide this composite
> functionality instead of providing the separate bits to implement this,
> which I think is only SIGEV_THREAD_ID which is missing.

Higher abstraction API vs low-level control. A long running battle. ;)

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0H0PuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:50:17 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39398 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751561Ab0H0PuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:50:15 -0400
Date: Fri, 27 Aug 2010 11:50:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827155013.GF14926@Krystal>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain> <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826230934.GA4194@Krystal> <20100826233651.GB28177@Krystal> <alpine.LFD.2.00.1008271033030.2768@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1008271033030.2768@localhost.localdomain>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:44:33 up 216 days, 18:21,  5 users,  load average: 0.11, 0.07,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Thu, 26 Aug 2010, Mathieu Desnoyers wrote:
[...] 
> > Hrm, thinking about it a little more, one of the "plus" sides of these
> > SIGEV_THREAD timers is that a single timer can fork threads that will run on
> > many cores on a multi-core system. If we go for preallocation of a single
> > thread, we lose that. Maybe we could think of a way to preallocate a thread pool
> > instead ?
> 
> Why should a single timer fork many threads? Just because a previous
> thread did not complete before the timer fires again? That's
> braindamage as all threads call the same function which then needs to
> be serialized anyway. We really do not need a function which creates
> tons of threads which get all stuck on the same resource.

It could make sense if the workload is mostly CPU-bound and there is only a very
short critical section shared between the threads. But I agree that in many
cases this will generate an utter contention mess.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0H0PVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:21:51 -0400
Received: from www.tglx.de ([62.245.132.106]:47089 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab0H0PVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:21:49 -0400
Date: Fri, 27 Aug 2010 17:20:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
In-Reply-To: <20100827151807.GA14926@Krystal>
Message-ID: <alpine.LFD.2.00.1008271719270.2768@localhost.localdomain>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain> <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826231806.GK2367@linux.vnet.ibm.com>
 <20100826232858.GA28177@Krystal> <20100826233811.GM2367@linux.vnet.ibm.com> <20100826235323.GC4194@Krystal> <20100827000911.GO2367@linux.vnet.ibm.com> <20100827151807.GA14926@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > Why couldn't the timer_create() call record the start time, and then
> > compute the sleeps from that time?  So if timer_create() executed at
> > time t=100 and the period is 5, upon awakening and completing the first
> > invocation of the function in question, the thread does a sleep calculated
> > to wake at t=110.
> 
> Let's focus on the userspace thread execution, right between the samping of the
> current time and the call to sleep:
> 
>   Thread A
>   current_time = read current time();
>   sleep(period_end - current_time);
> 
> If the thread is preempted between these two operations, then we end up sleeping
> for longer than what is needed. This kind of imprecision will add up over time,
> so that after e.g. one day, instead of having the expected number of timer
> executions, we'll have less than that. This kind of accumulated drift is an
> unwanted side-effect of using delays in lieue of real periodic timers.

Nonsense, that's why we provide clock_nanosleep(ABSTIME)

Thanks,

	tglx

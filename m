Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0H0PaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:30:12 -0400
Received: from mail.openrapids.net ([64.15.138.104]:59945 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754525Ab0H0PaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:30:09 -0400
Date: Fri, 27 Aug 2010 11:30:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827153006.GD14926@Krystal>
References: <1282849045.1975.1587.camel@laptop> <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain> <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826231806.GK2367@linux.vnet.ibm.com> <20100826232858.GA28177@Krystal> <20100826233811.GM2367@linux.vnet.ibm.com> <20100826235323.GC4194@Krystal> <20100827000911.GO2367@linux.vnet.ibm.com> <20100827151807.GA14926@Krystal> <alpine.LFD.2.00.1008271719270.2768@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1008271719270.2768@localhost.localdomain>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:27:37 up 216 days, 18:04,  4 users,  load average: 0.04, 0.08,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Fri, 27 Aug 2010, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > Why couldn't the timer_create() call record the start time, and then
> > > compute the sleeps from that time?  So if timer_create() executed at
> > > time t=100 and the period is 5, upon awakening and completing the first
> > > invocation of the function in question, the thread does a sleep calculated
> > > to wake at t=110.
> > 
> > Let's focus on the userspace thread execution, right between the samping of the
> > current time and the call to sleep:
> > 
> >   Thread A
> >   current_time = read current time();
> >   sleep(period_end - current_time);
> > 
> > If the thread is preempted between these two operations, then we end up sleeping
> > for longer than what is needed. This kind of imprecision will add up over time,
> > so that after e.g. one day, instead of having the expected number of timer
> > executions, we'll have less than that. This kind of accumulated drift is an
> > unwanted side-effect of using delays in lieue of real periodic timers.
> 
> Nonsense, that's why we provide clock_nanosleep(ABSTIME)

If we're using CLOCK_MONOTONIC, you're right, this could work. I was only
thinking of relative delays.

So do you think Paul's ideal would be a good candidate for the timer_create
SIGEV_THREAD glibc implementation then ?

Thanks,

Mathieu

> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

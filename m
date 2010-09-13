Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0IMPZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:25:18 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54951 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753104Ab0IMPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:25:16 -0400
Date: Mon, 13 Sep 2010 11:25:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100913152514.GA8771@Krystal>
References: <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop> <1284388990.17152.19.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284388990.17152.19.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:24:08 up 233 days, 18:00,  5 users,  load average: 0.08, 0.05,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2010-09-13 at 16:16 +0200, Peter Zijlstra wrote:
> 
> > > > -     if (delta_exec < sysctl_sched_min_granularity)
> > > > -             return;
> > > 
> > > Well, the reason why this test is here seems to be that we don't want to trigger
> > > "resched_task" more often than needed, and here it's defined by the granularity.
> > 
> > Right, but its wrong for the weighted case. Letting a light task run
> > that long will make its latency suck.
> > 
> > > I don't quite see with what you are replacing this, other than "let's set the
> > > resched flag all the time to save a 32-bit division". I figure out it's more
> > > expensive the call the scheduler than to do a 32-bit div.
> > 
> > The more divs we put it, the more expensive it all becomes.
> > 
> 
> What about:
> 
> 	if (delta_exec < sysctl_sched_min_granularity ||
> 	    delta_exec < __sched_gran(cfs_rq->nr_running))
> 
> This way we avoid the div when delta_exec is less than the
> min_granularity, and then we can do the div to perhaps avoid a needless
> resched?

Please note that my patch does not even take the 32-bit div when there are less
than 4 threads running on the system.

So I'm not at all sure we're trying to optimize an important case here.

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

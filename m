Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0ILXot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 19:44:49 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55877 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754069Ab0ILXoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 19:44:44 -0400
Date: Sun, 12 Sep 2010 19:44:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100912234442.GA22778@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu> <20100912181312.GA32327@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912181312.GA32327@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:40:25 up 233 days,  2:17,  4 users,  load average: 0.12, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
[...]
> > I.e. please re-phrase your series as: "what else does it give us beyond 
> > tuning down the minimum granularity to 33% of its current value?"
> 
> That's indeed the nice way to phrase the question. So the added value of my
> approach is that I don't change the granularity when there are 3 or less tasks
> running on the system. So, with Peter's approach, I expect that the system
> throughput will be lower in this scenario, but my approach should keep it at
> pretty much the same values as the vanilla kernel.
> 
> But you are right, I should put some performance measurements too. Let me do a
> few test runs (I plan to use tbench) and come back with the measurements with
> nr_running <= 3 for both Peter's approach and mine.

It turns out that tbench is rather more latency-sensitive than
throughput-sensitive :

tbench 1, on UP 2.0GHz

* Mainline 2.6.35.2 kernel
Throughput 184.875 MB/sec  1 clients  1 procs  max_latency=12.158 ms

* With my patches (dynamic granularity)
Throughput 185.99 MB/sec  1 clients  1 procs  max_latency=14.683 ms

* With Peter's approach (smaller granularity)
Throughput 188.784 MB/sec  1 clients  1 procs  max_latency=8.061 ms

So as we can see, my approach has a behavior that's much closer to mainline, but
the tbench workload seems to favor smaller granularity here. I'm open to ideas
about benchmarks that would test throughput without being so sensitive to
latency.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

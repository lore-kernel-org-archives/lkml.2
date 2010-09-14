Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0INCK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:10:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752415Ab0INCK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:10:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18V5J4AGTQV7A/H84s7uNIyucYe/+bE3MYkvlXk6F
	CQNrDMt3WCZDf6
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime
 with wall time
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100913161641.GA28707@Krystal>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal>
	 <1284387398.2275.311.camel@laptop>  <20100913161641.GA28707@Krystal>
Content-Type: text/plain
Date: Tue, 14 Sep 2010 04:10:52 +0200
Message-Id: <1284430252.7386.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 12:16 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Mon, 2010-09-13 at 09:56 -0400, Mathieu Desnoyers wrote:
> [...]
> > > >  static void
> > > >  check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> > > >  {
> > > > -     unsigned long ideal_runtime, delta_exec;
> > > > +     unsigned long slice = sched_slice(cfs_rq, curr);
> > > 
> > > So you still compute the sched_slice(), based on sched_period(), based on
> > > sysctl_sched_min_granularity *= nr_running when there are more than nr_latency
> > > running threads.
> > 
> > What's wrong with that? I keep asking you, you keep not giving an
> > answer. Stop focussing on nr_latency, its an by produce not a
> > fundamental entity.
> > 
> >  period := max(latency, min_gran * nr_running)
> > 
> > See, no nr_latency -- the one and only purpose of nr_latency is avoiding
> > that multiplication when possible.
> 
> OK, the long IRC discussions we just had convinced me that the current scheme
> takes things into account by adapting the granularity dynamically, but also got
> me to notice that check_preempt seems to compare vruntime with wall time, which
> is utterly incorrect. So maybe all my patch was doing was to expose this bug:

It's not wall time, it's just a distance.  But I'm not attached to it by
any means, if something else works better, do that :)

	-Mike


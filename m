Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2DODoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 23:44:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53946 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756752Ab2DODod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 23:44:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/wqKhZyhXwMH9IlpRCKPXgY2GVmGN6PB8oq2+FVi
	TqFvf6tpfstzrb
Message-ID: <1334461470.5751.21.camel@marge.simpson.net>
Subject: Re: RFC [patch] sched,cgroup_sched: convince RT_GROUP_SCHED
 throttle to work
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Date: Sun, 15 Apr 2012 05:44:30 +0200
In-Reply-To: <1334461061.5751.15.camel@marge.simpson.net>
References: <1333444106.9072.4.camel@marge.simpson.net>
	 <1333444788.9072.9.camel@marge.simpson.net>
	 <1333789124.12677.15.camel@marge.simpson.net>
	 <1333792489.12677.58.camel@marge.simpson.net>
	 <1334048925.7524.21.camel@marge.simpson.net>
	 <1334401847.2528.65.camel@twins>
	 <1334461061.5751.15.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-15 at 05:37 +0200, Mike Galbraith wrote: 
> On Sat, 2012-04-14 at 13:10 +0200, Peter Zijlstra wrote: 
> > On Tue, 2012-04-10 at 11:08 +0200, Mike Galbraith wrote:
> >  
> > > --- a/kernel/sched/rt.c
> > > +++ b/kernel/sched/rt.c
> > > @@ -782,6 +782,19 @@ static int do_sched_rt_period_timer(stru
> > >  	const struct cpumask *span;
> > >  
> > >  	span = sched_rt_period_mask();
> > > +#ifdef CONFIG_RT_GROUP_SCHED
> > > +	/*
> > > +	 * FIXME: isolated CPUs should really leave the root task group,
> > 
> > No no, that's the wrong fix, the right fix is to remove isolcpus :-)
> 
> Yeah, isolcpus needs to die, but...
> 
> > I guess the alternative 'fix' is to not account the rt_runtime on
> > isolated cpus.. does something like the below actually work?
> 
> I haven't tried it, because the exact same thing happens when you
> isolate via cpusets directly below root.  One timer, two (or more)
> rd->span, so _somebody_ is screwed.

You _could_ bail on !rq->sd I suppose, but the way I hacked around it,
the user can keep the throttle for testing/troubleshooting their
isolated setup, and turn it off in production.  OTOH, auto throttle
disable for all isolated sets could work just as well.

-Mike


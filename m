Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484Ab2CVTUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:20:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47780 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030364Ab2CVTUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:20:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+kuQIdUqKkjbSoqEV4EQUpX5cYpHmB+3M1bOZdLa
	OasjVOL41vkDzj
Message-ID: <1332444030.24328.66.camel@marge.simpson.net>
Subject: Re: [PATCH 07/32] cpuset: Set up interface for nohz flag
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Date: Thu, 22 Mar 2012 20:20:30 +0100
In-Reply-To: <alpine.DEB.2.00.1203221118550.25011@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <1332338318-5958-9-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1203210949440.20482@router.home>
	 <1332389033.5759.52.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1203221118550.25011@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 11:26 -0500, Christoph Lameter wrote: 
> On Thu, 22 Mar 2012, Mike Galbraith wrote:
> 
> > > > We use here a per cpu refcounter. As long as a CPU
> > > > is contained into at least one cpuset that has the
> > > > nohz flag set, it is part of the set of CPUs that
> > > > run into adaptive nohz mode.
> > >
> > > What are the drawbacks for nohz?
> >
> > For nohz in general, latency.  To make it at all usable for rt loads, I
> 
> Well nohz while a process is running on a dedicated cpu means the cpu is
> running full power and no disruptions occur. This is a tremendous benefit.

In the context of single task burning in userspace, you bet.

> Less than 10us jitter can alrady be accomplished by building a kernel with
> certain options off (like for example preemption...) and ensuring that
> stuff stays off certain processors. Lets not confuse realtime with low
> latency. Real time in the sense of deterministic execution is bad for
> latency because overhead is added to ensure the determinism which
> increases latency.

Yeah, I know RT pays heavily for determinism.  It loses on best case.

> > of the current box, triple digit for simple synchronized frame timers +
> > compute worker-bees load on 64 cores.  Patch 4 probably helps that, but
> > don't _think_ it'll fix it.  If you (currently) ever become balancer,
> > you're latency target is smoking wreckage.
> 
> Yes so we need something to tell the system which cpu is the sacrificial
> lamb that will not run low latency applications.

Definitely a lamb is required.

(This set is targeted at HPC, so I'll shut up now.. but RT is HPC too)

-Mike


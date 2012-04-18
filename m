Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2DRG14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:27:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48048 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751220Ab2DRG1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:27:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+no5R/56Gny1pZ4t3OCSXrLEW6CR4SMfNs5E+2Oc
	PvOzaLJeOzo1bL
Message-ID: <1334730470.5616.33.camel@marge.simpson.net>
Subject: Re: RFC [patch] sched,cgroup_sched: convince RT_GROUP_SCHED
 throttle to work
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Date: Wed, 18 Apr 2012 08:27:50 +0200
In-Reply-To: <20120418052057.GA19328@zhy>
References: <1333444106.9072.4.camel@marge.simpson.net>
	 <1333444788.9072.9.camel@marge.simpson.net>
	 <1333789124.12677.15.camel@marge.simpson.net>
	 <1333792489.12677.58.camel@marge.simpson.net>
	 <1334048925.7524.21.camel@marge.simpson.net>
	 <1334401847.2528.65.camel@twins>
	 <1334461061.5751.15.camel@marge.simpson.net>
	 <1334461470.5751.21.camel@marge.simpson.net>
	 <1334465495.7802.6.camel@marge.simpson.net> <20120418052057.GA19328@zhy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 13:20 +0800, Yong Zhang wrote:

> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5875,6 +5875,11 @@ cpu_attach_domain(struct sched_domain *s
> >  			sd->child = NULL;
> >  	}
> >  
> > +	if (sd)
> > +		cpumask_clear_cpu(cpu, cpu_isolated_map);
> > +	else
> > +		cpumask_set_cpu(cpu, cpu_isolated_map);
> > +
> 
> Do we allow this?

Yeah, isolating CPUS 2-3...

[ 3011.444345] CPU0 attaching NULL sched-domain.
[ 3011.448719] CPU1 attaching NULL sched-domain.
[ 3011.453107] CPU2 attaching NULL sched-domain.
[ 3011.457466] CPU3 attaching NULL sched-domain.
[ 3011.461892] CPU0 attaching sched-domain:
[ 3011.465813]  domain 0: span 0-1 level MC
[ 3011.469761]   groups: 0 1
[ 3011.472415] CPU1 attaching sched-domain:
[ 3011.476333]  domain 0: span 0-1 level MC
[ 3011.480266]   groups: 1 0
[ 3011.482988] CPU2 attaching sched-domain:
[ 3011.486919]  domain 0: span 2-3 level MC
[ 3011.490851]   groups: 2 3
[ 3011.493502] CPU3 attaching sched-domain:
[ 3011.497422]  domain 0: span 2-3 level MC
[ 3011.501367]   groups: 3 2
[ 3011.504214] CPU2 attaching NULL sched-domain.
[ 3011.508569] CPU3 attaching NULL sched-domain.



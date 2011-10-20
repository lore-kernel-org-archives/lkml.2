Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1JTGnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:43:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45017 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1JTGnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:43:13 -0400
Message-ID: <1319092986.8416.50.camel@edumazet-laptop>
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Venki Pallipadi <venki@google.com>
Date: Thu, 20 Oct 2011 08:43:06 +0200
In-Reply-To: <1319090264.14569.1.camel@sbsiddha-mobl2>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <1319084319.8416.38.camel@edumazet-laptop>
	 <1319090264.14569.1.camel@sbsiddha-mobl2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 octobre 2011 à 22:57 -0700, Suresh Siddha a écrit :
> On Wed, 2011-10-19 at 21:18 -0700, Eric Dumazet wrote:
> > > +	atomic_t load_balancer ____cacheline_aligned;
> > > +	atomic_t first_pick_cpu ____cacheline_aligned;
> > > +	atomic_t second_pick_cpu ____cacheline_aligned;
> > > +	cpumask_var_t idle_cpus_mask ____cacheline_aligned;
> > >  	cpumask_var_t grp_idle_mask;
> > >  	unsigned long next_balance;     /* in jiffy units */
> > >  } nohz ____cacheline_aligned;
> > > 
> > 
> > Dont you increase cache footprint, say for an Uniprocessor machine ?
> > 
> > (CONFIG_SMP=n)
> > 
> > ____cacheline_aligned_in_smp seems more suitable in this case.
> 
> I believe this code is already under ifdef CONFIG_SMP.

Right now yes, but it might change in the future after some code
cleanup / consolidation.

This kind of things are copy/pasted, and the right semantic here is
____cacheline_aligned_in_smp . It matches the changelog better.

Note: the ____cacheline_aligned on global "nohz" structure was quite
different, and in contradiction of what this patch wants to do.

Previously, we wanted to group all fields on a single cache line.
We now know it was not a scalable strategy, thanks to Tim.




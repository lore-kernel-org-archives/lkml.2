Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1JTF6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:58:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:54193 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1JTF6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="64991901"
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Venki Pallipadi <venki@google.com>
In-Reply-To: <1319084319.8416.38.camel@edumazet-laptop>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <1319084319.8416.38.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 19 Oct 2011 22:57:44 -0700
Message-ID: <1319090264.14569.1.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 21:18 -0700, Eric Dumazet wrote:
> > +	atomic_t load_balancer ____cacheline_aligned;
> > +	atomic_t first_pick_cpu ____cacheline_aligned;
> > +	atomic_t second_pick_cpu ____cacheline_aligned;
> > +	cpumask_var_t idle_cpus_mask ____cacheline_aligned;
> >  	cpumask_var_t grp_idle_mask;
> >  	unsigned long next_balance;     /* in jiffy units */
> >  } nohz ____cacheline_aligned;
> > 
> 
> Dont you increase cache footprint, say for an Uniprocessor machine ?
> 
> (CONFIG_SMP=n)
> 
> ____cacheline_aligned_in_smp seems more suitable in this case.

I believe this code is already under ifdef CONFIG_SMP.

thanks,
suresh



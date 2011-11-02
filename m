Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1KBNy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:54:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45127 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab1KBNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:54:54 -0400
Date: Wed, 2 Nov 2011 19:24:14 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
Message-ID: <20111102135414.GC6820@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1319060737.2604.38.camel@schen9-DESK>
 <m2wrc0xpbg.fsf@firstfloor.org>
 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
 <4FF5AC937153B0459463C1A88EB478F20135D6ECB5@orsmsx505.amr.corp.intel.com>
 <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11110213-4242-0000-0000-0000000D01FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2011-11-01 16:52:38]:

> +	/*
> +	 * We were recently in tickless idle mode. We will do the delayed
> +	 * update of busy mode now (first busy tick after returning from idle).
> +	 */
> +	if (unlikely(rq->tick_stopped)) {
> +		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
> +
> +		if (cpumask_bits(nohz.idle_cpus_mask)[BIT_WORD(cpu)] == 0 &&
> +		    cpumask_empty(nohz.idle_cpus_mask))
> +			clear_bit(NOHZ_NEED_BALANCING, &nohz.bits);

Can't this clear_bit race with set_bit() in select_nohz_load_balancer()?

   CPU0				CPU1

cpumask_clear_cpu()
if ( ...)
				cpumask_set_cpu();
				set_bit();

	clear_bit();

?

- vatsa


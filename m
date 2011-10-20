Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1JTEYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 00:24:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:22328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1JTEYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 00:24:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,376,1315206000"; 
   d="scan'208";a="75663213"
From: Andi Kleen <andi@firstfloor.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venki Pallipadi <venki@google.com>
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve idle load balancing scalability
References: <1319060737.2604.38.camel@schen9-DESK>
Date: Wed, 19 Oct 2011 21:24:51 -0700
In-Reply-To: <1319060737.2604.38.camel@schen9-DESK> (Tim Chen's message of
	"Wed, 19 Oct 2011 14:45:37 -0700")
Message-ID: <m2wrc0xpbg.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen <tim.c.chen@linux.intel.com> writes:
>   */
>  static struct {
> -	atomic_t load_balancer;
> -	atomic_t first_pick_cpu;
> -	atomic_t second_pick_cpu;
> -	cpumask_var_t idle_cpus_mask;
> +	atomic_t load_balancer ____cacheline_aligned;
> +	atomic_t first_pick_cpu ____cacheline_aligned;
> +	atomic_t second_pick_cpu ____cacheline_aligned;
> +	cpumask_var_t idle_cpus_mask ____cacheline_aligned;

On large configs idle_cpu_masks may be allocated.  May need
more changes to tell the allocator to cache align/pad too?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

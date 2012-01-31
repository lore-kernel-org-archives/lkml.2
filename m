Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2AaTXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:23:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15095 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2AaTX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:23:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 31 Jan 2012 11:23:18 -0800
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <peterz@infradead.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Kamalesh Babulal'" <kamalesh@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 11:23:17 -0800
Subject: RE: [PATCH] scheduler: domain: init next_balance in
 nohz_idle_balancer with jiffies
Thread-Topic: [PATCH] scheduler: domain: init next_balance in
 nohz_idle_balancer with jiffies
Thread-Index: AczgL0YuPoHFDcoKRF2zO7IjjkvzqQAHjixg
Message-ID: <1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
 <1328024684.2446.234.camel@twins>
In-Reply-To: <1328024684.2446.234.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the patch for kernel 3.3-rc1:

** kernel/sched/fair.c	2012-01-31 11:19:52.032421593 -0800
***************
*** 5585,5597 ****
  
  __init void init_sched_fair_class(void)
  {
  #ifdef CONFIG_SMP
  	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
  
  #ifdef CONFIG_NO_HZ
  	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+ 	nohz.next_balance = jiffies;
  #endif
  #endif /* SMP */
  
  }
--- 5585,5596 ----

-----Original Message-----
From: Peter Zijlstra [mailto:peterz@infradead.org] 
Sent: Tuesday, January 31, 2012 7:45 AM
To: Peter De Schrijver
Cc: Diwakar Tundlam; Ingo Molnar; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scheduler: domain: init next_balance in nohz_idle_balancer with jiffies

On Mon, 2012-01-30 at 14:44 +0200, Peter De Schrijver wrote:
> From: Diwakar Tundlam <dtundlam@nvidia.com>
> 
> The next_balance parameter of nohz_idle_balancer should be initialized 
> to jiffies since jiffies itself is initialized to 300 seconds shy of 
> overflow. Otherwise, nohz_idle_balancer does not run for the first 5 
> mins after bootup.
> 
> Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
> Reviewed-by: Aleksandr Frid <afrid@nvidia.com>
> Reviewed-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
> Reviewed-by: Satya Popuri <spopuri@nvidia.com>
> ---
>  kernel/sched.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

You'll find that this file no longer exists...

> diff --git a/kernel/sched.c b/kernel/sched.c index b5efd6c..d3f291f 
> 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8383,6 +8383,7 @@ void __init sched_init(void)
>  	atomic_set(&nohz.load_balancer, nr_cpu_ids);
>  	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
>  	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
> +	nohz.next_balance = jiffies;
>  #endif
>  	/* May be allocated at isolcpus cmdline parse time */
>  	if (cpu_isolated_map == NULL)

Not does this code section..

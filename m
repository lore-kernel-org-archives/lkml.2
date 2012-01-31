Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2AaPwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:52:40 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:43371 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2AaPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:52:38 -0500
Date: Tue, 31 Jan 2012 21:22:28 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@elte.hu>, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Antti Miettinen <amiettinen@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Kevin Kranzusch <KKranzusch@nvidia.com>
Subject: Re: Fix bug: Scheduler's idle-load-balancer not running in first 5
 mins after bootup
Message-ID: <20120131155228.GB22077@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1DD7BFEDD3147247B1355BEFEFE466523791832BD5@HQMAIL04.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE466523791832BD5@HQMAIL04.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12013105-7014-0000-0000-000000807F71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Diwakar Tundlam <dtundlam@nvidia.com> [2012-01-30 10:14:23]:

> We ran into this at Nvidia. QA filed a bug saying coremark_4pthreads scores lower (as if running on 3 cores) when run shortly after bootup. But later its score increases to expected values on 4 cores.
> 
> This patch is relevant to linux-2.6.39 but I noticed this fix is not made in linux-3.0, 3.1, 3.2 or 3.3 also.
> 
> Please see commit log for more details of the problem and fix.
> 
> Thanks,
>   Diwakar.
>   Tegra Android Kernel SW Engg.
>   NVIDIA.
>   Santa Clara, CA
> 
> commit d04d7ef0e3f8c70bd6cd5abb2abc0236aa8d1f7c
> Author: Diwakar Tundlam <dtundlam@nvidia.com>
> Date:   Wed Jan 18 18:58:57 2012 -0800
> 
>     scheduler: domain: init next_balance in nohz_idle_balancer with jiffies
>     
>     The next_balance parameter of nohz_idle_balancer should be initialized
>     to jiffies since jiffies itself is initialized to 300 seconds shy of
>     overflow. Otherwise, nohz_idle_balancer does not run for the first 5
>     mins after bootup.
>     
>     Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
>     Reviewed-by: Aleksandr Frid <afrid@nvidia.com>
>     Reviewed-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
>     Reviewed-by: Satya Popuri <spopuri@nvidia.com>
> 
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c index c5b09f7..506c5da 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c

Can you rebase the patch against tip. kernel/sched* has been
moved to kernel/sched/.

> @@ -8288,6 +8288,7 @@ void __init sched_init(void)
>         atomic_set(&nohz.load_balancer, nr_cpu_ids);
>         atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
>         atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);

above lines are removed by 0b005cf54eac

> +       nohz.next_balance = jiffies;
>  #endif
>         /* May be allocated at isolcpus cmdline parse time */
>         if (cpu_isolated_map == NULL)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2AaDta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:49:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34322 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752558Ab2AaDt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:49:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18QMIEdKBMQQLOu7kep4PycjECFifBY+/JwI6MNd4
	OyqUc6tcRG4cq6
Message-ID: <1327981751.11541.2.camel@marge.simson.net>
Subject: Re: Fix bug: Scheduler's idle-load-balancer not running in first 5
 mins after bootup
From: Mike Galbraith <efault@gmx.de>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@elte.hu>, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Antti Miettinen <amiettinen@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Kevin Kranzusch <KKranzusch@nvidia.com>
Date: Tue, 31 Jan 2012 04:49:11 +0100
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE466523791832BD5@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE466523791832BD5@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 10:14 -0800, Diwakar Tundlam wrote:
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
> @@ -8288,6 +8288,7 @@ void __init sched_init(void)
>         atomic_set(&nohz.load_balancer, nr_cpu_ids);
>         atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
>         atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
> +       nohz.next_balance = jiffies;
>  #endif
>         /* May be allocated at isolcpus cmdline parse time */
>         if (cpu_isolated_map == NULL)

Shouldn't that really be INITIAL_JIFFIES + HZ?

	-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2AaTPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:15:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12810 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2AaTPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:15:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 31 Jan 2012 11:15:19 -0800
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Mike Galbraith'" <efault@gmx.de>
CC: "'Ingo Molnar'" <mingo@elte.hu>, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Antti Miettinen <amiettinen@nvidia.com>
Date: Tue, 31 Jan 2012 11:15:19 -0800
Subject: RE: Fix bug: Scheduler's idle-load-balancer not running in first 5
 mins after bootup
Thread-Topic: Fix bug: Scheduler's idle-load-balancer not running in first 5
 mins after bootup
Thread-Index: Aczfy1W+PepzhZ+6Twq5w8+hpQfPsgAgNigA
Message-ID: <1DD7BFEDD3147247B1355BEFEFE466523791832BE7@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE466523791832BD5@HQMAIL04.nvidia.com>
 <1327981751.11541.2.camel@marge.simson.net>
In-Reply-To: <1327981751.11541.2.camel@marge.simson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0VJFfTC013337

>> Shouldn't that really be INITIAL_JIFFIES + HZ?
That may work as well. I was modeling the change after similar initialization of the 'next_balance' field in each rq which is done a few lines earlier. And nohz.next_balance follows rq->next_balance.

-----Original Message-----
From: Mike Galbraith [mailto:efault@gmx.de] 
Sent: Monday, January 30, 2012 7:49 PM
To: Diwakar Tundlam
Cc: 'Ingo Molnar'; 'Peter Zijlstra'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver; Antti Miettinen; Matthew Longnecker; Kevin Kranzusch
Subject: Re: Fix bug: Scheduler's idle-load-balancer not running in first 5 mins after bootup

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

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3AGKlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:41:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3AGKlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:01 -0500
Message-ID: <1357555177.30174.5.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: remove redundant update_runtime notifier
From: Mike Galbraith <bitbucket@online.de>
To: Neil Zhang <zhangwm@marvell.com>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2013 11:39:37 +0100
In-Reply-To: <1356688826-23158-1-git-send-email-zhangwm@marvell.com>
References: <1356688826-23158-1-git-send-email-zhangwm@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:+SUK3hWhdXpRWZsLEwQJhW3+V7WdAumaBV1vLhcDvBH
 RI2W4ssHfnpU9MvqRPLx8Y0pKH4GzOffavOoT6hNDD2muBY1x5
 Os5qy4ekGngRQ8QkVB5gKdVESIHz4Kc70nKYniwCcdjU5cJ/2B
 rTJeYgmeeR77uDMVtT3Rd3m5RdXMjYeifRufd5p8ap6jvaM8Ak
 P/AxVnIoJX/zMHR1LzH4AJohmqPA2XqZH9mGS9kTAFfr3f/Sod
 NpOj3qQcMR2XwRCBcTW90yX5J17hBBEIU3RyyO8F6rgJwA9xQi
 Wke9nbRVGCflNPjyP6tIvnO1fR54DTps7dbeMlbyoZ2B2LW5nZ
 qfa6rUjsCtyuKMOQgZHB8PYMW0jnheeTR9ChimM+V8z1Mqse+O
 3uAOCLpN6U6pQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 18:00 +0800, Neil Zhang wrote: 
> migration_call() will do all the things that update_runtime() does.
> So it seems update_runtime() is a redundant notifier, remove it.
> 
> Furthermore, there is potential risk that the current code will catch
> BUG_ON at line 687 of rt.c when do cpu hotplug while there are realtime
> threads running because of enable runtime twice.

Hm, box must be reading lkml behind my back.

PID: 14735  TASK: ffff880e75e86500  CPU: 4   COMMAND: "reboot"
 #0 [ffff880e74b3d890] machine_kexec at ffffffff8102676e
 #1 [ffff880e74b3d8e0] crash_kexec at ffffffff810a3a3a
 #2 [ffff880e74b3d9b0] oops_end at ffffffff81446238
 #3 [ffff880e74b3d9d0] do_invalid_op at ffffffff810035d4
 #4 [ffff880e74b3da70] invalid_op at ffffffff8144d9bb
    [exception RIP: __disable_runtime+494] <== BUG_ON(want);
    RIP: ffffffff81045dae  RSP: ffff880e74b3db28  RFLAGS: 00010082
    RAX: 000000000000046a  RBX: ffff880e7fcd1310  RCX: ffffffff81d88a90
    RDX: 000000000000046a  RSI: 0000000000000050  RDI: ffff880e7fcd19b0
    RBP: ffff880e74b3db98   R8: 0000000000000010   R9: ffff88047f423408
    R10: 0000000000000050  R11: ffffffff81250190  R12: 0000000000000050
    R13: fffffffffde9f140  R14: ffff880e7fcd1310  R15: 000000000000122f
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #5 [ffff880e74b3dba0] rq_offline_rt at ffffffff8104b36a
 #6 [ffff880e74b3dbc0] set_rq_offline at ffffffff81043c9e
 #7 [ffff880e74b3dbe0] rq_attach_root at ffffffff8104c130
 #8 [ffff880e74b3dc10] cpu_attach_domain at ffffffff81054f44
 #9 [ffff880e74b3dc80] build_sched_domains at ffffffff81055525
#10 [ffff880e74b3dcd0] partition_sched_domains at ffffffff81055835
#11 [ffff880e74b3dd70] cpuset_cpu_inactive at ffffffff81055a0d
#12 [ffff880e74b3dd80] notifier_call_chain at ffffffff81448907
#13 [ffff880e74b3ddb0] _cpu_down at ffffffff8142b57b
#14 [ffff880e74b3de10] disable_nonboot_cpus at ffffffff8105ba23
#15 [ffff880e74b3de40] kernel_restart at ffffffff81071dde
#16 [ffff880e74b3de50] sys_reboot at ffffffff81071fc3
#17 [ffff880e74b3df80] system_call_fastpath at ffffffff8144ca12
    RIP: 00007fed35778316  RSP: 00007fff23f7e198  RFLAGS: 00010202
    RAX: 00000000000000a9  RBX: ffffffff8144ca12  RCX: 00007fed35771130
    RDX: 0000000001234567  RSI: 0000000028121969  RDI: fffffffffee1dead
    RBP: 0000000000000000   R8: 0000000000020fd0   R9: 000000000060d120
    R10: 00007fff23f7df40  R11: 0000000000000202  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000001  R15: 0000000000000000
    ORIG_RAX: 00000000000000a9  CS: 0033  SS: 002b

> Cc: bitbucket@online.de
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  kernel/sched/core.c  |    3 ---
>  kernel/sched/rt.c    |   40 ----------------------------------------
>  kernel/sched/sched.h |    1 -
>  3 files changed, 0 insertions(+), 44 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 257002c..7b6a4d8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6779,9 +6779,6 @@ void __init sched_init_smp(void)
>  	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
>  	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
>  
> -	/* RT runtime code needs to handle some hotplug events */
> -	hotcpu_notifier(update_runtime, 0);
> -
>  	init_hrtick();
>  
>  	/* Move init over to a non-isolated CPU */
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 418feb0..1a499d2 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -697,15 +697,6 @@ balanced:
>  	}
>  }
>  
> -static void disable_runtime(struct rq *rq)
> -{
> -	unsigned long flags;
> -
> -	raw_spin_lock_irqsave(&rq->lock, flags);
> -	__disable_runtime(rq);
> -	raw_spin_unlock_irqrestore(&rq->lock, flags);
> -}
> -
>  static void __enable_runtime(struct rq *rq)
>  {
>  	rt_rq_iter_t iter;
> @@ -730,37 +721,6 @@ static void __enable_runtime(struct rq *rq)
>  	}
>  }
>  
> -static void enable_runtime(struct rq *rq)
> -{
> -	unsigned long flags;
> -
> -	raw_spin_lock_irqsave(&rq->lock, flags);
> -	__enable_runtime(rq);
> -	raw_spin_unlock_irqrestore(&rq->lock, flags);
> -}
> -
> -int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu)
> -{
> -	int cpu = (int)(long)hcpu;
> -
> -	switch (action) {
> -	case CPU_DOWN_PREPARE:
> -	case CPU_DOWN_PREPARE_FROZEN:
> -		disable_runtime(cpu_rq(cpu));
> -		return NOTIFY_OK;
> -
> -	case CPU_DOWN_FAILED:
> -	case CPU_DOWN_FAILED_FROZEN:
> -	case CPU_ONLINE:
> -	case CPU_ONLINE_FROZEN:
> -		enable_runtime(cpu_rq(cpu));
> -		return NOTIFY_OK;
> -
> -	default:
> -		return NOTIFY_DONE;
> -	}
> -}
> -
>  static int balance_runtime(struct rt_rq *rt_rq)
>  {
>  	int more = 0;
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index fc88644..16d18a1 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -890,7 +890,6 @@ extern void sysrq_sched_debug_show(void);
>  extern void sched_init_granularity(void);
>  extern void update_max_interval(void);
>  extern void update_group_power(struct sched_domain *sd, int cpu);
> -extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
>  extern void init_sched_rt_class(void);
>  extern void init_sched_fair_class(void);
>  



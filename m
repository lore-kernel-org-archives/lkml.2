Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3AHBNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:13:18 -0500
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:59770 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab3AHBNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:13:16 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Mike Galbraith <bitbucket@online.de>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Jan 2013 17:12:47 -0800
Subject: RE: [PATCH] sched: remove redundant update_runtime notifier
Thread-Topic: [PATCH] sched: remove redundant update_runtime notifier
Thread-Index: Ac3sw4AXWBIpELIKS2KtF1srjuGEeQAeXEqg
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1C73B6C702@SC-VEXCH4.marvell.com>
References: <1356688826-23158-1-git-send-email-zhangwm@marvell.com>
 <1357555177.30174.5.camel@marge.simpson.net>
In-Reply-To: <1357555177.30174.5.camel@marge.simpson.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r081DRI5029541

Mike,


> -----Original Message-----
> From: Mike Galbraith [mailto:bitbucket@online.de]
> Sent: 2013å¹´1æœˆ7æ—¥ 18:40
> To: Neil Zhang
> Cc: mingo@kernel.org; peterz@infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] sched: remove redundant update_runtime notifier
> 
> On Fri, 2012-12-28 at 18:00 +0800, Neil Zhang wrote:
> > migration_call() will do all the things that update_runtime() does.
> > So it seems update_runtime() is a redundant notifier, remove it.
> >
> > Furthermore, there is potential risk that the current code will catch
> > BUG_ON at line 687 of rt.c when do cpu hotplug while there are
> > realtime threads running because of enable runtime twice.
> 
> Hm, box must be reading lkml behind my back.
> 
> PID: 14735  TASK: ffff880e75e86500  CPU: 4   COMMAND: "reboot"
>  #0 [ffff880e74b3d890] machine_kexec at ffffffff8102676e
>  #1 [ffff880e74b3d8e0] crash_kexec at ffffffff810a3a3a
>  #2 [ffff880e74b3d9b0] oops_end at ffffffff81446238
>  #3 [ffff880e74b3d9d0] do_invalid_op at ffffffff810035d4
>  #4 [ffff880e74b3da70] invalid_op at ffffffff8144d9bb
>     [exception RIP: __disable_runtime+494] <== BUG_ON(want);
>     RIP: ffffffff81045dae  RSP: ffff880e74b3db28  RFLAGS: 00010082
>     RAX: 000000000000046a  RBX: ffff880e7fcd1310  RCX:
> ffffffff81d88a90
>     RDX: 000000000000046a  RSI: 0000000000000050  RDI:
> ffff880e7fcd19b0
>     RBP: ffff880e74b3db98   R8: 0000000000000010   R9:
> ffff88047f423408
>     R10: 0000000000000050  R11: ffffffff81250190  R12:
> 0000000000000050
>     R13: fffffffffde9f140  R14: ffff880e7fcd1310  R15:
> 000000000000122f
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #5 [ffff880e74b3dba0] rq_offline_rt at ffffffff8104b36a
>  #6 [ffff880e74b3dbc0] set_rq_offline at ffffffff81043c9e
>  #7 [ffff880e74b3dbe0] rq_attach_root at ffffffff8104c130
>  #8 [ffff880e74b3dc10] cpu_attach_domain at ffffffff81054f44
>  #9 [ffff880e74b3dc80] build_sched_domains at ffffffff81055525
> #10 [ffff880e74b3dcd0] partition_sched_domains at ffffffff81055835
> #11 [ffff880e74b3dd70] cpuset_cpu_inactive at ffffffff81055a0d
> #12 [ffff880e74b3dd80] notifier_call_chain at ffffffff81448907
> #13 [ffff880e74b3ddb0] _cpu_down at ffffffff8142b57b
> #14 [ffff880e74b3de10] disable_nonboot_cpus at ffffffff8105ba23
> #15 [ffff880e74b3de40] kernel_restart at ffffffff81071dde
> #16 [ffff880e74b3de50] sys_reboot at ffffffff81071fc3
> #17 [ffff880e74b3df80] system_call_fastpath at ffffffff8144ca12
>     RIP: 00007fed35778316  RSP: 00007fff23f7e198  RFLAGS: 00010202
>     RAX: 00000000000000a9  RBX: ffffffff8144ca12  RCX:
> 00007fed35771130
>     RDX: 0000000001234567  RSI: 0000000028121969  RDI:
> fffffffffee1dead
>     RBP: 0000000000000000   R8: 0000000000020fd0   R9:
> 000000000060d120
>     R10: 00007fff23f7df40  R11: 0000000000000202  R12:
> 0000000000000000
>     R13: 0000000000000000  R14: 0000000000000001  R15:
> 0000000000000000
>     ORIG_RAX: 00000000000000a9  CS: 0033  SS: 002b
> 

So, it seems my first patch is still needed, we should avoid enable runtime twice in case the value is changed between the two times.

> > Cc: bitbucket@online.de
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  kernel/sched/core.c  |    3 ---
> >  kernel/sched/rt.c    |   40 ----------------------------------------
> >  kernel/sched/sched.h |    1 -
> >  3 files changed, 0 insertions(+), 44 deletions(-)
> >
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c index
> > 257002c..7b6a4d8 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -6779,9 +6779,6 @@ void __init sched_init_smp(void)
> >  	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
> >  	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
> >
> > -	/* RT runtime code needs to handle some hotplug events */
> > -	hotcpu_notifier(update_runtime, 0);
> > -
> >  	init_hrtick();
> >
> >  	/* Move init over to a non-isolated CPU */ diff --git
> > a/kernel/sched/rt.c b/kernel/sched/rt.c index 418feb0..1a499d2 100644
> > --- a/kernel/sched/rt.c
> > +++ b/kernel/sched/rt.c
> > @@ -697,15 +697,6 @@ balanced:
> >  	}
> >  }
> >
> > -static void disable_runtime(struct rq *rq) -{
> > -	unsigned long flags;
> > -
> > -	raw_spin_lock_irqsave(&rq->lock, flags);
> > -	__disable_runtime(rq);
> > -	raw_spin_unlock_irqrestore(&rq->lock, flags);
> > -}
> > -
> >  static void __enable_runtime(struct rq *rq)  {
> >  	rt_rq_iter_t iter;
> > @@ -730,37 +721,6 @@ static void __enable_runtime(struct rq *rq)
> >  	}
> >  }
> >
> > -static void enable_runtime(struct rq *rq) -{
> > -	unsigned long flags;
> > -
> > -	raw_spin_lock_irqsave(&rq->lock, flags);
> > -	__enable_runtime(rq);
> > -	raw_spin_unlock_irqrestore(&rq->lock, flags);
> > -}
> > -
> > -int update_runtime(struct notifier_block *nfb, unsigned long action,
> > void *hcpu) -{
> > -	int cpu = (int)(long)hcpu;
> > -
> > -	switch (action) {
> > -	case CPU_DOWN_PREPARE:
> > -	case CPU_DOWN_PREPARE_FROZEN:
> > -		disable_runtime(cpu_rq(cpu));
> > -		return NOTIFY_OK;
> > -
> > -	case CPU_DOWN_FAILED:
> > -	case CPU_DOWN_FAILED_FROZEN:
> > -	case CPU_ONLINE:
> > -	case CPU_ONLINE_FROZEN:
> > -		enable_runtime(cpu_rq(cpu));
> > -		return NOTIFY_OK;
> > -
> > -	default:
> > -		return NOTIFY_DONE;
> > -	}
> > -}
> > -
> >  static int balance_runtime(struct rt_rq *rt_rq)  {
> >  	int more = 0;
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h index
> > fc88644..16d18a1 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -890,7 +890,6 @@ extern void sysrq_sched_debug_show(void);
> extern
> > void sched_init_granularity(void);  extern void
> > update_max_interval(void);  extern void update_group_power(struct
> > sched_domain *sd, int cpu); -extern int update_runtime(struct
> > notifier_block *nfb, unsigned long action, void *hcpu);  extern void
> > init_sched_rt_class(void);  extern void init_sched_fair_class(void);
> >
> 


Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

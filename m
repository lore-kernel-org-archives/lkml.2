Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab1IHCLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 22:11:42 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:25043
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab1IHCLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 22:11:36 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dKzz1202hzz8275bhz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E68243C.7000404@am.sony.com>
Date: Wed, 7 Sep 2011 19:11:08 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [patch] sched, rt: fix migrate_enable() thinko
References: <1313232790.25267.7.camel@twins> <1314108763.6689.4.camel@marge.simson.net>
In-Reply-To: <1314108763.6689.4.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/11 07:12, Mike Galbraith wrote:
> 
> Assigning mask = tsk_cpus_allowed(p) after p->migrate_disable = 0 ensures
> that we won't see a mask change.. no push/pull, we stack tasks on one CPU.
> 
> Also add a couple fields to sched_debug for the next guy.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---

< snip >

> Index: linux-2.6/kernel/sched_debug.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_debug.c
> +++ linux-2.6/kernel/sched_debug.c
> @@ -235,6 +235,7 @@ void print_rt_rq(struct seq_file *m, int
>  	P(rt_throttled);
>  	PN(rt_time);
>  	PN(rt_runtime);
> +	P(rt_nr_migratory);
>  
>  #undef PN
>  #undef P
> @@ -484,6 +485,8 @@ void proc_sched_show_task(struct task_st
>  	P(se.load.weight);
>  	P(policy);
>  	P(prio);
> +	P(migrate_disable);
> +	P(rt.nr_cpus_allowed);
>  #undef PN
>  #undef __PN
>  #undef P



Fix compile error for CONFIG_SMP=n

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/sched_debug.c |    2 	2 +	0 -	0 !
 1 file changed, 2 insertions(+)

Index: b/kernel/sched_debug.c
===================================================================
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -235,7 +235,9 @@ void print_rt_rq(struct seq_file *m, int
 	P(rt_throttled);
 	PN(rt_time);
 	PN(rt_runtime);
+#ifdef CONFIG_SMP
 	P(rt_nr_migratory);
+#endif
 
 #undef PN
 #undef P


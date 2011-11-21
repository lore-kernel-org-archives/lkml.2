Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1KUQEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:04:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38870 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1KUQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:04:42 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=bzeNwhvjNfUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=EJac59WnUnfD6CuNgT0A:9 a=dGQJBqTFlRx27lGQapMA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/3] rcu-more-fallout.patch
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1321707028-12487-2-git-send-email-jkacur@redhat.com>
References: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
	 <1321707028-12487-2-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 11:04:39 -0500
Message-ID: <1321891479.20742.8.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 13:50 +0100, John Kacur wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cherry-picked for v3.0-rt and fixed minor merge conflict
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  kernel/rcutiny.c |    2 ++

Is this really needed?

>From init/Kconfig:

config TINY_RCU
	bool "UP-only small-memory-footprint RCU"
	depends on !SMP && !PREEMPT_RT_FULL


This code isn't even compiled when PREEMPT_RT_FULL is set.

-- Steve

>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 7bbac7d..f1e4bee 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -271,6 +271,7 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_sched);
>  
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  /*
>   * Post an RCU bottom-half callback to be invoked after any subsequent
>   * quiescent state.
> @@ -280,6 +281,7 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  	__call_rcu(head, func, &rcu_bh_ctrlblk);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_bh);
> +#endif
>  
>  void rcu_barrier_bh(void)
>  {



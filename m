Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab1JESwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:52:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:34237 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1JESwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:52:23 -0400
Date: Wed, 5 Oct 2011 20:52:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/8] kernel/workqueue.c: unbound work queue rescuer runs
 on first cpu in cpumask_online_cpu
In-Reply-To: <1317832759-10223-5-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1110052050010.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-5-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Fenghua Yu wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> If work queue is unbound to a specific cpu, run rescuer on first cpu in
> cpumask_online_cpu instead BSP which could be offlined.

This patch needs to be applied separate from that series as it fixes a
bug which affects all architectures which can offline the boot cpu.

Thanks,

	tglx

 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  kernel/workqueue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 1783aab..d26e411 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1496,9 +1496,9 @@ static bool send_mayday(struct work_struct *work)
>  
>  	/* mayday mayday mayday */
>  	cpu = cwq->gcwq->cpu;
> -	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
> +	/* WORK_CPU_UNBOUND can't be set in cpumask, use first cpu instead */
>  	if (cpu == WORK_CPU_UNBOUND)
> -		cpu = 0;
> +		cpu = cpumask_first(cpu_online_mask);
>  	if (!mayday_test_and_set_cpu(cpu, wq->mayday_mask))
>  		wake_up_process(wq->rescuer->task);
>  	return true;
> -- 
> 1.6.0.3
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2AaIsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:48:45 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51479 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2AaIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:48:43 -0500
Date: Tue, 31 Jan 2012 14:18:30 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: At sched_fork use __set_task_cpu().
Message-ID: <20120131084830.GA22077@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1327854877.8504.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1327854877.8504.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12013108-2674-0000-0000-0000032D1E2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rakib Mullick <rakib.mullick@gmail.com> [2012-01-29 22:34:37]:

>  We don't use select_task_rq() from sched_fork() anymore and no chance of task gets migrated at
> this point. Therefore, we can avoid task migration related checking/accounting, so use
> __set_task_cpu() instead of set_task_cpu().
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
  Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index df00cb0..a38026e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1755,7 +1755,7 @@ void sched_fork(struct task_struct *p)
>  	 * Silence PROVE_RCU.
>  	 */
>  	raw_spin_lock_irqsave(&p->pi_lock, flags);
> -	set_task_cpu(p, cpu);
> +	__set_task_cpu(p, cpu);
>  	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> 
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
> 
> 
> --


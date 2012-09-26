Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2IZDnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:43:25 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45075 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2IZDnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:43:23 -0400
Message-ID: <506279D3.5030702@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 11:43:15 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH] sched: rewrite the wrong annotation for select_task_rq_fair()
References: <1347956160-6946-1-git-send-email-wangyun@linux.vnet.ibm.com>
In-Reply-To: <1347956160-6946-1-git-send-email-wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092603-5564-0000-0000-0000049E6DFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 04:16 PM, Michael Wang wrote:
> The annotation for select_task_rq_fair() is wrong since commit c88d5910, it's
> actually for a removed function.
> 
> This patch rewrite the wrong annotation to make it correct.

Could I get some comments on this patch?

Regards,
Michael Wang

> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6b800a1..35eb43a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2682,15 +2682,17 @@ done:
>  }
> 
>  /*
> - * sched_balance_self: balance the current task (running on cpu) in domains
> - * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
> - * SD_BALANCE_EXEC.
> + * select_task_rq_fair:
> + *	Select a suitable CPU for task p, in order to keep load balance.
>   *
> - * Balance, ie. select the least loaded group.
> + *	sd_flag:
> + *		the domain we try to balance should have "sd_flag" flag set.
>   *
> - * Returns the target CPU number, or the same CPU if no balancing is needed.
> + *	wake_flags:
> + *		indicate WF_SYNC.
>   *
> - * preempt must be disabled.
> + *	Must hold p->pi_lock and disable irq before invoke.
> + *	Return the CPU number for task p to running on.
>   */
>  static int
>  select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
> 


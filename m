Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2JICVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:21:36 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50504 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2JICVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:21:33 -0400
Message-ID: <50738A27.7050007@linux.vnet.ibm.com>
Date: Tue, 09 Oct 2012 10:21:27 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] sched: rewrite the wrong annotation for select_task_rq_fair()
References: <1347956160-6946-1-git-send-email-wangyun@linux.vnet.ibm.com>
In-Reply-To: <1347956160-6946-1-git-send-email-wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100902-8256-0000-0000-0000048053A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 04:16 PM, Michael Wang wrote:
> The annotation for select_task_rq_fair() is wrong since commit c88d5910, it's
> actually for a removed function.
> 
> This patch rewrite the wrong annotation to make it correct.

Could I get some comments on the patch?

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


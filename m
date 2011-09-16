Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1IPFyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:54:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57708 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1IPFyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:54:25 -0400
Date: Fri, 16 Sep 2011 13:54:15 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Wang Xingchao <xingchao.wang@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [PATCH] cfs: remove unused 'if' condition checking
Message-ID: <20110916055415.GA10741@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 01:35:52PM -0400, Wang Xingchao wrote:
> nr_running must be more than 1, so remove the checking
> 
> Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>

The patch looks good. And comments below.

> ---
>  kernel/sched_fair.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 1ca2cd4..fef0bfd 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1106,6 +1106,8 @@ static void
>  check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  {
>  	unsigned long ideal_runtime, delta_exec;
> +	struct sched_entity *se;
> +	s64 delta;
>  
>  	ideal_runtime = sched_slice(cfs_rq, curr);
>  	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
> @@ -1127,16 +1129,14 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  	if (delta_exec < sysctl_sched_min_granularity)
>  		return;
>  
> -	if (cfs_rq->nr_running > 1) {
> -		struct sched_entity *se = __pick_first_entity(cfs_rq);
> -		s64 delta = curr->vruntime - se->vruntime;

It's better to add some comments to explain why se could not be NULL.

Thanks,
Yong

> +	se = __pick_first_entity(cfs_rq);
> +	delta = curr->vruntime - se->vruntime;
>  
> -		if (delta < 0)
> -			return;
> +	if (delta < 0)
> +		return;
>  
> -		if (delta > ideal_runtime)
> -			resched_task(rq_of(cfs_rq)->curr);
> -	}
> +	if (delta > ideal_runtime)
> +		resched_task(rq_of(cfs_rq)->curr);
>  }
>  
>  static void
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself

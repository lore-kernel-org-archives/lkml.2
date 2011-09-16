Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1IPF6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:58:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37014 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1IPF6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:58:12 -0400
Date: Fri, 16 Sep 2011 13:57:58 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Wang Xingchao <xingchao.wang@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        alex.shi@intel.com
Subject: Re: [PATCH] cfs: NULL pointer check
Message-ID: <20110916055758.GB10741@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316195333-12374-1-git-send-email-xingchao.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1316195333-12374-1-git-send-email-xingchao.wang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 01:48:53PM -0400, Wang Xingchao wrote:
> se maybe NULL if cfs_rq->rb_leftmost is NULL

I don't think se could be NULL here. Because we call check_preempt_tick()
iff 'cfs_rq->nr_running > 1'.

Thanks,
Yong

> 
> Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
> ---
>  kernel/sched_fair.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index fef0bfd..109b232 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1130,6 +1130,10 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  		return;
>  
>  	se = __pick_first_entity(cfs_rq);
> +
> +	if (!se)
> +		return;
> +
>  	delta = curr->vruntime - se->vruntime;
>  
>  	if (delta < 0)
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

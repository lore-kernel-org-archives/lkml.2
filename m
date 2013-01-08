Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3AHQvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:51:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab3AHQvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:51:13 -0500
Date: Tue, 8 Jan 2013 11:51:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 16/24] blkcg: add blkg_policy_data->plid
Message-ID: <20130108165101.GG29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-17-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-17-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:38PM -0800, Tejun Heo wrote:
> Add pd->plid so that the policy a pd belongs to can be identified
> easily.  This will be used to implement hierarchical blkg_[rw]stats.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-cgroup.c | 2 ++
>  block/blk-cgroup.h | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 10e1df9..3a8de32 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -113,6 +113,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
>  
>  		blkg->pd[i] = pd;
>  		pd->blkg = blkg;
> +		pd->plid = i;
>  
>  		/* invoke per-policy init */
>  		if (pol->pd_init_fn)
> @@ -908,6 +909,7 @@ int blkcg_activate_policy(struct request_queue *q,
>  
>  		blkg->pd[pol->plid] = pd;
>  		pd->blkg = blkg;
> +		pd->plid = pol->plid;
>  		pol->pd_init_fn(blkg);
>  
>  		spin_unlock(&blkg->blkcg->lock);
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 2446225..40f5b97 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -81,8 +81,9 @@ struct blkg_rwstat {
>   * beginning and pd_size can't be smaller than pd.
>   */
>  struct blkg_policy_data {
> -	/* the blkg this per-policy data belongs to */
> +	/* the blkg and policy id this per-policy data belongs to */
>  	struct blkcg_gq			*blkg;
> +	int				plid;
>  
>  	/* used during policy activation */
>  	struct list_head		alloc_node;
> -- 
> 1.8.0.2

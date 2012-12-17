Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2LQTKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:10:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab2LQTKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:10:53 -0500
Date: Mon, 17 Dec 2012 14:10:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 01/12] blkcg: fix minor bug in blkg_alloc()
Message-ID: <20121217191041.GD7235@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355524885-22719-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:41:14PM -0800, Tejun Heo wrote:
> blkg_alloc() was mistakenly checking blkcg_policy_enabled() twice.
> The latter test should have been on whether pol->pd_init_fn() exists.
> This doesn't cause actual problems because both blkcg policies
> implement pol->pd_init_fn().  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 3f6d39d..feda49f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -114,7 +114,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
>  		pd->blkg = blkg;
>  
>  		/* invoke per-policy init */
> -		if (blkcg_policy_enabled(blkg->q, pol))
> +		if (pol->pd_init_fn)
>  			pol->pd_init_fn(blkg);
>  	}
>  
> -- 
> 1.7.11.7

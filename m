Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1EKPiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1EKPiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:38:12 -0400
Date: Wed, 11 May 2011 10:56:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: get rid of wrong initialization of
 'limits_changed'
Message-ID: <20110511145608.GF31633@redhat.com>
References: <1305125443-5683-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305125443-5683-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:50:43PM +0900, Namhyung Kim wrote:
> When a new group is initialized, we should set @tg->limits_changed
> to false instead of setting @td->limits_changed. But @td and @tg
> are initialized to zero via kzalloc_node(), there is no need to set
> it explicitly. Just get rid of them.
> 

Thanks. Looks good.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-throttle.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 0475a22a420d..5e241ce2695b 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -201,7 +201,6 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
>  	RB_CLEAR_NODE(&tg->rb_node);
>  	bio_list_init(&tg->bio_lists[0]);
>  	bio_list_init(&tg->bio_lists[1]);
> -	td->limits_changed = false;
>  
>  	/*
>  	 * Take the initial reference that will be released on destroy
> @@ -1060,7 +1059,6 @@ int blk_throtl_init(struct request_queue *q)
>  
>  	INIT_HLIST_HEAD(&td->tg_list);
>  	td->tg_service_tree = THROTL_RB_ROOT;
> -	td->limits_changed = false;
>  
>  	/* Init root group */
>  	tg = &td->root_tg;
> @@ -1072,7 +1070,6 @@ int blk_throtl_init(struct request_queue *q)
>  	/* Practically unlimited BW */
>  	tg->bps[0] = tg->bps[1] = -1;
>  	tg->iops[0] = tg->iops[1] = -1;
> -	td->limits_changed = false;
>  
>  	/*
>  	 * Set root group reference to 2. One reference will be dropped when
> -- 
> 1.7.5

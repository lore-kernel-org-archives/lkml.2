Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2LQTiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:38:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2LQTiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:38:06 -0500
Date: Mon, 17 Dec 2012 14:37:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 03/12] blkcg: cosmetic updates to blkg_create()
Message-ID: <20121217193753.GF7235@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355524885-22719-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:41:16PM -0800, Tejun Heo wrote:
> * Rename out_* labels to err_*.
> 
> * Do ERR_PTR() conversion once in the error return path.
> 
> This patch is cosmetic and to prepare for the hierarchy support.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-cgroup.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index ffbd237..fde2286 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -187,16 +187,16 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  
>  	/* blkg holds a reference to blkcg */
>  	if (!css_tryget(&blkcg->css)) {
> -		blkg = ERR_PTR(-EINVAL);
> -		goto out_free;
> +		ret = -EINVAL;
> +		goto err_free_blkg;
>  	}
>  
>  	/* allocate */
>  	if (!new_blkg) {
>  		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
>  		if (unlikely(!new_blkg)) {
> -			blkg = ERR_PTR(-ENOMEM);
> -			goto out_put;
> +			ret = -ENOMEM;
> +			goto err_put_css;
>  		}
>  	}
>  	blkg = new_blkg;
> @@ -213,12 +213,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  	if (!ret)
>  		return blkg;
>  
> -	blkg = ERR_PTR(ret);
> -out_put:
> +err_put_css:
>  	css_put(&blkcg->css);
> -out_free:
> +err_free_blkg:
>  	blkg_free(new_blkg);
> -	return blkg;
> +	return ERR_PTR(ret);
>  }
>  
>  /**
> -- 
> 1.7.11.7

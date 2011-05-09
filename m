Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1EIOct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:32:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40696 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1EIOcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:32:48 -0400
Date: Mon, 9 May 2011 16:32:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Vladimir Motyka <vladimir.motyka@gmail.com>
Cc: cjb@laptop.org, kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mmc/card/block.c: fix potential null dereference
 'idata'
In-Reply-To: <4DC7F4AB.90607@gmail.com>
Message-ID: <Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk>
References: <4DC7F4AB.90607@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 May 2011, Vladimir Motyka wrote:

> When allocation of idata fails there was a null dereferece.

Why not have a different label for the two cases?  That would make the 
code easier to statically analyze, and perhaps be more understandable as 
well.

julia


> Signed-off-by: Vladimir Motyka <vladimir.motyka@gmail.com>
> 
> ---
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 407836d..3dec493 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -266,10 +266,10 @@ static struct mmc_blk_ioc_data
> *mmc_blk_ioctl_copy_from_user(
>  	return idata;
> 
>  copy_err:
> -	kfree(idata->buf);
> +	if(idata)
> +		kfree(idata->buf);
>  	kfree(idata);
>  	return ERR_PTR(err);
> -
>  }
> 
>  static int mmc_blk_ioctl_cmd(struct block_device *bdev,
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

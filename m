Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2EVIZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:25:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47372 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2EVIZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:25:46 -0400
Date: Tue, 22 May 2012 10:25:42 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Johan Hovold'" <jhovold@gmail.com>
Subject: Re: [PATCH v2 3/3] backlight: lm3533_bl: use devm_ functions
Message-ID: <20120522082542.GA7323@localhost>
References: <002d01cd3732$e667d7b0$b3378710$%han@samsung.com>
 <000501cd37ae$161bf2e0$4253d8a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501cd37ae$161bf2e0$4253d8a0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 09:01:49AM +0900, Jingoo Han wrote:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions.
> 
> Cc: Johan Hovold <jhovold@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Johan Hovold <jhovold@gmail.com>

Thanks,
Johan

> ---
>  drivers/video/backlight/lm3533_bl.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
> index 0148227..d916ffe 100644
> --- a/drivers/video/backlight/lm3533_bl.c
> +++ b/drivers/video/backlight/lm3533_bl.c
> @@ -295,7 +295,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
> +	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
>  	if (!bl) {
>  		dev_err(&pdev->dev,
>  				"failed to allocate memory for backlight\n");
> @@ -317,8 +317,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
>  						&lm3533_bl_ops, &props);
>  	if (IS_ERR(bd)) {
>  		dev_err(&pdev->dev, "failed to register backlight device\n");
> -		ret = PTR_ERR(bd);
> -		goto err_free;
> +		return PTR_ERR(bd);
>  	}
>  
>  	bl->bd = bd;
> @@ -348,8 +347,6 @@ err_sysfs_remove:
>  	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
>  err_unregister:
>  	backlight_device_unregister(bd);
> -err_free:
> -	kfree(bl);
>  
>  	return ret;
>  }
> @@ -367,7 +364,6 @@ static int __devexit lm3533_bl_remove(struct platform_device *pdev)
>  	lm3533_ctrlbank_disable(&bl->cb);
>  	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
>  	backlight_device_unregister(bd);
> -	kfree(bl);
>  
>  	return 0;
>  }

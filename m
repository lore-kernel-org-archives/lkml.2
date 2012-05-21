Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2EUJ6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:58:42 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37215 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab2EUJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:58:41 -0400
Date: Mon, 21 May 2012 11:58:37 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Johan Hovold'" <jhovold@gmail.com>
Subject: Re: [PATCH 3/3] backlight: lm3533_bl: use devm_ functions
Message-ID: <20120521095837.GE21033@localhost>
References: <002d01cd3732$e667d7b0$b3378710$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002d01cd3732$e667d7b0$b3378710$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 06:20:01PM +0900, Jingoo Han wrote:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions.
> 
> Cc: Johan Hovold <jhovold@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/lm3533_bl.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
> index 0148227..9f96a6b 100644
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
> @@ -318,7 +318,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
>  	if (IS_ERR(bd)) {
>  		dev_err(&pdev->dev, "failed to register backlight device\n");
>  		ret = PTR_ERR(bd);
> -		goto err_free;
> +		goto err_return;

Why not simply return PTR_ERR(bd) here?

>  	}
>  
>  	bl->bd = bd;
> @@ -348,8 +348,7 @@ err_sysfs_remove:
>  	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
>  err_unregister:
>  	backlight_device_unregister(bd);
> -err_free:
> -	kfree(bl);
> +err_return:

No need for this label then.

>  
>  	return ret;
>  }
> @@ -367,7 +366,6 @@ static int __devexit lm3533_bl_remove(struct platform_device *pdev)
>  	lm3533_ctrlbank_disable(&bl->cb);
>  	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
>  	backlight_device_unregister(bd);
> -	kfree(bl);
>  
>  	return 0;
>  }

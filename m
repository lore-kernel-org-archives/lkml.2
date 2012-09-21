Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2IUVwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:52:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab2IUVwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:52:10 -0400
Date: Fri, 21 Sep 2012 14:52:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: platform-lcd: Add support for device tree
 based probe
Message-Id: <20120921145209.b57cad16.akpm@linux-foundation.org>
In-Reply-To: <000e01cd9798$370acbd0$a5206370$%han@samsung.com>
References: <000e01cd9798$370acbd0$a5206370$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012 10:27:07 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> This patch adds the of_match_table to platform-lcd driver to be
> probed when platform-lcd device node is found in the device tree.
> 
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/platform_lcd.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
> index b667234..574d5ee 100644
> --- a/drivers/video/backlight/platform_lcd.c
> +++ b/drivers/video/backlight/platform_lcd.c
> @@ -145,6 +145,14 @@ static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
>  			platform_lcd_resume);
>  #endif
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id platform_lcd_of_match[] = {
> +	{ .compatible = "platform-lcd" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, platform_lcd_of_match);
> +#endif
> +
>  static struct platform_driver platform_lcd_driver = {
>  	.driver		= {
>  		.name	= "platform-lcd",
> @@ -152,6 +160,7 @@ static struct platform_driver platform_lcd_driver = {
>  #ifdef CONFIG_PM
>  		.pm	= &platform_lcd_pm_ops,
>  #endif
> +		.of_match_table = of_match_ptr(platform_lcd_of_match),
>  	},
>  	.probe		= platform_lcd_probe,
>  	.remove		= __devexit_p(platform_lcd_remove),

This .c file includes no open-firmware headers.

It does happen to get a copy of of.h via fb.h->i2c.h->of.h, but that
was just luck.

I did this:

--- a/drivers/video/backlight/platform_lcd.c~backlight-platform-lcd-add-support-for-device-tree-based-probe-fix
+++ a/drivers/video/backlight/platform_lcd.c
@@ -16,6 +16,7 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/lcd.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 
 #include <video/platform_lcd.h>
_


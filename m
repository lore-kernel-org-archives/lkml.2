Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2KSWWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:22:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2KSWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:21:59 -0500
Date: Mon, 19 Nov 2012 14:21:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Joe Perches'" <joe@perches.com>
Subject: Re: [PATCH] backlight: 88pm860x_bl: remove an unnecessary line
 continuation
Message-Id: <20121119142157.620fcfde.akpm@linux-foundation.org>
In-Reply-To: <004a01cdc5f6$a247bed0$e6d73c70$%han@samsung.com>
References: <004a01cdc5f6$a247bed0$e6d73c70$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 10:38:53 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> This patch removes remove an unnecessary line continuation in
> pm860x_backlight_probe(). Also, a checkpatch warning is fixed
> as below:
> 
> WARNING: Avoid unnecessary line continuations
> 
> --- a/drivers/video/backlight/88pm860x_bl.c
> +++ b/drivers/video/backlight/88pm860x_bl.c
> @@ -228,7 +228,7 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
>  	sprintf(name, "backlight-%d", pdev->id);
>  	data->port = pdev->id;
>  	data->chip = chip;
> -	data->i2c = (chip->id == CHIP_PM8606) ? chip->client	\
> +	data->i2c = (chip->id == CHIP_PM8606) ? chip->client
>  			: chip->companion;
>  	data->current_brightness = MAX_BRIGHTNESS;
>  	if (pm860x_backlight_dt_init(pdev, data, name)) {

It's still pretty ugly, but looky here:

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -228,8 +228,7 @@ static int pm860x_backlight_probe(struct
 	sprintf(name, "backlight-%d", pdev->id);
 	data->port = pdev->id;
 	data->chip = chip;
-	data->i2c = (chip->id == CHIP_PM8606) ? chip->client
-			: chip->companion;
+	data->i2c = (chip->id == CHIP_PM8606) ? chip->client : chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
 	if (pm860x_backlight_dt_init(pdev, data, name)) {
 		if (pdata) {
_


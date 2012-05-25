Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2EYGTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:19:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36676 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EYGTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:19:38 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 08/13] backlight: lms283gf05: use devm_ functions
Date: Fri, 25 May 2012 08:19:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
References: <001301cd3a1e$03431410$09c93c30$%han@samsung.com>
In-Reply-To: <001301cd3a1e$03431410$09c93c30$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205250819.33101.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jingoo Han,

> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions.
> 
> Cc: Marek Vasut <marex@denx.de>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Marek Vasut <marek.vasut@gmail.com>

> ---
>  drivers/video/backlight/lms283gf05.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/backlight/lms283gf05.c
> b/drivers/video/backlight/lms283gf05.c index 4161f9e..a9f2c36 100644
> --- a/drivers/video/backlight/lms283gf05.c
> +++ b/drivers/video/backlight/lms283gf05.c
> @@ -168,7 +168,8 @@ static int __devinit lms283gf05_probe(struct spi_device
> *spi) goto err;
>  	}
> 
> -	st = kzalloc(sizeof(struct lms283gf05_state), GFP_KERNEL);
> +	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
> +				GFP_KERNEL);
>  	if (st == NULL) {
>  		dev_err(&spi->dev, "No memory for device state\n");
>  		ret = -ENOMEM;
> @@ -178,7 +179,7 @@ static int __devinit lms283gf05_probe(struct spi_device
> *spi) ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops); if
> (IS_ERR(ld)) {
>  		ret = PTR_ERR(ld);
> -		goto err2;
> +		goto err;
>  	}
> 
>  	st->spi = spi;
> @@ -193,8 +194,6 @@ static int __devinit lms283gf05_probe(struct spi_device
> *spi)
> 
>  	return 0;
> 
> -err2:
> -	kfree(st);
>  err:
>  	if (pdata != NULL)
>  		gpio_free(pdata->reset_gpio);
> @@ -212,8 +211,6 @@ static int __devexit lms283gf05_remove(struct
> spi_device *spi) if (pdata != NULL)
>  		gpio_free(pdata->reset_gpio);
> 
> -	kfree(st);
> -
>  	return 0;
>  }

Best regards,
Marek Vasut

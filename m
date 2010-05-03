Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0ECIGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 04:06:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57217 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0ECIGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 04:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=D0iWYGgS6rRwcLygS1KLst6s0iNprAJ+LHoIBaTN/L7xWEN//AoPr5znnmj2Tdk49C
         FEjG9hijk7ueFipa5ROkR8SsP0Y1gtiNCfbGz8HZNzrjF4YmOX6aCieb88rEnKsirure
         KXaxKiOPzPyOdC3chhKfcs8ZLPKwKht0g/msI=
Subject: Re: [PATCH] l4f00242t03: fix error handling in l4f00242t03_probe
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ";Richard Purdie" <rpurdie@linux.intel.com>
In-Reply-To: <1272868964.2861.5.camel@mola>
References: <1272868964.2861.5.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 10:06:36 +0200
Message-ID: <1272873996.3549.4.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lun, 2010-05-03 at 14:42 +0800, Axel Lin wrote:
> This patch includes below fixes for properly error handling:
> 1. In the case of kzalloc failure, simple return -ENOMEM instead of goto
> err. ( priv is NULL in this case )
> 2. In the case of gpio_request fail for reset_gpio and data_enable_gpio,
>    properly release resources by goto err and err2 respectively.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Tank you for these fixes!

Acked-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Alberto!

> ---
>  drivers/video/backlight/l4f00242t03.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/backlight/l4f00242t03.c
> b/drivers/video/backlight/l4f00242t03.c
> index bcdb12c..a4632db 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -125,8 +125,7 @@ static int __devinit l4f00242t03_probe(struct
> spi_device *spi)
>  
>  	if (priv == NULL) {
>  		dev_err(&spi->dev, "No memory for this device.\n");
> -		ret = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
>  
>  	dev_set_drvdata(&spi->dev, priv);
> @@ -139,7 +138,7 @@ static int __devinit l4f00242t03_probe(struct
> spi_device *spi)
>  	if (ret) {
>  		dev_err(&spi->dev,
>  			"Unable to get the lcd l4f00242t03 reset gpio.\n");
> -		return ret;
> +		goto err;
>  	}
>  
>  	ret = gpio_direction_output(pdata->reset_gpio, 1);
> @@ -151,7 +150,7 @@ static int __devinit l4f00242t03_probe(struct
> spi_device *spi)
>  	if (ret) {
>  		dev_err(&spi->dev,
>  			"Unable to get the lcd l4f00242t03 data en gpio.\n");
> -		return ret;
> +		goto err2;
>  	}
>  
>  	ret = gpio_direction_output(pdata->data_enable_gpio, 0);



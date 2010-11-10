Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0KJOYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:24:25 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:35153 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756027Ab0KJOYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:24:24 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18BjfEjbUYBHSuucE06STGrnXEykFoBypLJ53Y6jn
	GNoE0cqP2DuS2R
Date: Wed, 10 Nov 2010 15:24:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: linux-i2c@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sergio Aguirre <saaguirre@ti.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Philipp Wiesner <p.wiesner@phytec.de>,
        =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: video: do not clear 'driver' from an i2c_client
In-Reply-To: <1289398455-21949-1-git-send-email-w.sang@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1011101524120.13739@axis700.grange>
References: <1289398455-21949-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Wolfram Sang wrote:

> The i2c-core does this already.
> 
> Reported-by: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

> ---
> 
> Not sure if this should go via i2c or media?
> 
>  drivers/media/video/imx074.c     |    1 -
>  drivers/media/video/mt9m001.c    |    1 -
>  drivers/media/video/mt9m111.c    |    1 -
>  drivers/media/video/mt9t031.c    |    1 -
>  drivers/media/video/mt9v022.c    |    1 -
>  drivers/media/video/rj54n1cb0c.c |    1 -
>  6 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
> index 27b5dfd..1a11691 100644
> --- a/drivers/media/video/imx074.c
> +++ b/drivers/media/video/imx074.c
> @@ -467,7 +467,6 @@ static int imx074_remove(struct i2c_client *client)
>  	icd->ops = NULL;
>  	if (icl->free_bus)
>  		icl->free_bus(icl);
> -	client->driver = NULL;
>  	kfree(priv);
>  
>  	return 0;
> diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
> index fcb4cd9..f7fc88d 100644
> --- a/drivers/media/video/mt9m001.c
> +++ b/drivers/media/video/mt9m001.c
> @@ -798,7 +798,6 @@ static int mt9m001_remove(struct i2c_client *client)
>  
>  	icd->ops = NULL;
>  	mt9m001_video_remove(icd);
> -	client->driver = NULL;
>  	kfree(mt9m001);
>  
>  	return 0;
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index 525a16e..53fa2a7 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -1092,7 +1092,6 @@ static int mt9m111_remove(struct i2c_client *client)
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  
>  	icd->ops = NULL;
> -	client->driver = NULL;
>  	kfree(mt9m111);
>  
>  	return 0;
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index 9bd44a8..7ce279c 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -896,7 +896,6 @@ static int mt9t031_remove(struct i2c_client *client)
>  
>  	if (icd)
>  		icd->ops = NULL;
> -	client->driver = NULL;
>  	kfree(mt9t031);
>  
>  	return 0;
> diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> index b96171c..6a784c8 100644
> --- a/drivers/media/video/mt9v022.c
> +++ b/drivers/media/video/mt9v022.c
> @@ -930,7 +930,6 @@ static int mt9v022_remove(struct i2c_client *client)
>  
>  	icd->ops = NULL;
>  	mt9v022_video_remove(icd);
> -	client->driver = NULL;
>  	kfree(mt9v022);
>  
>  	return 0;
> diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
> index d2fa2d4..57e11b6 100644
> --- a/drivers/media/video/rj54n1cb0c.c
> +++ b/drivers/media/video/rj54n1cb0c.c
> @@ -1460,7 +1460,6 @@ static int rj54n1_remove(struct i2c_client *client)
>  	icd->ops = NULL;
>  	if (icl->free_bus)
>  		icl->free_bus(icl);
> -	client->driver = NULL;
>  	kfree(rj54n1);
>  
>  	return 0;
> -- 
> 1.7.2.3
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

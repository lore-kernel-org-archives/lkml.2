Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0KJNBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:01:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45332 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755879Ab0KJNBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:01:23 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18K6l8Q/9sKjsA7LtZ4A0YjkogpfT3skf+/uuoRgv
	tHglih03SpBzTC
Date: Wed, 10 Nov 2010 14:01:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: linux-i2c@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hong Liu <hong.liu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Anantha Narayanan <anantha.narayanan@intel.com>,
        Andres Salomon <dilinger@queued.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] i2c: Remove obsolete cleanup for clientdata
In-Reply-To: <1289392100-32668-1-git-send-email-w.sang@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1011101359480.13739@axis700.grange>
References: <1289392100-32668-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Wolfram Sang wrote:

> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit. This is obsolete meanwhile, so fix it and hope the word will spread.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

for imx074 and ov6650:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
> 
> Like last time I suggest to collect acks from the driver authors and merge it
> vie Jean's i2c-tree.
> 
>  drivers/media/video/imx074.c          |    2 --
>  drivers/media/video/ov6650.c          |    2 --
>  drivers/misc/apds9802als.c            |    1 -
>  drivers/staging/olpc_dcon/olpc_dcon.c |    3 ---
>  4 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
> index 380e459..27b5dfd 100644
> --- a/drivers/media/video/imx074.c
> +++ b/drivers/media/video/imx074.c
> @@ -451,7 +451,6 @@ static int imx074_probe(struct i2c_client *client,
>  	ret = imx074_video_probe(icd, client);
>  	if (ret < 0) {
>  		icd->ops = NULL;
> -		i2c_set_clientdata(client, NULL);
>  		kfree(priv);
>  		return ret;
>  	}
> @@ -468,7 +467,6 @@ static int imx074_remove(struct i2c_client *client)
>  	icd->ops = NULL;
>  	if (icl->free_bus)
>  		icl->free_bus(icl);
> -	i2c_set_clientdata(client, NULL);
>  	client->driver = NULL;
>  	kfree(priv);
>  
> diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
> index b7cfeab..2dd5298 100644
> --- a/drivers/media/video/ov6650.c
> +++ b/drivers/media/video/ov6650.c
> @@ -1176,7 +1176,6 @@ static int ov6650_probe(struct i2c_client *client,
>  
>  	if (ret) {
>  		icd->ops = NULL;
> -		i2c_set_clientdata(client, NULL);
>  		kfree(priv);
>  	}
>  
> @@ -1187,7 +1186,6 @@ static int ov6650_remove(struct i2c_client *client)
>  {
>  	struct ov6650 *priv = to_ov6650(client);
>  
> -	i2c_set_clientdata(client, NULL);
>  	kfree(priv);
>  	return 0;
>  }
> diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
> index f9b91ba..abe3d21 100644
> --- a/drivers/misc/apds9802als.c
> +++ b/drivers/misc/apds9802als.c
> @@ -251,7 +251,6 @@ static int apds9802als_probe(struct i2c_client *client,
>  
>  	return res;
>  als_error1:
> -	i2c_set_clientdata(client, NULL);
>  	kfree(data);
>  	return res;
>  }
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
> index 75aa7a36..f286a4c 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -733,7 +733,6 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
>   edev:
>  	platform_device_unregister(dcon_device);
>  	dcon_device = NULL;
> -	i2c_set_clientdata(client, NULL);
>   eirq:
>  	free_irq(DCON_IRQ, &dcon_driver);
>   einit:
> @@ -757,8 +756,6 @@ static int dcon_remove(struct i2c_client *client)
>  		platform_device_unregister(dcon_device);
>  	cancel_work_sync(&dcon_work);
>  
> -	i2c_set_clientdata(client, NULL);
> -
>  	return 0;
>  }
>  
> -- 
> 1.7.2.3
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

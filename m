Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1L0PYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 10:24:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59193 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1L0PYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 10:24:37 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
Date: Tue, 27 Dec 2011 16:24:33 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-pcmcia@lists.infradead.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
References: <1324974344.2351.5.camel@phoenix>
In-Reply-To: <1324974344.2351.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112271624.33760.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If pxa2xx_drv_pcmcia_add_one fails, it will go to err1 error path.
> Add a missing clk_put in the error path.
> 
> Checking the ret value after the for loop is redundant, it is always false.
> Thus remove the redundant checking.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pcmcia/pxa2xx_base.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
> index a87e272..64d433e 100644
> --- a/drivers/pcmcia/pxa2xx_base.c
> +++ b/drivers/pcmcia/pxa2xx_base.c
> @@ -328,21 +328,15 @@ static int pxa2xx_drv_pcmcia_probe(struct
> platform_device *dev) goto err1;
>  	}
> 
> -	if (ret) {
> -		while (--i >= 0)
> -			soc_pcmcia_remove_one(&sinfo->skt[i]);
> -		kfree(sinfo);
> -		clk_put(clk);
> -	} else {
> -		pxa2xx_configure_sockets(&dev->dev);
> -		dev_set_drvdata(&dev->dev, sinfo);
> -	}
> +	pxa2xx_configure_sockets(&dev->dev);
> +	dev_set_drvdata(&dev->dev, sinfo);
> 
>  	return 0;
> 
>  err1:
>  	while (--i >= 0)
>  		soc_pcmcia_remove_one(&sinfo->skt[i]);
> +	clk_put(clk);
>  	kfree(sinfo);
>  err0:
>  	return ret;

Makes sense

Acked-by: Marek Vasut <marek.vasut@gmail.com>

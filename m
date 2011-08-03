Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1HCH04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 03:26:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1HCH0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 03:26:50 -0400
Date: Wed, 3 Aug 2011 09:26:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Axel Lin <axel.lin@gmail.com>
cc: linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: tmio: eliminate unused variable 'mmc' warning
In-Reply-To: <1312354138.14329.1.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1108030924440.28502@axis700.grange>
References: <1312354138.14329.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Lgplxm+Ddlidt48i9ck+65xM+aCbpUFXbmJHPssriIh
 vrgeByTdFHcvuffBz+rtbnmciiecamw6Fqzm+9db5iBNaqBhso
 H4JZUm+IEQe1KpdyOdVoYBUalYI8TCmZoLXqPwjzaKwS5m3HBJ
 NY4IH4XLNdY5loB3LOtYTEWZAXBH029jnmqutO9nDHWE7/Rznc
 OqB3oM1qiwJpdT4X4mP/XDKhXN95qC+EJS3WvZpCxI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Axel Lin wrote:

> Fix below compile warning:
>   CC      drivers/mmc/host/tmio_mmc.o
> drivers/mmc/host/tmio_mmc.c: In function 'tmio_mmc_suspend':
> drivers/mmc/host/tmio_mmc.c:30: warning: unused variable 'mmc'
> drivers/mmc/host/tmio_mmc.c: In function 'tmio_mmc_resume':
> drivers/mmc/host/tmio_mmc.c:45: warning: unused variable 'mmc'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Good for 3.1, do we also push such "harmless" compiler warning fixes to 
stable?

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/mmc/host/tmio_mmc.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
> index 8d185de..44a9668 100644
> --- a/drivers/mmc/host/tmio_mmc.c
> +++ b/drivers/mmc/host/tmio_mmc.c
> @@ -27,7 +27,6 @@
>  static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
>  {
>  	const struct mfd_cell *cell = mfd_get_cell(dev);
> -	struct mmc_host *mmc = platform_get_drvdata(dev);
>  	int ret;
>  
>  	ret = tmio_mmc_host_suspend(&dev->dev);
> @@ -42,7 +41,6 @@ static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
>  static int tmio_mmc_resume(struct platform_device *dev)
>  {
>  	const struct mfd_cell *cell = mfd_get_cell(dev);
> -	struct mmc_host *mmc = platform_get_drvdata(dev);
>  	int ret = 0;
>  
>  	/* Tell the MFD core we are ready to be enabled */
> -- 
> 1.7.4.1
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

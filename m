Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1IUKQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:16:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1IUKQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:16:11 -0400
Date: Wed, 21 Sep 2011 12:16:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Yong Zhang <yong.zhang0@gmail.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Chris Ball <cjb@laptop.org>,
        Ian Molton <ian@mnementh.co.uk>, Tony Lindgren <tony@atomide.com>,
        Kishore Kadiyala <kishore.kadiyala@ti.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, Balaji T K <balajitk@ti.com>,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 37/57] mmc: irq: Remove IRQF_DISABLED
In-Reply-To: <1316597339-29861-38-git-send-email-yong.zhang0@gmail.com>
Message-ID: <Pine.LNX.4.64.1109211208440.24024@axis700.grange>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-38-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:9UNrfv2FUsH/zqqV2Di7YSSP+Sm5R6A1CMxmzv42iFC
 5LCuzWSVg2BiceYniKiiQATpn3ishlBznAxjkLXygB+FVnHxBk
 Fxg5cQXVOSC9RUXNB3ZUKwKho/849yQX+NS4pueLBMqq1ta7bc
 rVJYlMP+PpUoonl7HeY+vjRw0lIJC9vn+gkE33lUyXdX7kVq4z
 xdLa9qcZwmGa/3FnWJXznEg3Iy9Dt3JnFZAC4W+6zRpD921mfx
 gZm1SyJDxhEeddRlJPZr7Ijye5q4x0kooEgGHgPBr1mvmScfLa
 zIIC5lYhzTCGuDMVEk4sDmRtrN0GUTmsdzplXfrOA4cDpjBx+D
 mWO7ufUF2h9UQvfUzoB//MOFdeBoGpJc72w9ZaT3VLD2iay9i9
 tOx1DkjRs7xMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Yong Zhang wrote:

> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |    5 ++---
>  drivers/mmc/host/tmio_mmc.c   |    4 ++--

For tmio_mmc.c:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 21e4a79..75c6395 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -2015,7 +2015,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Request IRQ for MMC operations */
> -	ret = request_irq(host->irq, omap_hsmmc_irq, IRQF_DISABLED,
> +	ret = request_irq(host->irq, omap_hsmmc_irq, 0,
>  			mmc_hostname(mmc), host);
>  	if (ret) {
>  		dev_dbg(mmc_dev(host->mmc), "Unable to grab HSMMC IRQ\n");
> @@ -2043,8 +2043,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
>  	if ((mmc_slot(host).card_detect_irq)) {
>  		ret = request_irq(mmc_slot(host).card_detect_irq,
>  				  omap_hsmmc_cd_handler,
> -				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
> -					  | IRQF_DISABLED,
> +				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>  				  mmc_hostname(mmc), host);
>  		if (ret) {
>  			dev_dbg(mmc_dev(host->mmc),
> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
> index 44a9668..a4ea102 100644
> --- a/drivers/mmc/host/tmio_mmc.c
> +++ b/drivers/mmc/host/tmio_mmc.c
> @@ -88,8 +88,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto cell_disable;
>  
> -	ret = request_irq(irq, tmio_mmc_irq, IRQF_DISABLED |
> -			  IRQF_TRIGGER_FALLING, dev_name(&pdev->dev), host);
> +	ret = request_irq(irq, tmio_mmc_irq, IRQF_TRIGGER_FALLING,
> +				dev_name(&pdev->dev), host);
>  	if (ret)
>  		goto host_remove;
>  
> -- 
> 1.7.4.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

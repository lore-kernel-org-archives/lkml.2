Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2JPVfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:35:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37726 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2JPVff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:35:35 -0400
Date: Tue, 16 Oct 2012 23:35:32 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 03/10] [media] mx1_camera: Don't use {en,dis}able_fiq()
 calls
Message-ID: <20121016213532.GG27665@pengutronix.de>
References: <20121015214954.GA3352@lizard>
 <1350337894-9744-3-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350337894-9744-3-git-send-email-anton.vorontsov@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 23:35:13 up 115 days, 12:46, 44 users,  load average: 2.90, 6.53,
 7.67
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 02:51:27PM -0700, Anton Vorontsov wrote:
> The driver uses platform-specific mxc_set_irq_fiq() with the VIRQ cookie
> passed to it, so it's pretty clear that the driver is absolutely sure
> that the FIQ is routed via platform-specific IC, and that the cookie can
> be used to mask/unmask FIQs. So, let's switch to the genirq routines,
> since we're about to remove FIQ-specific variants.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/media/platform/soc_camera/mx1_camera.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
> index bbe7099..4855a46 100644
> --- a/drivers/media/platform/soc_camera/mx1_camera.c
> +++ b/drivers/media/platform/soc_camera/mx1_camera.c
> @@ -801,7 +801,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
>  	set_fiq_regs(&regs);
>  
>  	mxc_set_irq_fiq(irq, 1);
> -	enable_fiq(irq);
> +	enable_irq(irq);
>  
>  	pcdev->soc_host.drv_name	= DRIVER_NAME;
>  	pcdev->soc_host.ops		= &mx1_soc_camera_host_ops;
> @@ -817,7 +817,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
>  	return 0;
>  
>  exit_free_irq:
> -	disable_fiq(irq);
> +	disable_irq(irq);
>  	mxc_set_irq_fiq(irq, 0);
>  	release_fiq(&fh);
>  exit_free_dma:
> @@ -842,7 +842,7 @@ static int __exit mx1_camera_remove(struct platform_device *pdev)
>  	struct resource *res;
>  
>  	imx_dma_free(pcdev->dma_chan);
> -	disable_fiq(pcdev->irq);
> +	disable_irq(pcdev->irq);
>  	mxc_set_irq_fiq(pcdev->irq, 0);
>  	release_fiq(&fh);
>  
> -- 
> 1.7.12.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

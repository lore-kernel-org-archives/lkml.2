Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2IQR0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:26:37 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:23374 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658Ab2IQR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:26:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19qQT65nS7cWV67HrgaUcRI
Date: Mon, 17 Sep 2012 10:26:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: Re: [PATCH v2 1/2] spi: omap2-mcspi: add pinctrl support
Message-ID: <20120917172630.GP4521@atomide.com>
References: <1347902538-21208-1-git-send-email-mporter@ti.com>
 <1347902538-21208-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347902538-21208-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [120917 10:21]:
> Adds pinctrl support to support OMAP platforms that boot from DT
> and rely on pinctrl support to set pinmuxes.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/spi/spi-omap2-mcspi.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index b2fb141..9502566 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -38,6 +38,8 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>
>  
>  #include <linux/spi/spi.h>
>  
> @@ -1124,6 +1126,7 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
>  	static int		bus_num = 1;
>  	struct device_node	*node = pdev->dev.of_node;
>  	const struct of_device_id *match;
> +	struct pinctrl *pinctrl;
>  
>  	master = spi_alloc_master(&pdev->dev, sizeof *mcspi);
>  	if (master == NULL) {
> @@ -1219,6 +1222,11 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
>  	if (status < 0)
>  		goto dma_chnl_free;
>  
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(&pdev->dev,
> +			"pins are not configured from the driver\n");
> +
>  	pm_runtime_use_autosuspend(&pdev->dev);
>  	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
>  	pm_runtime_enable(&pdev->dev);
> -- 
> 1.7.9.5
> 

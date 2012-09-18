Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab2IRMIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:08:14 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:44672 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757225Ab2IRMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:11 -0400
Message-ID: <50586424.9040601@ti.com>
Date: Tue, 18 Sep 2012 17:38:04 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [REPOST PATCH v2 1/2] spi: omap2-mcspi: add pinctrl support
References: <1347969685-15571-1-git-send-email-mporter@ti.com>
In-Reply-To: <1347969685-15571-1-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012 05:31 PM, Matt Porter wrote:
> Adds pinctrl support to support OMAP platforms that boot from DT
> and rely on pinctrl support to set pinmuxes.
looks good

Acked-by: Shubhrajyoti D <shubhrajyoti@ti.com>


> Signed-off-by: Matt Porter <mporter@ti.com>
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


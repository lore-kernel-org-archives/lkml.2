Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab1LNVL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:11:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40909 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:11:58 -0500
Date: Wed, 14 Dec 2011 22:11:52 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Message-ID: <20111214211152.GM27267@pengutronix.de>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-5-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323878622-26602-5-git-send-email-b29396@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:11:03 up 32 days,  4:58, 19 users,  load average: 0.02, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 12:03:42AM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index 4b976f0..4504136 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -24,6 +24,7 @@
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/of_gpio.h>
> +#include <linux/pinctrl/pinmux.h>
>  #include <mach/esdhc.h>
>  #include "sdhci-pltfm.h"
>  #include "sdhci-esdhc.h"
> @@ -68,6 +69,7 @@ struct pltfm_imx_data {
>  	int flags;
>  	u32 scratchpad;
>  	enum imx_esdhc_type devtype;
> +	struct pinmux *pmx;
>  	struct esdhc_platform_data boarddata;
>  };
>  
> @@ -439,6 +441,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  	struct clk *clk;
>  	int err;
>  	struct pltfm_imx_data *imx_data;
> +	struct pinmux *pmx;
>  
>  	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_imx_pdata);
>  	if (IS_ERR(host))
> @@ -466,6 +469,16 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  	clk_enable(clk);
>  	pltfm_host->clk = clk;
>  
> +	pmx = pinmux_get(&pdev->dev, NULL);
> +	if (IS_ERR(pmx)) {
> +		err = PTR_ERR(pmx);
> +		goto err_pmx_get;
> +	}
> +	err = pinmux_enable(pmx);
> +	if (err)
> +		goto err_pmx_enable;
> +	imx_data->pmx = pmx;
> +

Won't this break every i.MX except i.MX6?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

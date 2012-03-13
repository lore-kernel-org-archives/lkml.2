Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2CMNNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:13:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52066 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2CMNNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:13:10 -0400
Date: Tue, 13 Mar 2012 14:13:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com, kernel@pengutronix.de
Subject: Re: [PATCH] dma: imx-sdma: Treat firmware messages as warnings
 instead of erros
Message-ID: <20120313131307.GD3852@pengutronix.de>
References: <1331209599-23802-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331209599-23802-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:12:49 up 121 days, 20:59, 81 users,  load average: 0.13, 1.87,
 1.28
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 09:26:39AM -0300, Fabio Estevam wrote:
> As the SDMA controller can operate without an external firmware being loaded,
> treat the firmware related messages as warnings rather than errors.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/dma/imx-sdma.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index c495882..3b7ebd4 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1389,7 +1389,7 @@ static int __init sdma_probe(struct platform_device *pdev)
>  	if (pdata) {
>  		ret = sdma_get_firmware(sdma, pdata->fw_name);
>  		if (ret)
> -			dev_err(&pdev->dev, "failed to get firmware from platform data\n");
> +			dev_warn(&pdev->dev, "failed to get firmware from platform data\n");
>  	} else {
>  		/*
>  		 * Because that device tree does not encode ROM script address,
> @@ -1399,11 +1399,11 @@ static int __init sdma_probe(struct platform_device *pdev)
>  		ret = of_property_read_string(np, "fsl,sdma-ram-script-name",
>  					      &fw_name);
>  		if (ret)
> -			dev_err(&pdev->dev, "failed to get firmware name\n");
> +			dev_warn(&pdev->dev, "failed to get firmware name\n");
>  		else {
>  			ret = sdma_get_firmware(sdma, fw_name);
>  			if (ret)
> -				dev_err(&pdev->dev, "failed to get firmware from device tree\n");
> +				dev_warn(&pdev->dev, "failed to get firmware from device tree\n");
>  		}
>  	}
>  
> -- 
> 1.7.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

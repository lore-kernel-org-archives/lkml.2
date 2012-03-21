Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab2CUKF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:05:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:44033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab2CUKFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:05:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="119930830"
Subject: Re: [PATCH] dma: imx-sdma: Treat firmware messages as warnings
 instead of erros
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
In-Reply-To: <1331209599-23802-1-git-send-email-fabio.estevam@freescale.com>
References: <1331209599-23802-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 15:39:21 +0530
Message-ID: <1332324561.19804.0.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 09:26 -0300, Fabio Estevam wrote:
> As the SDMA controller can operate without an external firmware being loaded,
> treat the firmware related messages as warnings rather than errors.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Applied Thanks
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


-- 
~Vinod


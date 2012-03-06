Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab2CFMAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:00:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:28175 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929Ab2CFMAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134204610"
Subject: Re: [PATCH 1/2] dma: imx-sdma: Let the driver be probed even if no
 firware is found
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        kernel@pengutronix.de, shawn.guo@freescale.com,
        Fabio Estevam <fabio.estevam@freescale.com>
In-Reply-To: <1330525238-25420-1-git-send-email-festevam@gmail.com>
References: <1330525238-25420-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 17:34:43 +0530
Message-ID: <1331035483.24656.198.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 11:20 -0300, Fabio Estevam wrote:
> On the device tree case the code bails out when the firmware name cannot be found
> or if the firmware fails to be requested.
> 
> Fix this behaviour as the SDMA engine can still operate with the built-in
> ROM scripts.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Both Applied, Thanks
> ---
>  drivers/dma/imx-sdma.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index bf736ad..130b994 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1397,15 +1397,12 @@ static int __init sdma_probe(struct platform_device *pdev)
>  		 */
>  		ret = of_property_read_string(np, "fsl,sdma-ram-script-name",
>  					      &fw_name);
> -		if (ret) {
> +		if (ret)
>  			dev_err(&pdev->dev, "failed to get firmware name\n");
> -			goto err_init;
> -		}
> -
> -		ret = sdma_get_firmware(sdma, fw_name);
> -		if (ret) {
> -			dev_err(&pdev->dev, "failed to get firmware\n");
> -			goto err_init;
> +		else {
> +			ret = sdma_get_firmware(sdma, fw_name);
> +			if (ret)
> +				dev_err(&pdev->dev, "failed to get firmware\n");
>  		}
>  	}
>  


-- 
~Vinod


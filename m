Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994Ab2CBHVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:21:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35687 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803Ab2CBHVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:21:30 -0500
Date: Fri, 2 Mar 2012 08:21:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, kernel@pengutronix.de, shawn.guo@freescale.com,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/2] dma: imx-sdma: Let the driver be probed even if no
 firware is found
Message-ID: <20120302072122.GF3852@pengutronix.de>
References: <1330525238-25420-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330525238-25420-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:20:57 up 110 days, 15:08, 26 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:20:37AM -0300, Fabio Estevam wrote:
> On the device tree case the code bails out when the firmware name cannot be found
> or if the firmware fails to be requested.
> 
> Fix this behaviour as the SDMA engine can still operate with the built-in
> ROM scripts.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Both patches:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


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
> -- 
> 1.7.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

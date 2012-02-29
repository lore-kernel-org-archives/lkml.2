Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2B2Iiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:38:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44347 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab2B2Iit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:38:49 -0500
Date: Wed, 29 Feb 2012 09:38:45 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        shawn.guo@freescale.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: imx-sdma: Add error check on sdma_get_firmware
Message-ID: <20120229083845.GU3852@pengutronix.de>
References: <1329756590-19993-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329756590-19993-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:35:52 up 108 days, 16:22, 30 users,  load average: 0.00, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 02:49:50PM -0200, Fabio Estevam wrote:
> Add error check on sdma_get_firmware for the pdata case.
> 
> While at it, distinguish the error message between the pdata and dt cases.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/dma/imx-sdma.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index bf736ad..52a4e6a 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1388,7 +1388,11 @@ static int __init sdma_probe(struct platform_device *pdev)
>  		sdma_add_scripts(sdma, pdata->script_addrs);
>  
>  	if (pdata) {
> -		sdma_get_firmware(sdma, pdata->fw_name);
> +		ret = sdma_get_firmware(sdma, pdata->fw_name);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to get firmware from pdata\n");
> +			goto err_init;
> +		}

No, you shouldn't bail out here. A failure in sdma_get_firmware only
means that we don't have the RAM scripts, but we can continue with the
ROM scripts and still do useful things in the driver.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

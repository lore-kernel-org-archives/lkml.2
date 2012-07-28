Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2G1PWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 11:22:11 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34104
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab2G1PWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 11:22:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275bhz2dh87h2a8h668h839h944hd25he96hf0ah107ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 28 Jul 2012 23:21:58 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <vinod.koul@intel.com>, <kernel@pengutronix.de>, <marex@denx.de>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: mxs_dma: Add the missing entries for mx6
Message-ID: <20120728152157.GK2128@S2101-09.ap.freescale.net>
References: <1343217242-32686-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343217242-32686-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 08:54:02AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Add the missing entries for mx6.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Build tested only, as I currently do not have mx6 board handy.
> 
>  drivers/dma/mxs-dma.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 7f41b25..6e8509b 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -128,6 +128,7 @@ enum mxs_dma_devtype {
>  enum mxs_dma_id {
>  	IMX23_DMA,
>  	IMX28_DMA,
> +	IMX6Q_DMA,
>  };
>  
>  struct mxs_dma_engine {
> @@ -158,7 +159,10 @@ static struct mxs_dma_type mxs_dma_types[] = {
>  	}, {
>  		.id = IMX28_DMA,
>  		.type = MXS_DMA_APBX,
> -	}
> +	}, {
> +		.id = IMX6Q_DMA,
> +		.type = MXS_DMA_APBH,
> +	},
>  };
>  
>  static struct platform_device_id mxs_dma_ids[] = {
> @@ -175,6 +179,8 @@ static struct platform_device_id mxs_dma_ids[] = {
>  		.name = "imx28-dma-apbx",
>  		.driver_data = (kernel_ulong_t) &mxs_dma_types[3],
>  	}, {
> +		.name = "imx6q-dma-apbh",
> +		.driver_data = (kernel_ulong_t) &mxs_dma_types[4],
>  		/* end of list */
>  	}
>  };
> @@ -184,6 +190,7 @@ static const struct of_device_id mxs_dma_dt_ids[] = {
>  	{ .compatible = "fsl,imx23-dma-apbx", .data = &mxs_dma_ids[1], },
>  	{ .compatible = "fsl,imx28-dma-apbh", .data = &mxs_dma_ids[2], },
>  	{ .compatible = "fsl,imx28-dma-apbx", .data = &mxs_dma_ids[3], },
> +	{ .compatible = "fsl,imx6q-dma-apbh", .data = &mxs_dma_ids[4], },

We do not need it.  "fsl,imx28-dma-apbh" should just work for imx6q.

Regards,
Shawn

>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, mxs_dma_dt_ids);
> -- 
> 1.7.1
> 


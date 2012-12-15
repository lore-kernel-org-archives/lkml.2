Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422645Ab2LOAg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:36:28 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34469 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2LOAg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:36:26 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] spi: omap2: disable DMA requests before complete()
To: Felipe Balbi <balbi@ti.com>, spi-devel-general@lists.sourceforge.net,
        rob@landley.net, rob.herring@calxeda.com
Cc: devicetree-discuss@lists.ozlabs.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
In-Reply-To: <1355301960-21523-1-git-send-email-balbi@ti.com>
References: <1355301960-21523-1-git-send-email-balbi@ti.com>
Date: Sat, 15 Dec 2012 00:35:39 +0000
Message-Id: <20121215003539.40B933E0BEF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012 10:45:59 +0200, Felipe Balbi <balbi@ti.com> wrote:
> No actual errors have been found for completing
> before disabling DMA request lines, but it just
> looks more semantically correct that on our DMA
> callback we quiesce the whole thing before stating
> transfer is finished.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-omap2-mcspi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index b610f52..68446db 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -298,10 +298,10 @@ static void omap2_mcspi_rx_callback(void *data)
>  	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
>  	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select];
>  
> -	complete(&mcspi_dma->dma_rx_completion);
> -
>  	/* We must disable the DMA RX request */
>  	omap2_mcspi_set_dma_req(spi, 1, 0);
> +
> +	complete(&mcspi_dma->dma_rx_completion);
>  }
>  
>  static void omap2_mcspi_tx_callback(void *data)
> @@ -310,10 +310,10 @@ static void omap2_mcspi_tx_callback(void *data)
>  	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
>  	struct omap2_mcspi_dma *mcspi_dma = &mcspi->dma_channels[spi->chip_select];
>  
> -	complete(&mcspi_dma->dma_tx_completion);
> -
>  	/* We must disable the DMA TX request */
>  	omap2_mcspi_set_dma_req(spi, 0, 0);
> +
> +	complete(&mcspi_dma->dma_tx_completion);
>  }
>  
>  static void omap2_mcspi_tx_dma(struct spi_device *spi,
> -- 
> 1.8.1.rc1.5.g7e0651a
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.

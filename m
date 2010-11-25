Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0KYJEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:04:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55438 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0KYJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:04:39 -0500
Date: Thu, 25 Nov 2010 10:04:35 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dmaengine: imx-sdma: fix bug in buffer descriptor
	initialization
Message-ID: <20101125090435.GQ6017@pengutronix.de>
References: <1290447318-29333-1-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290447318-29333-1-git-send-email-agust@denx.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:04:21 up 145 days, 15 min, 59 users,  load average: 0.18,
	0.22, 0.39
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 06:35:18PM +0100, Anatolij Gustschin wrote:
> Currently while submitting scatterlists with more than one SG
> entry the DMA buffer address from the first SG entry is inserted
> into all initialized DMA buffer descriptors. This is due to the
> typo in the for_each_sg() loop where the scatterlist pointer is
> used for obtaining the DMA buffer address and _not_ the SG list
> iterator.
> 
> As a result all received data will be written only into the first
> DMA buffer while reading. While writing the data from the first
> DMA buffer is send to the device multiple times. This caused
> the filesystem destruction on the MMC card when using DMA in
> mxcmmc driver.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/dma/imx-sdma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 0834323..13d6447 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -951,7 +951,7 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
>  		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
>  		int param;
>  
> -		bd->buffer_addr = sgl->dma_address;
> +		bd->buffer_addr = sg->dma_address;
>  
>  		count = sg->length;
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

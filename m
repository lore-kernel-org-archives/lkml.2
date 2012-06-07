Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab2FGI1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:27:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:61012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab2FGI0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:26:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162137495"
Subject: Re: [RESEND PATCH] dma: imx-sdma: buf_tail should be initialize in
 prepare function
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawn.guo@gmail.com, kernel@pengutronix.de, dan.j.williams@intel.com,
        linuxzsc@gmail.com
In-Reply-To: <1338772644-3344-1-git-send-email-richard.zhao@freescale.com>
References: <1338772644-3344-1-git-send-email-richard.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 13:50:03 +0530
Message-ID: <1339057203.1927.9.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 09:17 +0800, Richard Zhao wrote:
> This fix audio underrun issue. When SNDRV_PCM_TRIGGER_STOP
> and SNDRV_PCM_TRIGGER_START, it calls prepare again. buf_tail
> should be reset to zero.
> So move buf_tail initialization into prepare function.
> 
> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/dma/imx-sdma.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index fb4f499..1dc2a4a 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -815,8 +815,6 @@ static int sdma_request_channel(struct sdma_channel *sdmac)
>  
>  	init_completion(&sdmac->done);
>  
> -	sdmac->buf_tail = 0;
> -
>  	return 0;
>  out:
>  
> @@ -927,6 +925,8 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
>  
>  	sdmac->flags = 0;
>  
> +	sdmac->buf_tail = 0;
> +
>  	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
>  			sg_len, channel);
>  
> @@ -1027,6 +1027,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
>  
>  	sdmac->status = DMA_IN_PROGRESS;
>  
> +	sdmac->buf_tail = 0;
> +
>  	sdmac->flags |= IMX_DMA_SG_LOOP;
>  	sdmac->direction = direction;
>  	ret = sdma_load_context(sdmac);

Applied, Thanks
-- 
~Vinod


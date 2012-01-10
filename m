Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2AJC6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:58:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54356 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2AJC6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:58:43 -0500
Date: Tue, 10 Jan 2012 11:09:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        eric.miao@linaro.org, patches@linaro.org
Subject: Re: [PATCH 2/2] dma/imx-sdma: move clk_enable out of
 sdma_request_channel
Message-ID: <20120110030917.GB23362@S2101-09.ap.freescale.net>
References: <1326098940-3697-1-git-send-email-richard.zhao@linaro.org>
 <1326098940-3697-2-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326098940-3697-2-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:49:00PM +0800, Richard Zhao wrote:
> It makes clk_enable/disable pair more readable, and fix one bug:
> sdma_init calls sdma_request_channel, but seems don't know
> sdma_request_channel enabled the clok.
> 
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>

Since clk_disable is being called in sdma_free_chan_resources, it's
generally a good idea to call clk_enable in sdma_alloc_chan_resources.

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn

> ---
>  drivers/dma/imx-sdma.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 6376009..2a0e02d 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -802,8 +802,6 @@ static int sdma_request_channel(struct sdma_channel *sdmac)
>  	sdma->channel_control[channel].base_bd_ptr = sdmac->bd_phys;
>  	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
>  
> -	clk_enable(sdma->clk);
> -
>  	sdma_set_channel_priority(sdmac, MXC_SDMA_DEFAULT_PRIORITY);
>  
>  	init_completion(&sdmac->done);
> @@ -875,6 +873,9 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
>  
>  	sdmac->peripheral_type = data->peripheral_type;
>  	sdmac->event_id0 = data->dma_request;
> +
> +	clk_enable(sdmac->sdma->clk);
> +
>  	ret = sdma_request_channel(sdmac);
>  	if (ret)
>  		return ret;
> -- 
> 1.7.5.4
> 
> 

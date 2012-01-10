Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2AJCvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:51:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63663 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2AJCvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:51:49 -0500
Date: Tue, 10 Jan 2012 11:02:25 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        eric.miao@linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] dma/imx-sdma: call sdma_set_channel_priority after
 sdma_request_channel
Message-ID: <20120110030220.GA23362@S2101-09.ap.freescale.net>
References: <1326098940-3697-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326098940-3697-1-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:48:59PM +0800, Richard Zhao wrote:
> sdma_request_channel sets the default priority. sdma_alloc_chan_resources
> should call sdma_set_channel_priority thereafter to over write it.
> 
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn

> ---
>  drivers/dma/imx-sdma.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 2cc96c4..6376009 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -875,11 +875,11 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
>  
>  	sdmac->peripheral_type = data->peripheral_type;
>  	sdmac->event_id0 = data->dma_request;
> -	ret = sdma_set_channel_priority(sdmac, prio);
> +	ret = sdma_request_channel(sdmac);
>  	if (ret)
>  		return ret;
>  
> -	ret = sdma_request_channel(sdmac);
> +	ret = sdma_set_channel_priority(sdmac, prio);
>  	if (ret)
>  		return ret;
>  
> -- 
> 1.7.5.4
> 
> 

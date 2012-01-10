Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2AJOGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:06:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2AJOGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:06:16 -0500
Date: Tue, 10 Jan 2012 22:16:55 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        eric.miao@linaro.org, patches@linaro.org
Subject: Re: [PATCH 5/6] dma/imx-sdma: use num_events to validate event_id0
Message-ID: <20120110141653.GD26599@S2101-09.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-5-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326178910-14044-5-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 03:01:49PM +0800, Richard Zhao wrote:
> event number is not always 32. use num_events for checking instead.
> 
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn

> ---
>  drivers/dma/imx-sdma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 015d93f..22fd561 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -723,7 +723,7 @@ static int sdma_config_channel(struct sdma_channel *sdmac)
>  	sdmac->per_addr = 0;
>  
>  	if (sdmac->event_id0) {
> -		if (sdmac->event_id0 > 32)
> +		if (sdmac->event_id0 >= sdmac->sdma->num_events)
>  			return -EINVAL;
>  		sdma_event_enable(sdmac, sdmac->event_id0);
>  	}
> -- 
> 1.7.5.4
> 
> 

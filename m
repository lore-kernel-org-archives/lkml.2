Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2AJOJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:09:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56595 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2AJOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:09:32 -0500
Date: Tue, 10 Jan 2012 22:20:10 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        eric.miao@linaro.org, patches@linaro.org
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set
 event_mask
Message-ID: <20120110142008.GE26599@S2101-09.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 03:01:50PM +0800, Richard Zhao wrote:
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> ---

I think it deserves a sensible commit message explaining why the patch
is needed.

Regards,
Shawn

>  drivers/dma/imx-sdma.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 22fd561..1d5b6ab 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -753,8 +753,11 @@ static int sdma_config_channel(struct sdma_channel *sdmac)
>  			if (sdmac->event_id0 > 31)
>  				sdmac->watermark_level |= 1 << 30;
>  		} else {
> -			sdmac->event_mask0 = 1 << sdmac->event_id0;
> -			sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
> +			if (sdmac->event_id0 < 32)
> +				sdmac->event_mask0 = 1 << sdmac->event_id0;
> +			else
> +				sdmac->event_mask1 =
> +						1 << (sdmac->event_id0 - 32);
>  		}
>  		/* Watermark Level */
>  		sdmac->watermark_level |= sdmac->watermark_level;
> -- 
> 1.7.5.4
> 
> 

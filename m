Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2AEJNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:13:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50055 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2AEJNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:13:06 -0500
Date: Thu, 5 Jan 2012 17:23:17 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        eric.miao@linaro.org, patches@linaro.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/2] dma/imx-sdma: use writel to write register when
 enable a channel
Message-ID: <20120105092316.GB1729@S2101-09.ap.freescale.net>
References: <1325750362-22598-1-git-send-email-richard.zhao@linaro.org>
 <1325750362-22598-3-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325750362-22598-3-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:59:22PM +0800, Richard Zhao wrote:
> dma_alloc_coherent memory may be bufferable when set
> CONFIG_ARM_DMA_MEM_BUFFERABLE. We need to add nececcary
> memory barrier. writel implicitly call wmb in such case.
> 
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> ---
>  drivers/dma/imx-sdma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index c2bc4f1..e987468 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -396,7 +396,7 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
>  
>  static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
>  {
> -	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
> +	writel(1 << channel, sdma->regs + SDMA_H_START);
>  }
>  

As educated by Arnd, generally it's safer to use pair of readl/writel
than __raw_readl/__raw_writel in driver.  I'm wondering if it's a good
opportunity for us to change the pair all over this driver.

-- 
Regards,
Shawn

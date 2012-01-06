Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2AFGDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:03:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:34673 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab2AFGDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:03:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="93544272"
Subject: Re: [PATCH] dma/imx-sdma: save irq flags when use spin_lock in
 sdma_tx_submit
From: Vinod Koul <vinod.koul@intel.com>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, shawn.guo@linaro.org, dan.j.williams@intel.com,
        eric.miao@linaro.org, patches@linaro.org,
        Haitao Zhang <minipanda@linuxrobot.org>,
        Haitao Zhang <haitao.zhang@linaro.org>
In-Reply-To: <1325388606-20732-1-git-send-email-richard.zhao@linaro.org>
References: <1325388606-20732-1-git-send-email-richard.zhao@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 11:33:28 +0530
Message-ID: <1325829808.1540.96.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-01 at 11:30 +0800, Richard Zhao wrote:
> From: Haitao Zhang <minipanda@linuxrobot.org>
> 
> mx53_loco: fix deadlock report from sdma_tx_submit() during boot
> 
> BugLink: http://bugs.launchpad.net/bugs/878701
> 
> Adjust to use spin_lock_irqsave()/spin_unlock_irqresotre(), so to
> make it safe when called from interrupt context.
> 
> Signed-off-by: Haitao Zhang <haitao.zhang@linaro.org>
> Signed-off-by: Eric Miao <eric.miao@linaro.org>
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
Applied thanks

> ---
>  drivers/dma/imx-sdma.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index f993955..2b7a88b 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -832,17 +832,18 @@ static struct sdma_channel *to_sdma_chan(struct dma_chan *chan)
>  
>  static dma_cookie_t sdma_tx_submit(struct dma_async_tx_descriptor *tx)
>  {
> +	unsigned long flags;
>  	struct sdma_channel *sdmac = to_sdma_chan(tx->chan);
>  	struct sdma_engine *sdma = sdmac->sdma;
>  	dma_cookie_t cookie;
>  
> -	spin_lock_irq(&sdmac->lock);
> +	spin_lock_irqsave(&sdmac->lock, flags);
>  
>  	cookie = sdma_assign_cookie(sdmac);
>  
>  	sdma_enable_channel(sdma, sdmac->channel);
>  
> -	spin_unlock_irq(&sdmac->lock);
> +	spin_unlock_irqrestore(&sdmac->lock, flags);
>  
>  	return cookie;
>  }


-- 
~Vinod


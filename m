Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2ACInn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:43:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2ACInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:43:41 -0500
Date: Tue, 3 Jan 2012 09:43:30 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, shawn.guo@linaro.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, eric.miao@linaro.org, patches@linaro.org,
        Haitao Zhang <minipanda@linuxrobot.org>,
        Haitao Zhang <haitao.zhang@linaro.org>
Subject: Re: [PATCH] dma/imx-sdma: save irq flags when use spin_lock in
 sdma_tx_submit
Message-ID: <20120103084330.GG5446@pengutronix.de>
References: <1325388606-20732-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325388606-20732-1-git-send-email-richard.zhao@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:43:09 up 51 days, 16:30, 18 users,  load average: 0.00, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 01, 2012 at 11:30:06AM +0800, Richard Zhao wrote:
> From: Haitao Zhang <minipanda@linuxrobot.org>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

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
> -- 
> 1.7.4.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

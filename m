Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab2AAHOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 02:14:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48288 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2AAHOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 02:14:34 -0500
Date: Sun, 1 Jan 2012 08:14:25 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, shawn.guo@linaro.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, eric.miao@linaro.org, patches@linaro.org
Subject: Re: [PATCH] dma/imx-sdma: add wmb before enable/run a channel
Message-ID: <20120101071425.GA25978@pengutronix.de>
References: <1325388460-20678-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325388460-20678-1-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On Sun, Jan 01, 2012 at 11:27:40AM +0800, Richard Zhao wrote:
> dma_alloc_coherent memory may be bufferable. We need to add
> nececcary memory barrier.
necessary

> 
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> ---
>  drivers/dma/imx-sdma.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 2ebb2bc..8cd9492 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -403,6 +403,7 @@ static int sdma_run_channel(struct sdma_channel *sdmac)
>  
>  	init_completion(&sdmac->done);
>  
> +	wmb();
>  	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
>  
>  	ret = wait_for_completion_timeout(&sdmac->done, HZ);
> @@ -809,6 +810,7 @@ out:
>  
>  static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
>  {
> +	wmb();
>  	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
>  }
I don't know the sdma code very well, but wouldn't it be nice to call
sdma_enable_channel() in sdma_run_channel() instead of open coding it?

As you probably need some rearrangements to have sdma_enable_channel()
declared in sdma_run_channel() this might be better done with a seperate
patch.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

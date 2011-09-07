Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1IGRBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:01:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:14777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab1IGQ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45905411"
Subject: Re: [PATCH 33/62] dmaengine: irq: Remove IRQF_DISABLED
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        mingo@elte.hu, tglx@linutronix.de,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1315383059-3673-34-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
	 <1315383059-3673-34-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 20:32:04 +0530
Message-ID: <1315407724.11863.0.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 16:10 +0800, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  drivers/dma/amba-pl08x.c |    2 +-
>  drivers/dma/coh901318.c  |    2 +-
>  drivers/dma/shdma.c      |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index be21e3f..3688256 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1930,7 +1930,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  	writel(0x000000FF, pl08x->base + PL080_ERR_CLEAR);
>  	writel(0x000000FF, pl08x->base + PL080_TC_CLEAR);
>  
> -	ret = request_irq(adev->irq[0], pl08x_irq, IRQF_DISABLED,
> +	ret = request_irq(adev->irq[0], pl08x_irq, 0,
>  			  DRIVER_NAME, pl08x);
>  	if (ret) {
>  		dev_err(&adev->dev, "%s failed to request interrupt %d\n",
> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> index 4234f41..1dd9455 100644
> --- a/drivers/dma/coh901318.c
> +++ b/drivers/dma/coh901318.c
> @@ -1506,7 +1506,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		goto err_no_irq;
>  
> -	err = request_irq(irq, dma_irq_handler, IRQF_DISABLED,
> +	err = request_irq(irq, dma_irq_handler, 0,
>  			  "coh901318", base);
>  	if (err) {
>  		dev_crit(&pdev->dev,
> diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
> index 7f49235..8c137d2 100644
> --- a/drivers/dma/shdma.c
> +++ b/drivers/dma/shdma.c
> @@ -1106,7 +1106,7 @@ static void sh_dmae_chan_remove(struct sh_dmae_device *shdev)
>  static int __init sh_dmae_probe(struct platform_device *pdev)
>  {
>  	struct sh_dmae_pdata *pdata = pdev->dev.platform_data;
> -	unsigned long irqflags = IRQF_DISABLED,
> +	unsigned long irqflags = 0,
>  		chan_flag[SH_DMAC_MAX_CHANNELS] = {};
>  	int errirq, chan_irq[SH_DMAC_MAX_CHANNELS];
>  	int err, i, irq_cnt = 0, irqres = 0, irq_cap = 0;
> @@ -1266,7 +1266,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
>  				    IORESOURCE_IRQ_SHAREABLE)
>  					chan_flag[irq_cnt] = IRQF_SHARED;
>  				else
> -					chan_flag[irq_cnt] = IRQF_DISABLED;
> +					chan_flag[irq_cnt] = 0;
>  				dev_dbg(&pdev->dev,
>  					"Found IRQ %d for channel %d\n",
>  					i, irq_cnt);
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

--
~Vinod


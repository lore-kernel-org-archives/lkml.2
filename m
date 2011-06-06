Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab1FFItx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:49:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:39925 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab1FFItv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,325,1304319600"; 
   d="scan'208";a="12259803"
Subject: Re: [PATCH] dma: at_hdmac.c: use resource_size
From: "Koul, Vinod" <vinod.koul@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com
In-Reply-To: <201106011516.09302.hartleys@visionengravers.com>
References: <201106011516.09302.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 13:45:00 +0530
Message-ID: <1307348100.10976.80.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 15:16 -0700, H Hartley Sweeten wrote:
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> 
> ---
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 36144f8..6a483ea 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1216,7 +1216,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  	atdma->dma_common.cap_mask = pdata->cap_mask;
>  	atdma->all_chan_mask = (1 << pdata->nr_channels) - 1;
>  
> -	size = io->end - io->start + 1;
> +	size = resource_size(io);
>  	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
>  		err = -EBUSY;
>  		goto err_kfree;
> @@ -1362,7 +1362,7 @@ static int __exit at_dma_remove(struct platform_device *pdev)
>  	atdma->regs = NULL;
>  
>  	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(io->start, io->end - io->start + 1);
> +	release_mem_region(io->start, resource_size(io));
>  
>  	kfree(atdma);
>  
Applied, Thanks

-- 
~Vinod


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2BARBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:01:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:56601 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab2BARBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:01:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119183819"
Subject: Re: [PATCH 1/2] dma: sh_dma: not all SH DMAC implementations
 support MEMCPY
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1201181012130.28782@axis700.grange>
References: <Pine.LNX.4.64.1201181012130.28782@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 22:32:28 +0530
Message-ID: <1328115748.1610.34.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 10:14 +0100, Guennadi Liakhovetski wrote:
> Add a flag to allow platforms to specify, whether a DMAC instance supports
> the MEMCPY operation. To avoid regressions, preserve the current default.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Applied both, Thanks
> ---
>  drivers/dma/shdma.c    |    3 ++-
>  include/linux/sh_dma.h |    1 +
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
> index cabcfe8..e4ed4da 100644
> --- a/drivers/dma/shdma.c
> +++ b/drivers/dma/shdma.c
> @@ -1267,7 +1267,8 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
>  
>  	INIT_LIST_HEAD(&shdev->common.channels);
>  
> -	dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
> +	if (!pdata->slave_only)
> +		dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
>  	if (pdata->slave && pdata->slave_num)
>  		dma_cap_set(DMA_SLAVE, shdev->common.cap_mask);
>  
> diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> index e11e171..db637b9 100644
> --- a/include/linux/sh_dma.h
> +++ b/include/linux/sh_dma.h
> @@ -70,6 +70,7 @@ struct sh_dmae_pdata {
>  	unsigned int needs_tend_set:1;
>  	unsigned int no_dmars:1;
>  	unsigned int chclr_present:1;
> +	unsigned int slave_only:1;
>  };
>  
>  /* DMA register */


-- 
~Vinod


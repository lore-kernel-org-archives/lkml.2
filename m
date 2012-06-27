Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2F0Nir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:38:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:22321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2F0Nip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:38:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170640586"
Subject: Re: [PATCH 1/2] dma: tegra: set DMA_CYCLIC capability
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
In-Reply-To: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
References: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jun 2012 18:59:08 +0530
Message-ID: <1340803748.1562.244.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 17:12 +0530, Laxman Dewangan wrote:
> Tegra's APB DMA driver support the cyclic mode of data
> transfer and hence setting the DMA_CYCLIC caps for dma
> channels.
> 
> This is require when generic sound dmaengine pcm driver
> request for dma channel with CYCLIC capability.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/dma/tegra20-apb-dma.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> index 134ea7c..b4bd50c 100644
> --- a/drivers/dma/tegra20-apb-dma.c
> +++ b/drivers/dma/tegra20-apb-dma.c
> @@ -1306,6 +1306,8 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
>  
>  	dma_cap_set(DMA_SLAVE, tdma->dma_dev.cap_mask);
>  	dma_cap_set(DMA_PRIVATE, tdma->dma_dev.cap_mask);
> +	dma_cap_set(DMA_CYCLIC, tdma->dma_dev.cap_mask);
> +
>  	tdma->dma_dev.dev = &pdev->dev;
>  	tdma->dma_dev.device_alloc_chan_resources =
>  					tegra_dma_alloc_chan_resources;
What sort of testing went into this.
I can see that you are marking descriptor complete even for cyclic case,
that is wrong you should fix that as well. See the other drivers for
cyclic handling of descriptors.

-- 
~Vinod


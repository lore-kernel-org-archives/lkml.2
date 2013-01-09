Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3AINzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:55:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:15823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726Ab3AINzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:55:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,438,1355126400"; 
   d="scan'208";a="244030910"
Date: Wed, 9 Jan 2013 05:30:53 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: djbw@fb.com, linux-kernel@vger.kernel.org, swarren@nvidia.com,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH RESEND] dma: tegra: implement flags parameters for
 cyclic transfer
Message-ID: <20130109133053.GM19691@intel.com>
References: <1357725382-25780-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357725382-25780-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 03:26:22PM +0530, Laxman Dewangan wrote:
> The flag parameter is added in the cyclic transfer request.
> Use the flag option of:
> - DMA_PREP_INTERRUPT for enabling interrupt.
> - DMA_CTRL_ACK for deciding whether ack is requred or not for
>   descriptor.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Applied thanks

--
~Vinod
> ---
> Vinod,
> This patch was sent before holiday and may be it is missed in you radar.
> You have already applied my other patches on dma which was sent later so
> resending this patch.
> Stephen wanted this to be part of stable branch also.
> This is against bug fixes and new feature added in K3.7 for cyclic transfer without
> interrupt.
> 
>  drivers/dma/tegra20-apb-dma.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> index efdfffa..bf58bb8 100644
> --- a/drivers/dma/tegra20-apb-dma.c
> +++ b/drivers/dma/tegra20-apb-dma.c
> @@ -266,6 +266,7 @@ static struct tegra_dma_desc *tegra_dma_desc_get(
>  		if (async_tx_test_ack(&dma_desc->txd)) {
>  			list_del(&dma_desc->node);
>  			spin_unlock_irqrestore(&tdc->lock, flags);
> +			dma_desc->txd.flags = 0;
>  			return dma_desc;
>  		}
>  	}
> @@ -1050,7 +1051,9 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
>  					TEGRA_APBDMA_AHBSEQ_WRAP_SHIFT;
>  	ahb_seq |= TEGRA_APBDMA_AHBSEQ_BUS_WIDTH_32;
>  
> -	csr |= TEGRA_APBDMA_CSR_FLOW | TEGRA_APBDMA_CSR_IE_EOC;
> +	csr |= TEGRA_APBDMA_CSR_FLOW;
> +	if (flags & DMA_PREP_INTERRUPT)
> +		csr |= TEGRA_APBDMA_CSR_IE_EOC;
>  	csr |= tdc->dma_sconfig.slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
>  
>  	apb_seq |= TEGRA_APBDMA_APBSEQ_WRAP_WORD_1;
> @@ -1095,7 +1098,8 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
>  		mem += len;
>  	}
>  	sg_req->last_sg = true;
> -	dma_desc->txd.flags = 0;
> +	if (flags & DMA_CTRL_ACK)
> +		dma_desc->txd.flags = DMA_CTRL_ACK;
>  
>  	/*
>  	 * Make sure that mode should not be conflicting with currently
> -- 
> 1.7.1.1
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab2IRD3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:29:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:36145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab2IRD3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:29:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,439,1344236400"; 
   d="scan'208";a="193910524"
Subject: Re: [PATCH] dmaengine: use kmem_cache_zalloc instead of
 kmem_cache_alloc/memset
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: djbw@fb.com, yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd-GhyvXvS0iKCwP_fcp8EsUeihjp6HSpLLbWtQiz06zuQ@mail.gmail.com>
References: <CAPgLHd-GhyvXvS0iKCwP_fcp8EsUeihjp6HSpLLbWtQiz06zuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 08:55:33 +0530
Message-ID: <1347938733.1943.169.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-27 at 12:40 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/dma/ioat/dma_v2.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> index 8689576..b9d6678 100644
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -434,12 +434,11 @@ static struct ioat_ring_ent *ioat2_alloc_ring_ent(struct dma_chan *chan, gfp_t f
>  		return NULL;
>  	memset(hw, 0, sizeof(*hw));
>  
> -	desc = kmem_cache_alloc(ioat2_cache, flags);
> +	desc = kmem_cache_zalloc(ioat2_cache, flags);
>  	if (!desc) {
>  		pci_pool_free(dma->dma_pool, hw, phys);
>  		return NULL;
>  	}
> -	memset(desc, 0, sizeof(*desc));
>  
>  	dma_async_tx_descriptor_init(&desc->txd, chan);
>  	desc->txd.tx_submit = ioat2_tx_submit_unlock;
Applied thanks


-- 
~Vinod


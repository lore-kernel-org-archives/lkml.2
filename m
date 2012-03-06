Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180Ab2CFL1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:27:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:27146 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965161Ab2CFL1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:27:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="74141620"
Subject: Re: [PATCH] dma: dmaengine: Distinguish between 'dmaengine: failed
 to get' messages
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        Fabio Estevam <fabio.estevam@freescale.com>
In-Reply-To: <1329835919-18425-1-git-send-email-festevam@gmail.com>
References: <1329835919-18425-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 17:01:38 +0530
Message-ID: <1331033498.24656.196.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 12:51 -0200, Fabio Estevam wrote:
> The message "dmaengine: failed to get" can come from two possible locations within dmaengine.c.
> 
> In order to distinguish between them, replace "dmaengine" with __func__ string so that the
> source function of the error message can be easily identified.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/dma/dmaengine.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index a6c6051..ac10325 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -510,8 +510,8 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
>  					 dma_chan_name(chan));
>  				list_del_rcu(&device->global_node);
>  			} else if (err)
> -				pr_debug("dmaengine: failed to get %s: (%d)\n",
> -					 dma_chan_name(chan), err);
> +				pr_debug("%s: failed to get %s: (%d)\n",
> +					__func__, dma_chan_name(chan), err);
>  			else
>  				break;
>  			if (--device->privatecnt == 0)
> @@ -564,8 +564,8 @@ void dmaengine_get(void)
>  				list_del_rcu(&device->global_node);
>  				break;
>  			} else if (err)
> -				pr_err("dmaengine: failed to get %s: (%d)\n",
> -				       dma_chan_name(chan), err);
> +				pr_err("%s: failed to get %s: (%d)\n",
> +					__func__, dma_chan_name(chan), err);
>  		}
>  	}
>  
Applied, Thanks

-- 
~Vinod


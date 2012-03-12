Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2CLQZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:25:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:46122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2CLQZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:25:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="116936919"
Subject: Re: [PATCH v3 1/2] dmaengine: Add support for per xfer specific
 privatedata
From: Vinod Koul <vinod.koul@intel.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
In-Reply-To: <1331548336-27802-1-git-send-email-kumarrav@codeaurora.org>
References: <1331548336-27802-1-git-send-email-kumarrav@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Mar 2012 21:59:56 +0530
Message-ID: <1331569796.1727.9.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 16:02 +0530, Ravi Kumar V wrote:
> Add new argument to DMA SG and Interleave mode for passing
> per transfer specific private data, using this it enables the
> dma devices which needs to pass the parameters which changes per
> each transfer.
> 
> Signed-off-by: Ravi Kumar V <kumarrav@codeaurora.org>
> ---
>  include/linux/dmaengine.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 679b349..b8f0495 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -570,7 +570,7 @@ struct dma_device {
>  		struct dma_chan *chan,
>  		struct scatterlist *dst_sg, unsigned int dst_nents,
>  		struct scatterlist *src_sg, unsigned int src_nents,
> -		unsigned long flags);
> +		unsigned long flags, void *context);
Please follow the related discussion we had. Alexandre had already
posted updated and this needs to follow.
Also this way you break the existing drivers which use this API, not
sure why you posted without fixing them?

>  	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
>  		struct dma_chan *chan, struct scatterlist *sgl,
> @@ -581,7 +581,7 @@ struct dma_device {
>  		size_t period_len, enum dma_transfer_direction direction);
>  	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>  		struct dma_chan *chan, struct dma_interleaved_template *xt,
> -		unsigned long flags);
> +		unsigned long flags, void *context);
>  	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  		unsigned long arg);
>  


-- 
~Vinod


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab2JXDir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:38:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:54428 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXDiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:38:46 -0400
Subject: Re: [PATCH] dmaengine: imx-dma: fix missing unlock on error in
 imxdma_xfer_desc()
From: Vinod Koul <vkoul@infradead.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: vinod.koul@intel.com, djbw@fb.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd-RVCk=cqiOuTYdFzgTkEp25PrjqZ+Og4PdHG+1a8ayWA@mail.gmail.com>
References: <CAPgLHd-RVCk=cqiOuTYdFzgTkEp25PrjqZ+Og4PdHG+1a8ayWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 08:54:14 +0530
Message-ID: <1351049054.5263.12.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-21 at 19:58 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock on the error handling path in function
> imxdma_xfer_desc().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/dma/imx-dma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index f11b5b2..7d9554c 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -474,8 +474,10 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
>  			slot = i;
>  			break;
>  		}
> -		if (slot < 0)
> +		if (slot < 0) {
> +			spin_unlock_irqrestore(&imxdma->lock, flags);
>  			return -EBUSY;
> +		}
>  
>  		imxdma->slots_2d[slot].xsr = d->x;
>  		imxdma->slots_2d[slot].ysr = d->y;
> 
> 
> --
Thanks applied

-- 
Vinod Koul
Intel Corp.


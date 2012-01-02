Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2ABK6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 05:58:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:38595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab2ABK6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 05:58:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="91478758"
Subject: Re: [PATCH] dmaengine: Add support for MEMCPY for imx-dma.
From: Vinod Koul <vinod.koul@intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        s.hauer@pengutronix.de, linux-arm-kernel@lists.infradead.org
In-Reply-To: <CACKLOr0fVMknA+HAbgn3d9_f9tdz4L2Z9Bx4yMU7eLmr1mdXBA@mail.gmail.com>
References: <1324051191-19507-1-git-send-email-javier.martin@vista-silicon.com>
	 <1324661918.1633.35.camel@vkoul-udesk3>
	 <CACKLOr0fVMknA+HAbgn3d9_f9tdz4L2Z9Bx4yMU7eLmr1mdXBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 16:28:45 +0530
Message-ID: <1325501925.1540.9.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-02 at 11:08 +0100, javier Martin wrote:
> Hi Vinod,
> thank you for your review.
> 
> On 23 December 2011 18:38, Vinod Koul <vinod.koul@intel.com> wrote:
> >> @@ -328,6 +329,37 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
> >>       return &imxdmac->desc;
> >>  }
> >>
> >> +static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
> >> +     struct dma_chan *chan, dma_addr_t dest,
> >> +     dma_addr_t src, size_t len, unsigned long flags)
> >> +{
> >> +     struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
> >> +     struct imxdma_engine *imxdma = imxdmac->imxdma;
> >> +     int ret;
> >> +
> >> +     dev_dbg(imxdma->dev, "%s channel: %d src=0x%x dst=0x%x len=%d\n",
> >> +                     __func__, imxdmac->channel, src, dest, len);
> >> +
> >> +     if (imxdmac->status == DMA_IN_PROGRESS)
> >> +             return NULL;
> >> +
> >> +     imxdmac->status = DMA_IN_PROGRESS;
> > why? prepare doesn't mean DMA is in progress. You can get multiple
> > descriptors for same channel by calling prepare multiple times.
> > Even one descriptor can be memcpy whereas other is slave...
> > In issue_pending this should be moved to DMA_IN_PROGRESS
> 
> According to the original developer of this file it only supports a
> single descriptor. Please, take a look at the following function:
> 
> static void imxdma_issue_pending(struct dma_chan *chan)
> {
> 	/*
> 	 * Nothing to do. We only have a single descriptor
> 	 */
> }
> 
> 
> Also, the same behavior is present in the other prepare functions:
> "imxdma_prep_slave_sg" and "imxdma_prep_dma_cyclic".
> 
> I think the less painful approach here is merging my patch so that
> multiple descriptors support can be added later.
This behavior has nothing to do with single/multiple descriptors.
Prepare means to prepare the transfer and not to submit. There are other
APIs given to do the job. Please go thru the Documentation/dmaengine.txt
as well.

I know some drivers are broken in this respect, but would be great if
you can fix this behavior here as well.

-- 
~Vinod


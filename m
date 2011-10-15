Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1JORMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:12:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:39193 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668Ab1JORMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="63552282"
Subject: Re: [PATCH 01/10] dmaengine: add new enum dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com
In-Reply-To: <20111015124645.GG21802@flint.arm.linux.org.uk>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-2-git-send-email-vinod.koul@intel.com>
	 <20111015124645.GG21802@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 22:34:32 +0530
Message-ID: <1318698272.23438.19.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 13:46 +0100, Russell King wrote:
> On Fri, Oct 14, 2011 at 11:08:16AM +0530, Vinod Koul wrote:
> > This new enum removes usage of dma_data_direction for dma direction. The new
> > enum cleans tells the DMA direction and mode
> > This further paves way for merging the dmaengine _prep operations and also for
> > interleaved dma
> >  
> >  /**
> >   * enum dma_ctrl_flags - DMA flags to augment operation preparation,
> > @@ -267,7 +279,7 @@ enum dma_slave_buswidth {
> >   * struct, if applicable.
> >   */
> >  struct dma_slave_config {
> > -	enum dma_data_direction direction;
> > +	enum dma_transfer_direction direction;
> 
> I thought we were killing this off - surely now is a good time, rather
> than allowing it to persist with this ambiguous change of functionality.
Ah yes, I will probably do that next week, this is by product of global
replace done on this file :)
> 
> >  	dma_addr_t src_addr;
> >  	dma_addr_t dst_addr;
> >  	enum dma_slave_buswidth src_addr_width;
> > @@ -490,11 +502,11 @@ struct dma_device {
> >  
> >  	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
> >  		struct dma_chan *chan, struct scatterlist *sgl,
> > -		unsigned int sg_len, enum dma_data_direction direction,
> > +		unsigned int sg_len, enum dma_transfer_direction direction,
> 
> Does this make any sense?  The API takes a single scatterlist of memory
> locations - so MEM_TO_MEM and DEV_TO_DEV are meaningless for this API.
> 
> If it took two scatterlists and two device addresses, then maybe it would -
> but I don't see the point of this change (and all the users of this API
> also needing to change) when the API is specifically for memory scatterlist
> to/from a device.

dma_data_direction is meaningless to dmacs. We were overloading that to
convey slave direction, so we came up with better way to handle this.
The big plus point would be for the proposed interleaved dmaengine api,
this would convey what is mode (memcpy/slave) and direction in case of
slave cleanly.

-- 
~Vinod


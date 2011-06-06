Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1FFGDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 02:03:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:56745 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1FFGDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 02:03:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,325,1304319600"; 
   d="scan'208";a="7595580"
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
From: "Koul, Vinod" <vinod.koul@intel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: shawn.guo@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        patches@linaro.org
In-Reply-To: <20110605102855L.fujita.tomonori@lab.ntt.co.jp>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
	 <20110601023356.GA1501@S2100-06.ap.freescale.net>
	 <20110605102855L.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 10:58:38 +0530
Message-ID: <1307338118.10976.74.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 10:30 +0900, FUJITA Tomonori wrote:
> On Wed, 1 Jun 2011 10:33:57 +0800
> Shawn Guo <shawn.guo@freescale.com> wrote:
> 
> > On Thu, May 26, 2011 at 02:31:31PM +0800, Shawn Guo wrote:
> > > Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> > > max_segment_number into device_dma_parameters and creates the
> > > corresponding dmaengine API dma_set(get)_max_seg_number for it.
> > > 
> > > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > > ---
> > >  include/linux/device.h      |    1 +
> > >  include/linux/dma-mapping.h |   15 +++++++++++++++
> > >  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> include/linux/dma-mapping.h is for DMA mapping API (please see
> Documentation/DMA-API*.txt).
> 
> What does dma_set(get)_max_seg_size do? And it's related with DMA
> mapping API?
See the other post by author



> 
> 
> > > 
> > > diff --git a/include/linux/device.h b/include/linux/device.h
> > > index c66111a..44cb2528 100644
> > > --- a/include/linux/device.h
> > > +++ b/include/linux/device.h
> > > @@ -487,6 +487,7 @@ struct device_dma_parameters {
> > >  	 * sg limitations.
> > >  	 */
> > >  	unsigned int max_segment_size;
> > > +	unsigned int max_segment_number;
> > >  	unsigned long segment_boundary_mask;
> > >  };
> > >  
> > > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > > index ba8319a..fd314f4 100644
> > > --- a/include/linux/dma-mapping.h
> > > +++ b/include/linux/dma-mapping.h
> > > @@ -131,6 +131,21 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
> > >  		return -EIO;
> > >  }
> > >  
> > > +static inline unsigned int dma_get_max_seg_number(struct device *dev)
> > > +{
> > > +	return dev->dma_parms ? dev->dma_parms->max_segment_number : 1;
> > > +}
> > > +
> > > +static inline unsigned int dma_set_max_seg_number(struct device *dev,
> > > +						  unsigned int number)
> > > +{
> > > +	if (dev->dma_parms) {
> > > +		dev->dma_parms->max_segment_number = number;
> > > +		return 0;
> > > +	} else
> > > +		return -EIO;
> > > +}
> > > +
> > >  static inline unsigned long dma_get_seg_boundary(struct device *dev)
> > >  {
> > >  	return dev->dma_parms ?
> > > -- 
> > > 1.7.4.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1FEBau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 21:30:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:51155 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab1FEBas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 21:30:48 -0400
Date: Sun, 5 Jun 2011 10:30:20 +0900
To: shawn.guo@freescale.com
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        patches@linaro.org
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110601023356.GA1501@S2100-06.ap.freescale.net>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
	<20110601023356.GA1501@S2100-06.ap.freescale.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110605102855L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 05 Jun 2011 10:30:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 10:33:57 +0800
Shawn Guo <shawn.guo@freescale.com> wrote:

> On Thu, May 26, 2011 at 02:31:31PM +0800, Shawn Guo wrote:
> > Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> > max_segment_number into device_dma_parameters and creates the
> > corresponding dmaengine API dma_set(get)_max_seg_number for it.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >  include/linux/device.h      |    1 +
> >  include/linux/dma-mapping.h |   15 +++++++++++++++
> >  2 files changed, 16 insertions(+), 0 deletions(-)

include/linux/dma-mapping.h is for DMA mapping API (please see
Documentation/DMA-API*.txt).

What does dma_set(get)_max_seg_size do? And it's related with DMA
mapping API?


> > 
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index c66111a..44cb2528 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -487,6 +487,7 @@ struct device_dma_parameters {
> >  	 * sg limitations.
> >  	 */
> >  	unsigned int max_segment_size;
> > +	unsigned int max_segment_number;
> >  	unsigned long segment_boundary_mask;
> >  };
> >  
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index ba8319a..fd314f4 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -131,6 +131,21 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
> >  		return -EIO;
> >  }
> >  
> > +static inline unsigned int dma_get_max_seg_number(struct device *dev)
> > +{
> > +	return dev->dma_parms ? dev->dma_parms->max_segment_number : 1;
> > +}
> > +
> > +static inline unsigned int dma_set_max_seg_number(struct device *dev,
> > +						  unsigned int number)
> > +{
> > +	if (dev->dma_parms) {
> > +		dev->dma_parms->max_segment_number = number;
> > +		return 0;
> > +	} else
> > +		return -EIO;
> > +}
> > +
> >  static inline unsigned long dma_get_seg_boundary(struct device *dev)
> >  {
> >  	return dev->dma_parms ?
> > -- 
> > 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

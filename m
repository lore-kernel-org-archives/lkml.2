Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab2INRRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:17:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51753 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab2INRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:17:33 -0400
Date: Fri, 14 Sep 2012 13:06:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 08/10] xen/swiotlb: Remove functions not needed anymore.
Message-ID: <20120914170644.GC1481@phenom.dumpdata.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
 <1347306367-28669-9-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1209141704330.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209141704330.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 05:06:16PM +0100, Stefano Stabellini wrote:
> On Mon, 10 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > Sparse warns us off:
> > drivers/xen/swiotlb-xen.c:506:1: warning: symbol 'xen_swiotlb_map_sg' was not declared. Should it be static?
> > drivers/xen/swiotlb-xen.c:534:1: warning: symbol 'xen_swiotlb_unmap_sg' was not declared. Should it be static?
> > 
> > and it looks like we do not need this function at all.
> 
> A grep seems to find them used in arch/x86/xen/pci-swiotlb-xen.c.
> I fail to see where you removed them from pci-swiotlb-xen.c. Is it in
> this patch series or another one?

I am not seeing them in that file. I think you found the
other variant of it:

xen_swiotlb_map_sg_attrs

> 
> 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |   16 ----------------
> >  include/xen/swiotlb-xen.h |    9 ---------
> >  2 files changed, 0 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index f0825cb..6f81994 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -514,14 +514,6 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  }
> >  EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg_attrs);
> >  
> > -int
> > -xen_swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
> > -		   enum dma_data_direction dir)
> > -{
> > -	return xen_swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
> > -}
> > -EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg);
> > -
> >  /*
> >   * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
> >   * concerning calls here are the same as for swiotlb_unmap_page() above.
> > @@ -542,14 +534,6 @@ xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  }
> >  EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg_attrs);
> >  
> > -void
> > -xen_swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
> > -		     enum dma_data_direction dir)
> > -{
> > -	return xen_swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
> > -}
> > -EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg);
> > -
> >  /*
> >   * Make physical memory consistent for a set of streaming mode DMA translations
> >   * after a transfer.
> > diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
> > index f26f9f3..a0db2b7 100644
> > --- a/include/xen/swiotlb-xen.h
> > +++ b/include/xen/swiotlb-xen.h
> > @@ -23,15 +23,6 @@ extern dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> >  extern void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
> >  				   size_t size, enum dma_data_direction dir,
> >  				   struct dma_attrs *attrs);
> > -/*
> > -extern int
> > -xen_swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
> > -		   enum dma_data_direction dir);
> > -
> > -extern void
> > -xen_swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
> > -		     enum dma_data_direction dir);
> > -*/
> >  extern int
> >  xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  			 int nelems, enum dma_data_direction dir,
> > -- 
> > 1.7.7.6
> > 

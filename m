Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab1D0KwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:52:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58511 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab1D0KwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:52:04 -0400
Date: Wed, 27 Apr 2011 12:51:52 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
In-reply-to: <201104271056.49920.arnd@arndb.de>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-id: <001001cc04c9$1e5caf30$5b160d90$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcwEuR0QHM5W4t/SS9+Jk/nFc+5F7AADv5aQ
References: <201104212129.17013.arnd@arndb.de>
 <20110427073514.GH17290@n2100.arm.linux.org.uk>
 <201104271056.49920.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, April 27, 2011 10:57 AM Arnd Bergmann wrote:

> On Wednesday 27 April 2011, Russell King - ARM Linux wrote:
> > > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> > >    that this is needed, and it currently is not implemented, with
> > >    an outdated comment explaining why it used to not be possible
> > >    to do it.
> >
> > dma_alloc_noncoherent is an entirely pointless API afaics.
> 
> The main use case that I can see for dma_alloc_noncoherent is being
> able to allocate a large cacheable memory chunk that is mapped
> contiguous into both kernel virtual and bus virtual space, but not
> necessarily in contiguous in physical memory.
> 
> Without an IOMMU, I agree that it is pointless, because the only
> sensible imlpementation would be alloc_pages_exact + dma_map_single.

Still it might be reasonable to use it in the drivers that will work
on different platforms - one with iommu and one without.
 
> > > 3. Convert ARM to use asm-generic/dma-mapping-common.h. We need
> > >    both IOMMU and direct mapped DMA on some machines.
> > >
> > > 4. Implement an architecture independent version of dma_map_ops
> > >    based on the iommu.h API. As Joerg mentioned, this has been
> > >    missing for some time, and it would be better to do it once
> > >    than for each IOMMU separately. This is probably a lot of work.
> >
> > dma_map_ops design is broken - we can't have the entire DMA API
> indirected
> > through that structure.  Whether you have an IOMMU or not is completely
> > independent of whether you have to do DMA cache handling.  Moreover, with
> > dmabounce, having the DMA cache handling in place doesn't make sense.
> >
> > So you can't have a dma_map_ops for the cache handling bits, a
> dma_map_ops
> > for IOMMU, and a dma_map_ops for the dmabounce stuff.  It just doesn't
> > work like that.
> >
> > I believe the dma_map_ops stuff in asm-generic to be entirely unsuitable
> > for ARM.
> 
> We probably still need to handle both the coherent and noncoherent case
> in each dma_map_ops implementation, at least for those combinations where
> they matter (definitely the linear mapping). However, I think that using
> dma_mapping_common.h would let us use an architecture-independent
> dma_map_ops
> for the generic iommu code that Marek wants to introduce now.
> 
> I still don't understand how dmabounce works, but if it's similar to
> swiotlb, we can have at least three different dma_map_ops: linear,
> dmabounce and iommu.

That's exactly what I want to make in the initial version of my patches.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


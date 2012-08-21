Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab2HUNAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:00:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47490 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112Ab2HUNAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:00:22 -0400
Date: Tue, 21 Aug 2012 13:59:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 14/31] arm64: DMA mapping API
Message-ID: <20120821125948.GC12708@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-15-git-send-email-catalin.marinas@arm.com>
 <201208151616.01114.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151616.01114.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 05:16:00PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > +static struct dma_map_ops arm64_swiotlb_dma_ops = {
> > +       .alloc = arm64_swiotlb_alloc_coherent,
> > +       .free = arm64_swiotlb_free_coherent,
> > +       .map_page = arm64_swiotlb_map_page,
> > +       .unmap_page = arm64_swiotlb_unmap_page,
> > +       .map_sg = arm64_swiotlb_map_sg_attrs,
> > +       .unmap_sg = arm64_swiotlb_unmap_sg_attrs,
> > +       .sync_single_for_cpu = arm64_swiotlb_sync_single_for_cpu,
> > +       .sync_single_for_device = arm64_swiotlb_sync_single_for_device,
> > +       .sync_sg_for_cpu = arm64_swiotlb_sync_sg_for_cpu,
> > +       .sync_sg_for_device = arm64_swiotlb_sync_sg_for_device,
> > +       .dma_supported = swiotlb_dma_supported,
> > +       .mapping_error = swiotlb_dma_mapping_error,
> > +};
> > +
> > +void __init swiotlb_init_with_default_size(size_t default_size, int verbose);
> > +
> > +void __init arm64_swiotlb_init(size_t max_size)
> > +{
> > +       dma_ops = &arm64_swiotlb_dma_ops;
> > +       swiotlb_init_with_default_size(min((size_t)SZ_64M, max_size), 1);
> > +}
> 
> Why is swiotlb the default? I would expect that most devices can in fact
> use the entire 64 bit address space, so you can use a simple linear
> implementation for those.

That was my worry, devices not capable of accessing the full 64-bit
address space. We can hope that those SoCs would have an IOMMU but I
can't tell for sure at this stage.

The default implementation could be simpler. I can even drop it
altogether from the initial patchset given that no SoC makes use of it
yet.

-- 
Catalin

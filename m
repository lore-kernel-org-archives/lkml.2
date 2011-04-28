Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1D1MZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:25:12 -0400
Received: from 8bytes.org ([88.198.83.132]:43929 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab1D1MZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:25:10 -0400
Date: Thu, 28 Apr 2011 14:25:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428122508.GC13402@8bytes.org>
References: <201104212129.17013.arnd@arndb.de> <20110427073514.GH17290@n2100.arm.linux.org.uk> <20110428104143.GB13402@8bytes.org> <20110428110129.GE17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428110129.GE17290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:01:29PM +0100, Russell King - ARM Linux wrote:

> dma_addr_t dma_map_page(struct device *dev, struct page *page, size_t offset,
>                         size_t size, enum dma_data_direction dir)
> {
> 	struct dma_map_ops *ops = get_dma_ops(dev);
> 	dma_addr_t addr;
> 
> 	BUG_ON(!valid_dma_direction(dir));
> 	if (ops->flags & DMA_MANAGE_CACHE || !dev->dma_cache_coherent)
> 		__dma_page_cpu_to_dev(page, offset, size, dir);
> 	addr = ops->map_page(dev, page, offset, size, dir, NULL);
> 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
> 
> 	return addr;
> }
> 
> Things like swiotlb and dmabounce would not set DMA_MANAGE_CACHE in
> ops->flags, but real iommus and the standard no-iommu implementations
> would be required to set it to ensure that data is visible in memory
> for CPUs which have DMA incoherent caches.

Do we need flags for that? A flag is necessary if the cache-management
differs between IOMMU implementations on the same platform. If
cache-management is only specific to the platform (or architecture) then
it does make more sense to just call the function without flag checking
and every platform with coherent DMA just implements these as static
inline noops.

Regards,

	Joerg


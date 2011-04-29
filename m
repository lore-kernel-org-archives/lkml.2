Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1D2A0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:26:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:42529 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1D2A0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:26:50 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110428131531.GK17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de>
	 <003e01cc058f$94beb490$be3c1db0$%szyprowski@samsung.com>
	 <20110428105131.GD17290@n2100.arm.linux.org.uk>
	 <201104281428.56780.arnd@arndb.de>
	 <20110428131531.GK17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 10:25:54 +1000
Message-ID: <1304036754.2513.201.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> However, dma_alloc_coherent() memory can't be used with the dma_sync_*
> API as its return address (unlike other architectures) is not in the
> kernel direct mapped memory range.

Well, on non-coherent architectures, dma_sync_* are cache flushes, I
don't see the point of doing those on a non-cachable mapping anyways.

> The only thing valid for dma_sync_* are buffers which have been passed
> to the dma_map_* APIs.

Right, at least that's our expectation on powerpc as well.

> Instead, I think what you're referring to is dma_cache_sync(), which is
> the API to be used with dma_alloc_noncoherent(), which we don't
> implement.

Too may confusing APIs....

Ben.

> As we have problems with some SMP implementations, and the noncoherent
> API doesn't have the idea of buffer ownership, it's rather hard to deal
> with the DMA cache implications with the existing API, especially with
> the issues of speculative prefetching.  The current usage (looking at
> drivers/scsi/53c700.c) doesn't cater for speculative prefetch as the
> dma_cache_sync(,,,DMA_FROM_DEVICE) is done well in advance of the DMA
> actually happening.
> 
> So all in all, I think the noncoherent API is broken as currently
> designed - and until we have devices on ARM which use it, I don't see
> much point into trying to fix the current thing especially as we'd be
> unable to test.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



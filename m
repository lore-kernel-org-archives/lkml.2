Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1D1M3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:29:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab1D1M3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:29:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Thu, 28 Apr 2011 14:28:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <003e01cc058f$94beb490$be3c1db0$%szyprowski@samsung.com> <20110428105131.GD17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110428105131.GD17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281428.56780.arnd@arndb.de>
X-Provags-ID: V02:K0:vTBAgDVOy2jRI0CEk4Tl2OtuCII8peZsKmN375wX3i8
 AoMSdlqH4JtZtEB/N4akj3X0j189bB5gyX7vkJcJPZpOei6zKV
 Fe/KF0JeP4B9045LzopSVU7Zwdq3S0kSBbr0t15+iw2OljvRWR
 PqWHodf/kRoJIRHtSpwaLfIuZIPpKCdnSGTFRDl0iMnFhphtjn
 BIixWk76FFayWBaDz3b1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Russell King - ARM Linux wrote:
> What I'd suggest is that dma_alloc_noncoherent() should be architecture
> independent, and should call into whatever iommu support the device has
> to setup an approprite iommu mapping.  IOW, I don't see any need for
> every architecture to provide its own dma_alloc_noncoherent() allocation
> function - or indeed every iommu implementation to deal with the
> allocation issues either.

Almost all architectures today define dma_alloc_noncoherent to
dma_alloc_coherent, which is totally fine on architectures
where cacheable coherent mappings are the default or where
we don't need to flush individual cache lines for dma_sync_*.

The problem with backing either of the two with alloc_pages or
alloc_pages_exact is that you cannot do large allocation when
physical memory is fragmented, even if you have an IOMMU.

IMHO the allocation for both dma_alloc_coherent and
dma_alloc_noncoherent should therefore depend on whether you
have an IOMMU. If you do, you can easily allocate megabytes,
e.g. for use as a frame buffer.

	Arnd

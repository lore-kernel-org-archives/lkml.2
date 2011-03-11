Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1CKMfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:35:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30572 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1CKMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:35:43 -0500
Date: Fri, 11 Mar 2011 13:35:21 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU)
 driver
In-reply-to: <201103111250.51252.arnd@arndb.de>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        kgene.kim@samsung.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        =?ks_c_5601-1987?B?J7TrwM6x4ic=?= <inki.dae@samsung.com>,
        =?ks_c_5601-1987?B?J7Ctuc6x1Cc=?= <mk7.kang@samsung.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <000001cbdfe8$ce444b20$6acce160$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acvf4pjWSXaXmr4mTKOEFnE5J4TkVwAAtMKQ
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com>
 <201103101552.15536.arnd@arndb.de>
 <002101cbdfcb$5c657820$15306860$%szyprowski@samsung.com>
 <201103111250.51252.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, March 11, 2011 12:51 PM Arnd Bergmann wrote:

> On Friday 11 March 2011, Marek Szyprowski wrote:
> >
> > We followed the style of iommu API for other mainline ARM platforms (both OMAP and MSM
> > also have custom API for their iommu modules). I've briefly checked include/linux/iommu.h
> > API and I've noticed that it has been designed mainly for KVM support. There is also
> > include/linux/intel-iommu.h interface, but I it is very specific to intel gfx chips.
> 
> The MSM code actually uses the generic iommu.h code, using register_iommu, so
> the drivers can use the regular iommu_map.
> 
> I believe the omap code predates the iommu API, and should really be changed
> to use that. At least it was added before I started reviewing the code.
> 
> The iommu API is not really meant to be KVM specific, it's just that the
> in-tree users are basically limited to KVM at the moment. Another user that
> is coming up soon is the vmio device driver that can be used to transparently
> pass devices to user space. The idea behind the IOMMU API is that you can
> map arbitrary bus addresses to physical memory addresses, but it does not
> deal with allocating the bus addresses or providing buffer management such
> as cache flushes.

Yea, I've noticed this and this basically what we expect from iommu driver. 
However the iommu.h API requires a separate call to map each single memory page.
This is quite ineffective approach and imho the API need to be extended to allow
mapping of the arbitrary set of pages.

> > Is there any example how include/linux/dma-mapping.h interface can be used for iommu
> > mappings?
> 
> The dma-mapping API is the normal interface that you should use for IOMMUs
> that sit between DMA devices and kernel memory. The idea is that you
> completely abstract the concept of an IOMMU so the device driver uses
> the same code for talking to a device with an IOMMU and another device with
> a linear mapping or an swiotlb bounce buffer.
> 
> This means that the user of the dma-mapping API does not get to choose the
> bus addresses, but instead you use the API to get a bus address for a
> chunk of memory, and then you can pass that address to a device.
> 
> See arch/powerpc/kernel/iommu.c and arch/x86/kernel/amd_iommu.c for common
> examples of how this is implemented. The latter one actually implements
> both the iommu_ops for iommu.h and dma_map_ops for dma-mapping.h.

Thanks for your comments! We will check how is it suitable for our case.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



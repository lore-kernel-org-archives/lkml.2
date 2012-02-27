Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2B0Pu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:50:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64290 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab2B0Puz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 10:50:55 -0500
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Date: Mon, 27 Feb 2012 16:51:53 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
In-reply-to: <CAHQjnOPE5X=dn+8D348OruLqoYNGZwZk3eLtLRSERce-eTzXDg@mail.gmail.com>
To: "'KyongHo Cho'" <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>
Message-id: <000701ccf567$b9dee150$2d9ca3f0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: AczzDpRL15wtyM9TT6yxV5XgLtEbdQCG0aBg
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
 <014601ccf2fa$a25c8560$e7159020$%szyprowski@samsung.com>
 <CAHQjnOPE5X=dn+8D348OruLqoYNGZwZk3eLtLRSERce-eTzXDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, February 24, 2012 5:09 PM KyongHo Cho wrote:

> On Fri, Feb 24, 2012 at 10:45 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > Hi,
> >
> > On Thursday, December 29, 2011 1:24 PM KyongHo Cho wrote:
> >
> >> Changes since v7:
> >> - Rebased with the recent commits of the following git branches
> >>   * git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
> >>   * git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
> >> - Changed magic numbers into macros
> >> - Setting owner of a System MMU in 'iommu' field of dev_archdata
> >> - Verbose message in the default fault handler
> >> - Some bug fixes.
> >
> > (snipped)
> >
> > The time is flying away and v3.4 merge windows will open soon. Do you plan to
> > send an updated version of the SYSMMU driver anytime soon? It will be really
> > nice to have it finally merged to v3.4.
> >
> 
> Thank you for asking.
> 
> I prepared a new patchset and it is ready for submitting.
> It includes several bugfixes and Exynos5 support.
> 
> The last patche submitted has a bug when the following situation:
>    1. Allocating a 2nd level page table to map 4KB or 64KB on a virtual region
>    2. Unmapped all entries in the 2nd level page table.
>    3. Mapping to the same region with 1MB page.
>    Then iommu_map() will return -EADDRINUSE due to incorrect counting
>    free entries in 2nd level page table.
> 
> The next patch will be submitted by 2/28.

Ok, I will check it soon then.

> BTW Marek, I want to know why MFC driver defines separate platform devices
> for left and right buses.

This is required for S5PV210 which has no iommu and requires contiguous memory 
from 2 separate physical memory banks. It use dma_declare_coherent to define
memory for each bus separately. One platform device can have only one coherent
memory range defined, that's why there are two devices created.

> The next IOMMU driver defines just one platform device for a H/W device.
> Thus, it defines just one SYSMMU_MFC platform device, for example.
> (the previous one defines 2 platform devices for SYSMMU_MFC)

Exynos4210 has 2 iommu controllers for MFC device - one for each memory bus. 
Each MFC bus can address 128MiB of IO address space. Do you mean that the new driver
will merge these 2 controllers into one? This way we will lose half of address space
for MFC device.

> However, it is easy to separate the single platform device to multiple
> platform devices.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



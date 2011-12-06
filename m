Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab1LFMrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:47:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab1LFMrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:47:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAHQjnOOCHO3eDiUft4WgS=8N5EheWas+n3MD9xxBKUoSjmNQSQ@mail.gmail.com>
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
	<20111205154715.GE25178@amd.com>
	<CAH9JG2VALcm-PreS7S2SZPPgEbid_6_VWJA0PHBEtY5KvaA3Og@mail.gmail.com>
	<CAHQjnOOCHO3eDiUft4WgS=8N5EheWas+n3MD9xxBKUoSjmNQSQ@mail.gmail.com>
Date: Tue, 6 Dec 2011 21:47:21 +0900
X-Google-Sender-Auth: 4iibyBTtGIz5ZdYC5tWkPQS2REc
Message-ID: <CAH9JG2UyC651ddwiDLLUCyzgyLJx-_AVwd9+ea8dQuK1j_nJ=w@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] iommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
From: Kyungmin Park <kmpark@infradead.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, Kukjin Kim <kgene.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 9:13 PM, KyongHo Cho <pullip.cho@samsung.com> wrote:
> On Tue, Dec 6, 2011 at 8:24 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>> On 12/6/11, Joerg Roedel <joerg.roedel@amd.com> wrote:
>>> On Fri, Nov 18, 2011 at 06:47:28PM +0900, KyongHo Cho wrote:
>>>> Patch Summary:
>>>> [PATCH v7 1/2] ARM: EXYNOS: Change System MMU platform device definitions
>>>> [PATCH v7 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
>>>
>>> Okay, I merged it into arm/exynos, but it is not pushed yet. Actually
>>> there were conflicts while merging, which I resolved. What I failed
>>> to find is a config for Exynos that actually builds for upstream Linux.
>>> Probably I havn't tried hard enough to find one... Can you provide a
>>> kernel config that I can use for my testing and that builds a current
>>> 3.2-rc4 kernel for Exynos?
>> and I hope to see the real example how to use it with exynos platform.
>>
>> Now I can't find the interface between exynos platform and generic exynos iommu.
> In "[PATCH v7 1/2] ARM: EXYNOS: Change System MMU platform device
> definitions" patch,
> you can find sysmmu_init().
> It stores associations between a system MMU and a peripheral device in
> platform data of platform device descriptor.
> If Exynos IOMMU driver finds the association while probing, then the
> driver can control the system MMU.
Maybe it's still call the function directly instead of using struct
dev field as OMAP did.
Even though generic DMA mapping IOMMU doesn't used, you can connect
the iommu field at arch/arm/include/asm/device.h

BR,
Kyungmin Park
>
>> BTW, how do you test it at mainline kernel?
>>
> I merged IOMMU mainline branch to our kernel branch and tested it with
> our FIMC, MFC, JPEG, 2D.

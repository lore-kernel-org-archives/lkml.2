Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1GELOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:14:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8483 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1GELOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:14:45 -0400
Date: Tue, 05 Jul 2011 13:14:14 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 0/6+1] ARM: EXYNOS4: SYSMMU: Improvements on SYSMMU driver
In-reply-to: <CAHQjnOPMCMh3fO7RXP7pbD8_nuDEG9ksLhtCcAy=2Z2bTarT9A@mail.gmail.com>
To: "'KyongHo Cho'" <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Ilho Lee'" <ilho215.lee@samsung.com>,
        "'Kwanghyun La'" <nala.la@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <000201cc3b04$aca7fc60$05f7f520$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acw6o3cmKyHUc8A4SYqa56/pbMyOKAAX8i2g
References: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
 <000001cc3a16$4cec0710$e6c41530$%szyprowski@samsung.com>
 <CAHQjnOPMCMh3fO7RXP7pbD8_nuDEG9ksLhtCcAy=2Z2bTarT9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, July 05, 2011 1:38 AM KyongHo Cho wrote:

> On Mon, Jul 4, 2011 at 3:47 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > Hello,
> >
> > I really don't get why do You persist in creating one monster platform
> > device with resources for ALL SYSMMU/IOMMU controllers that are available
> > on Exynos4 CPU. We (SPRC, see Andrzej's SYSMMU patches) already proposed
> > a clean solution for making the SYSMMU controllers independent of each
> > other as well as making the main SYSMMU driver simpler and more
> > independent of the particular Exynos4 platform definition. In Linux
> > device model if the device/controller exist in the system in more than
> > one instance, there should by one generic driver for it and a set of
> > platform definitions for each instance.
> >
> Did you find this patch? "[PATCH 3/6] ARM: EXYNOS4: SYSMMU"
> I Cced you because it includes your suggestion.

Right, I'm really sorry. It looks that I'm too busy and misunderstood your
patches in a brief look.

> > Here is the link to our SYSMMU updated driver (implementing common
> > iommu API):
> > http://www.spinics.net/lists/linux-samsung-soc/msg04508.html
> > The driver still needs some cleanup, but this has been delayed until
> > the dma-mapping framework update is finished.
> >
> > I also don't get why do you want to keep the completely custom sysmmu
> > driver and implement iommu API on top of it. Is it really required for
> > anything? Mainline kernel is not a place for custom APIs if there is
> > already a common, generic one.
> 
> I did not exposed any custom API.
> The global function in the last patch is just for IOMMU API implemenation.
> The header file in the last patch is not for the device drivers but
> for the IOMMU API implementation.
> Actually, they can be merged into one single file.
> But I just wanted to change the kernel code stepwise.

What about arch/arm/plat-s5p/sysmmu.c ? I didn't notice any commit which 
removes this file. Also both drivers/iommu/exynos4_sysmmu.c and 
drivers/iommu/exynos_iommu.c should be merged together.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center




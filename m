Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1GEXvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 19:51:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57231 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1GEXvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 19:51:36 -0400
MIME-Version: 1.0
In-Reply-To: <000201cc3b04$aca7fc60$05f7f520$%szyprowski@samsung.com>
References: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
	<000001cc3a16$4cec0710$e6c41530$%szyprowski@samsung.com>
	<CAHQjnOPMCMh3fO7RXP7pbD8_nuDEG9ksLhtCcAy=2Z2bTarT9A@mail.gmail.com>
	<000201cc3b04$aca7fc60$05f7f520$%szyprowski@samsung.com>
Date: Wed, 6 Jul 2011 08:51:35 +0900
X-Google-Sender-Auth: uPHIu8yi7NCYdI0O_ke5M0j_WV4
Message-ID: <CAHQjnOMRMyRB3hgREu+-spx3mk_eWG4ar4VD54x5j+PibebJPw@mail.gmail.com>
Subject: Re: [PATCH 0/6+1] ARM: EXYNOS4: SYSMMU: Improvements on SYSMMU driver
From: KyongHo Cho <pullip.cho@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Ilho Lee <ilho215.lee@samsung.com>, Kwanghyun La <nala.la@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 8:14 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Tuesday, July 05, 2011 1:38 AM KyongHo Cho wrote:
>
>> On Mon, Jul 4, 2011 at 3:47 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:
>> > Hello,
>> >
>> > I really don't get why do You persist in creating one monster platform
>> > device with resources for ALL SYSMMU/IOMMU controllers that are available
>> > on Exynos4 CPU. We (SPRC, see Andrzej's SYSMMU patches) already proposed
>> > a clean solution for making the SYSMMU controllers independent of each
>> > other as well as making the main SYSMMU driver simpler and more
>> > independent of the particular Exynos4 platform definition. In Linux
>> > device model if the device/controller exist in the system in more than
>> > one instance, there should by one generic driver for it and a set of
>> > platform definitions for each instance.
>> >
>> Did you find this patch? "[PATCH 3/6] ARM: EXYNOS4: SYSMMU"
>> I Cced you because it includes your suggestion.
>
> Right, I'm really sorry. It looks that I'm too busy and misunderstood your
> patches in a brief look.

No problem with that :)

>> > Here is the link to our SYSMMU updated driver (implementing common
>> > iommu API):
>> > http://www.spinics.net/lists/linux-samsung-soc/msg04508.html
>> > The driver still needs some cleanup, but this has been delayed until
>> > the dma-mapping framework update is finished.
>> >
>> > I also don't get why do you want to keep the completely custom sysmmu
>> > driver and implement iommu API on top of it. Is it really required for
>> > anything? Mainline kernel is not a place for custom APIs if there is
>> > already a common, generic one.
>>
>> I did not exposed any custom API.
>> The global function in the last patch is just for IOMMU API implemenation.
>> The header file in the last patch is not for the device drivers but
>> for the IOMMU API implementation.
>> Actually, they can be merged into one single file.
>> But I just wanted to change the kernel code stepwise.
>
> What about arch/arm/plat-s5p/sysmmu.c ? I didn't notice any commit which
> removes this file. Also both drivers/iommu/exynos4_sysmmu.c and
> drivers/iommu/exynos_iommu.c should be merged together.

It will be removed.
And.. omitting removal of that file is my mistake :(
Since clkdev for Exynos4 is not applied to of Joerg Roedel's iommu git
and drivers/iommu is not created in Samsung SOC git,
it is not simple to apply patch for both.

Thanks for pointing out it and I'll send a patch to remove those files
immediately.

On the other hands, merging those files will be also considered.

Regards,
KyongHo Cho.

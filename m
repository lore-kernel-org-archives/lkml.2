Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957Ab2CPJau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:30:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42422 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760730Ab2CPJar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:30:47 -0400
Message-ID: <4F630841.2070307@linaro.org>
Date: Fri, 16 Mar 2012 15:00:41 +0530
From: Subash Patel <subash.ramaswamy@linaro.org>
Organization: Samsung
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Cho KyongHo <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>
Subject: Re: [PATCH v12 2/3] ARM: EXYNOS: Change System MMU platform device
 definitions
References: <000201cd0286$2e6fbb40$8b4f31c0$%cho@samsung.com> <20120315111227.GA2384@amd.com> <4F61FF1D.5000502@samsung.com>
In-Reply-To: <4F61FF1D.5000502@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo, Kukjin,

On 03/15/2012 08:09 PM, Kukjin Kim wrote:
> On 03/15/12 04:12, Joerg Roedel wrote:
>> On Thu, Mar 15, 2012 at 05:32:39PM +0900, Cho KyongHo wrote:
>
> KyongHo, I looked at 'Cho KyongHo <pullip.cho ...>' and 'KyongHo Cho 
> <pullip.cho ...>' in this series, which one do you want to use?
>
>>> Handling System MMUs with an identifier is not flexible to manage
>>> System MMU platform devices because of the following reasons:
>>> 1. A device driver which needs to handle System MMU must know the ID.
>>> 2. A System MMU may not present in some implementations of Exynos 
>>> family.
>>> 3. Handling System MMU with IOMMU API does not require an ID.
>>>
>>> This patch is the result of removing ID of System MMUs.
>>> Instead, a device driver that needs to handle its System MMU must
>>> use IOMMU API while its descriptor of platform device is given.
>>>
>>> This patch also includes the following enhancements:
>>> - A System MMU device becomes a child if its power domain device.
>>> - clkdev
>>>
>>> Cc: Kukjin Kim<kgene.kim@samsung.com>
>>> Signed-off-by: KyongHo Cho<pullip.cho@samsung.com>
>>> ---
>>>   arch/arm/mach-exynos/Kconfig                    |   10 +-
>>>   arch/arm/mach-exynos/Makefile                   |    2 +-
>>>   arch/arm/mach-exynos/clock-exynos4.c            |   79 ++--
>>>   arch/arm/mach-exynos/clock-exynos4.h            |    2 +
>>>   arch/arm/mach-exynos/clock-exynos4210.c         |   11 +
>>>   arch/arm/mach-exynos/clock-exynos4212.c         |   28 ++-
>>>   arch/arm/mach-exynos/clock-exynos5.c            |   90 +++++
>>>   arch/arm/mach-exynos/dev-sysmmu.c               |  457 
>>> ++++++++++++----------
>>>   arch/arm/mach-exynos/include/mach/irqs.h        |   25 +-
>>>   arch/arm/mach-exynos/include/mach/map.h         |   38 ++
>>>   arch/arm/mach-exynos/include/mach/regs-clock.h  |    5 +
>>>   arch/arm/mach-exynos/include/mach/regs-sysmmu.h |   28 --
>>>   arch/arm/mach-exynos/include/mach/sysmmu.h      |   88 +++--
>>>   arch/arm/mach-exynos/mach-armlex4210.c          |    1 -
>>>   arch/arm/mach-exynos/mach-smdkv310.c            |    1 -
>>>   15 files changed, 529 insertions(+), 336 deletions(-)
>>>   delete mode 100644 arch/arm/mach-exynos/include/mach/regs-sysmmu.h
>>
>> This patch doesn't apply cleanly against upstream Linux (v3.3-rcX).
>> Please rebase to upstream and resend. The other 2 patches apply fine.
>>
>
> Yes, as KyoungHo said, this has been created on top of Samsung tree 
> for-next because this touches many exynos stuff which has been changed 
> from Samsung tree for upcoming merge window. So if you're ok on this, 
> 1st patch and this should be sent to upstream via samsung tree even 
> though I can't find any topic branch for this yet. And if you want 
> topic branch for your tree, let me know, I can provide it.
>
> Thanks.
Wouldn't it be good to send exynos4 SYSMMU patches now, and send only 
the exynos5 delta when your for-next(exynos5) changes
get merged to mainline? Manually editing the patches is really pain-some 
and sometimes error-some :( Can this patch in particular
be split?
>
> Best regards,
> Kgene.
> -- 
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
Regards,
Subash

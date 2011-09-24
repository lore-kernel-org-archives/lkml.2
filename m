Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab1IXHiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 03:38:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1IXHiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 03:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <19883641.49771316849198516.JavaMail.weblogic@epml24>
References: <19883641.49771316849198516.JavaMail.weblogic@epml24>
Date: Sat, 24 Sep 2011 16:38:14 +0900
X-Google-Sender-Auth: 434dDsqAccFfGf0WytbYHyjy6Rw
Message-ID: <CAHQjnON8Wo1mN6GPQN1Ke6VsC+E2TLwWCY8U+Bk5ca0BWdeoMQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] iommu/exynos: Add IOMMU and Enhance System MMU driver
 for Exynos4
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: pullip.cho@samsung.com, joerg.roedel@amd.com, sanghyun75.lee@samsung.com,
        kgene.kim@samsung.com, younglak1004.kim@samsung.com, ohad@wizery.com
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for duplicate emails :(

My mistake.

2011/9/24 ¡∂∞Ê»£ <pullip.cho@samsung.com>:
> Hi.
>
> First 2 patches enhance System MMU platform device definition:
>  - Removed System MMU for MDMA0 in LCD block because it is not used.
>   Use MDMA2 in TOP block.
>  - Removed System MMU ID. Instead a System MMU is bound to a device that
>   the System MMU is dedicated during machin initialization. If a device
>   driver wants to handle System MMU, it must bind its device with System
>   MMU with sysmmu_set_owner().
>  - clkdev
>  - System MMU device driver is removed from arch/arm/plat-s5p to move it
>   to driver/iommu directory.
> Last 2 patches implements IOMMU API:
>  - Implements IOMMU API and System MMU driver that is moved from
>   arch/arm/plat-s5p.
>  - Implements fault handling that is suggested by Ohad.
>  - Used bus_set_iommu instead of register_iommu that is suggested by Joerg.
>
> Regards,
> Cho KyongHo.
>
> Diffstats:
> arch/arm/mach-exynos4/Kconfig               |    2 -
> arch/arm/mach-exynos4/clock.c               |   43 +-
> arch/arm/mach-exynos4/dev-sysmmu.c          |  281 +++-------
> arch/arm/mach-exynos4/include/mach/irqs.h   |    1 -
> arch/arm/mach-exynos4/include/mach/map.h    |    1 -
> arch/arm/mach-exynos4/include/mach/sysmmu.h |   96 ++--
> arch/arm/mach-exynos4/mach-armlex4210.c     |   24 +-
> arch/arm/mach-exynos4/mach-smdkv310.c       |   28 +-
> arch/arm/plat-s5p/Kconfig                   |    8 -
> arch/arm/plat-s5p/Makefile                  |    1 -
> arch/arm/plat-s5p/include/plat/sysmmu.h     |   95 ---
> arch/arm/plat-s5p/sysmmu.c                  |  312 ----------
> drivers/iommu/Kconfig                       |   14 +
> drivers/iommu/Makefile                      |    1 +
> drivers/iommu/exynos_iommu.c                |  859 +++++++++++++++++++++++++++
> 15 files changed, 1084 insertions(+), 682 deletions(-)

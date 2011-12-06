Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab1LFLvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:51:10 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24727 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360Ab1LFLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:51:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 06 Dec 2011 12:51:02 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v7 1/2] ARM: EXYNOS: Change System MMU platform device
 definitions
In-reply-to: <1321609650-1329-2-git-send-email-pullip.cho@samsung.com>
To: "'KyongHo Cho'" <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Message-id: <007f01ccb40d$540a2fb0$fc1e8f10$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: Acyl2kGpS/wOQbT3SyiQWiPS4WIf/gOMrGOA
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
 <1321609650-1329-2-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, November 18, 2011 10:47 AM KyongHo Cho wrote:

> Handling System MMUs with an identifier is not flexible to manage
> System MMU platform devices because of the following reasons:
> 1. A device driver which needs to handle System MMU must know the ID.
> 2. A System MMU may not present in some implementations of Exynos family.
> 3. Handling System MMU with IOMMU API does not require an ID.
> 
> This patch is the result of removing ID of System MMUs.
> Instead, a device driver that needs to handle its System MMU must
> use IOMMU API while its descriptor of platform device is given.
> 
> This patch also includes the following enhanclements:
> - A System MMU device becomes a child if its power domain device.
> - clkdev
> 
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig                      |    2 +
>  arch/arm/mach-exynos/clock-exynos4210.c           |   16 ++
>  arch/arm/mach-exynos/clock.c                      |   55 ++--
>  arch/arm/mach-exynos/dev-sysmmu.c                 |  272 +++++----------------
>  arch/arm/mach-exynos/include/mach/dev-sysmmu.h    |   61 +++++
>  arch/arm/mach-exynos/include/mach/exynos4-clock.h |    1 +
>  arch/arm/mach-exynos/include/mach/map.h           |    3 +-
>  arch/arm/mach-exynos/include/mach/regs-sysmmu.h   |   26 +-
>  arch/arm/mach-exynos/include/mach/sysmmu.h        |   46 ----
>  arch/arm/mach-exynos/mach-armlex4210.c            |    1 -
>  arch/arm/mach-exynos/mach-nuri.c                  |   40 +++
>  arch/arm/mach-exynos/mach-origen.c                |   42 ++++
>  arch/arm/mach-exynos/mach-smdk4x12.c              |    9 +
>  arch/arm/mach-exynos/mach-smdkv310.c              |   43 ++++-
>  arch/arm/mach-exynos/mach-universal_c210.c        |   42 ++++
>  arch/arm/plat-samsung/include/plat/devs.h         |    1 -
>  16 files changed, 356 insertions(+), 304 deletions(-)
>  create mode 100644 arch/arm/mach-exynos/include/mach/dev-sysmmu.h
>  delete mode 100644 arch/arm/mach-exynos/include/mach/sysmmu.h
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 0afcc3b..67769fb 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -272,6 +272,7 @@ config MACH_NURI
>  	select EXYNOS4_SETUP_I2C5
>  	select EXYNOS4_SETUP_SDHCI
>  	select EXYNOS4_SETUP_USB_PHY
> +	select EXYNOS4_DEV_SYSMMU
>  	select S5P_SETUP_MIPIPHY
>  	select SAMSUNG_DEV_PWM
>  	select SAMSUNG_DEV_ADC
> @@ -301,6 +302,7 @@ config MACH_ORIGEN
>  	select EXYNOS4_SETUP_FIMD0
>  	select EXYNOS4_SETUP_SDHCI
>  	select EXYNOS4_SETUP_USB_PHY
> +	select EXYNOS4_DEV_SYSMMU

The "select EXYNOS4_DEV_SYSMMU" statement is missing for UniversalC210 and SMDK boards
what causes compilation issues if only these boards are selected.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center




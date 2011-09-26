Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1IZKAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:00:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1IZKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:00:51 -0400
MIME-Version: 1.0
Date: Mon, 26 Sep 2011 19:00:49 +0900
X-Google-Sender-Auth: CPQqS11QDVhHAzsMHAntJjl74D0
Message-ID: <CAHQjnOMCU26ELOpn7h7hcju-s970SSG5E545rPgCpw3_LkkAhA@mail.gmail.com>
Subject: [PATCH 0/4 v2] iommu/exynos: Add IOMMU and Enhance System MMU driver
 for Exynos4
From: KyongHo Cho <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second try of submitting patches about IOMMU/System MMU
driver for Exynos4 SoCs with the fixes of the following problems
pointed by Russell King.:
 - Missing unlocking a spinlock in exynos_iommu_attach_dev().
 - atomic_t -> int in sysmmu_drvdata.activations
 - sysmmu_platdata -> sysmmu_drvdata
 - Change in error messages in irq handler
 - Removed casting in format of error message
 - omap_iommu_ops -> exynos_iommu_ops in the last patch.

First 2 patches enhance System MMU platform device definition:
 - Removed System MMU for MDMA0 in LCD block because it is not used.
  Use MDMA2 in TOP block.
 - Removed System MMU ID. Instead a System MMU is bound to a device that
  the System MMU is dedicated during machin initialization. If a device
  driver wants to handle System MMU, it must bind its device with System
  MMU with sysmmu_set_owner().
 - clkdev
 - System MMU device driver is removed from arch/arm/plat-s5p to move it
  to driver/iommu directory.
Last 2 patches implements IOMMU API:
 - Implements IOMMU API and System MMU driver that is moved from
  arch/arm/plat-s5p.
 - Implements fault handling that is suggested by Ohad.
 - Used bus_set_iommu instead of register_iommu that is suggested by Joerg.

Regards,
Cho KyongHo.

Diffstats:

arch/arm/mach-exynos4/Kconfig               |    2 -
arch/arm/mach-exynos4/clock.c               |   43 +-
arch/arm/mach-exynos4/dev-sysmmu.c          |  270 ++------
arch/arm/mach-exynos4/include/mach/irqs.h   |    1 -
arch/arm/mach-exynos4/include/mach/map.h    |    1 -
arch/arm/mach-exynos4/include/mach/sysmmu.h |   85 ++-
arch/arm/mach-exynos4/mach-armlex4210.c     |   24 +-
arch/arm/mach-exynos4/mach-smdkv310.c       |   28 +-
arch/arm/plat-s5p/Kconfig                   |    8 -
arch/arm/plat-s5p/Makefile                  |    1 -
arch/arm/plat-s5p/include/plat/sysmmu.h     |   95 ---
arch/arm/plat-s5p/sysmmu.c                  |  312 ---------
drivers/iommu/Kconfig                       |   14 +
drivers/iommu/Makefile                      |    1 +
drivers/iommu/exynos_iommu.c                |  933 +++++++++++++++++++++++++++
15 files changed, 1134 insertions(+), 684 deletions(-)

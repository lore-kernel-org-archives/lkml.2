Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1I0Lo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:44:59 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:40527 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1I0Ln2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:43:28 -0400
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        YoungLak Kim <younglak1004.kim@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 0/4] iommu/exynos: Add IOMMU and Enhance System MMU driver for Exynos4
Date: Sat, 24 Sep 2011 11:02:46 +0900
Message-Id: <1316829770-21949-1-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Diffstats:

arch/arm/mach-exynos4/Kconfig               |    2 -
arch/arm/mach-exynos4/clock.c               |   43 +-
arch/arm/mach-exynos4/dev-sysmmu.c          |  281 +++-------
arch/arm/mach-exynos4/include/mach/irqs.h   |    1 -
arch/arm/mach-exynos4/include/mach/map.h    |    1 -
arch/arm/mach-exynos4/include/mach/sysmmu.h |   96 ++--
arch/arm/mach-exynos4/mach-armlex4210.c     |   24 +-
arch/arm/mach-exynos4/mach-smdkv310.c       |   28 +-
arch/arm/plat-s5p/Kconfig                   |    8 -
arch/arm/plat-s5p/Makefile                  |    1 -
arch/arm/plat-s5p/include/plat/sysmmu.h     |   95 ---
arch/arm/plat-s5p/sysmmu.c                  |  312 ----------
drivers/iommu/Kconfig                       |   14 +
drivers/iommu/Makefile                      |    1 +
drivers/iommu/exynos_iommu.c                |  859 +++++++++++++++++++++++++++
15 files changed, 1084 insertions(+), 682 deletions(-)


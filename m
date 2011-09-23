Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1I0LnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:43:18 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:40429 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab1I0LnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:43:16 -0400
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        YoungLak Kim <younglak1004.kim@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 0/3] iommu/exynos: Add iommu driver for Exynos4 SoCs
Date: Fri, 23 Sep 2011 21:01:44 +0900
Message-Id: <1316779307-2567-1-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This patch set enhances System MMU platform device definitions of Exynos
SoC platforms, adds the implementation of IOMMU API as well as and moves
Syste MMU driver to the drivers/iommu directory.

The IOMMU driver also implements fault handler that Ohad Ben-Cohen has
suggeested and iommu_ops per-bus_type that Joerg Roedel suggests.

CONFIG_S5P_SYSTEM_MMU is removed because it is replaceable
with CONFIG_EXYNOS4_IOMMU.

Diffstat:

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



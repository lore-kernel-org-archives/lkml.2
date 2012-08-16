Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2HPObb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:31:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17210 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2HPOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:31:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 16 Aug 2012 07:31:06 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>, <grant.likely@secretlab.ca>,
        <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <vinod.koul@linux.intel.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <alsa-devel@alsa-project.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] ARM: tegra: move all APB DMA client to dmaengine based driver
Date: Thu, 16 Aug 2012 19:43:12 +0530
Message-ID: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enable the dmaengine based Tegra APB DMA driver
and remove the support code for the legacy dma driver from different
APB DMA clients.
Patch 1 enable the dmaengine based dma drie and disable the legacy dma driver
        in config file.
Patch 2 remove the legacy dma driver.
Patch 3,4, 5 remove the support code from different APB DMA clients to support
        legacy dma driver.

Please note that this series will depends on patch
dma: tegra: enable/disable dma clock
which is not in 3.6-rc1 but will be available in next RC (rc2) of 3.6 as
part of fixes.

Laxman Dewangan (5):
  ARM: tegra: config: enable dmaengine based APB DMA driver
  ARM: tegra: dma: remove legacy APB DMA driver
  ARM: tegra: apbio: remove support of legacy DMA driver based access
  spi: tegra: remove support of legacy DMA driver based access
  ASoC: tegra: remove support of legacy DMA driver based access

 arch/arm/configs/tegra_defconfig       |    3 +
 arch/arm/mach-tegra/Kconfig            |    7 -
 arch/arm/mach-tegra/Makefile           |    1 -
 arch/arm/mach-tegra/apbio.c            |  118 +-----
 arch/arm/mach-tegra/dma.c              |  823 --------------------------------
 arch/arm/mach-tegra/include/mach/dma.h |   97 ----
 drivers/spi/Kconfig                    |    2 +-
 drivers/spi/spi-tegra.c                |   55 +--
 sound/soc/tegra/Kconfig                |    2 +-
 sound/soc/tegra/tegra_pcm.c            |  232 ---------
 sound/soc/tegra/tegra_pcm.h            |   14 -
 11 files changed, 7 insertions(+), 1347 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/dma.c


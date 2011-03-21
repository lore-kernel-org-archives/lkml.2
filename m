Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1CUIFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:05:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34292 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1CUIFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:05:10 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, sameo@linux.intel.com, grant.likely@secretlab.ca,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 5/5] mmc: sdhci: update Makefile/Kconfig for sdhci_pltfm change
Date: Mon, 21 Mar 2011 16:07:03 +0800
Message-Id: <1300694823-8300-6-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sdhci_pltfm.c becomes a file only having common support functions
than a driver with its registeration before.  The patch is to update
Makefile and Kconfig to let MMC_SDHCI_PLTFM be selected by specific
SDHCI device drivers.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/Kconfig  |   24 +++++++++++++-----------
 drivers/mmc/host/Makefile |   11 +++++------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index afe8c6f..1db9347 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -113,20 +113,17 @@ config MMC_SDHCI_OF_HLWD
 	  If unsure, say N.
 
 config MMC_SDHCI_PLTFM
-	tristate "SDHCI support on the platform specific bus"
+	bool
 	depends on MMC_SDHCI
 	help
-	  This selects the platform specific bus support for Secure Digital Host
-	  Controller Interface.
-
-	  If you have a controller with this interface, say Y or M here.
-
-	  If unsure, say N.
+	  This selects the platform common function support for Secure Digital
+	  Host Controller Interface.
 
 config MMC_SDHCI_CNS3XXX
 	bool "SDHCI support on the Cavium Networks CNS3xxx SoC"
 	depends on ARCH_CNS3XXX
-	depends on MMC_SDHCI_PLTFM
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	help
 	  This selects the SDHCI support for CNS3xxx System-on-Chip devices.
 
@@ -134,7 +131,9 @@ config MMC_SDHCI_CNS3XXX
 
 config MMC_SDHCI_ESDHC_IMX
 	bool "SDHCI platform support for the Freescale eSDHC i.MX controller"
-	depends on MMC_SDHCI_PLTFM && (ARCH_MX25 || ARCH_MX35 || ARCH_MX5)
+	depends on ARCH_MX25 || ARCH_MX35 || ARCH_MX5
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Freescale eSDHC controller support on the platform
@@ -145,7 +144,8 @@ config MMC_SDHCI_ESDHC_IMX
 config MMC_SDHCI_DOVE
 	bool "SDHCI support on Marvell's Dove SoC"
 	depends on ARCH_DOVE
-	depends on MMC_SDHCI_PLTFM
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Secure Digital Host Controller Interface in
@@ -155,7 +155,9 @@ config MMC_SDHCI_DOVE
 
 config MMC_SDHCI_TEGRA
 	tristate "SDHCI platform support for the Tegra SD/MMC Controller"
-	depends on MMC_SDHCI_PLTFM && ARCH_TEGRA
+	depends on ARCH_TEGRA
+	depends on MMC_SDHCI
+	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Tegra SD/MMC controller. If you have a Tegra
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index e834fb2..1d8e43d 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -36,12 +36,11 @@ obj-$(CONFIG_MMC_SH_MMCIF)	+= sh_mmcif.o
 obj-$(CONFIG_MMC_JZ4740)	+= jz4740_mmc.o
 obj-$(CONFIG_MMC_USHC)		+= ushc.o
 
-obj-$(CONFIG_MMC_SDHCI_PLTFM)			+= sdhci-platform.o
-sdhci-platform-y				:= sdhci-pltfm.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_CNS3XXX)	+= sdhci-cns3xxx.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
-sdhci-platform-$(CONFIG_MMC_SDHCI_TEGRA)	+= sdhci-tegra.o
+obj-$(CONFIG_MMC_SDHCI_PLTFM)		+= sdhci-pltfm.o
+obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+= sdhci-cns3xxx.o
+obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
+obj-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
+obj-$(CONFIG_MMC_SDHCI_TEGRA)		+= sdhci-tegra.o
 
 obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 sdhci-of-y				:= sdhci-of-core.o
-- 
1.7.1


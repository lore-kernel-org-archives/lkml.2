Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2LREsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 23:48:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15169 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LREsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 23:48:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 17 Dec 2012 20:48:09 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] arm: tegra: remove USB address related macros from iomap.h
Date: Tue, 18 Dec 2012 10:01:01 +0530
Message-ID: <1355805061-22789-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB register base address and sizes defined in iomap.h
are not used in any files other than board-dt-tegra20.c.
Hence removed those defines from header file and using
the absolute values in board files.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    6 +++---
 arch/arm/mach-tegra/iomap.h            |    9 ---------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 734d9cc..aae399b 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -81,11 +81,11 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra20-i2s.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S2_BASE, "tegra20-i2s.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-das", TEGRA_APB_MISC_DAS_BASE, "tegra20-das", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB_BASE, "tegra-ehci.0",
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5000000, "tegra-ehci.0",
 		       &tegra_ehci1_pdata),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB2_BASE, "tegra-ehci.1",
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5004000, "tegra-ehci.1",
 		       &tegra_ehci2_pdata),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB3_BASE, "tegra-ehci.2",
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5008000, "tegra-ehci.2",
 		       &tegra_ehci3_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-apbdma", TEGRA_APB_DMA_BASE, "tegra-apbdma", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
diff --git a/arch/arm/mach-tegra/iomap.h b/arch/arm/mach-tegra/iomap.h
index db8be51..399fbca 100644
--- a/arch/arm/mach-tegra/iomap.h
+++ b/arch/arm/mach-tegra/iomap.h
@@ -240,15 +240,6 @@
 #define TEGRA_CSITE_BASE		0x70040000
 #define TEGRA_CSITE_SIZE		SZ_256K
 
-#define TEGRA_USB_BASE			0xC5000000
-#define TEGRA_USB_SIZE			SZ_16K
-
-#define TEGRA_USB2_BASE			0xC5004000
-#define TEGRA_USB2_SIZE			SZ_16K
-
-#define TEGRA_USB3_BASE			0xC5008000
-#define TEGRA_USB3_SIZE			SZ_16K
-
 #define TEGRA_SDMMC1_BASE		0xC8000000
 #define TEGRA_SDMMC1_SIZE		SZ_512
 
-- 
1.7.0.4


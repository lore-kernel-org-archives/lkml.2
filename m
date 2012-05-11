Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757Ab2EKG4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:56:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1594 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621Ab2EKG4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:56:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 10 May 2012 23:56:37 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] ARM: tegra20: Make MC optional in Kconfig
Date: Fri, 11 May 2012 09:56:24 +0300
Message-ID: <1336719389-28506-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120511095012.57f737d1b0d2536e0d367a9b@nvidia.com>
References: <20120511095012.57f737d1b0d2536e0d367a9b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For bare minimal system.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig |    2 --
 drivers/memory/Kconfig      |    8 +++++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 16fe065..8b6b181 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -20,8 +20,6 @@ config ARCH_TEGRA_2x_SOC
 	select PL310_ERRATA_727915 if CACHE_L2X0
 	select PL310_ERRATA_769419 if CACHE_L2X0
 	select CPU_FREQ_TABLE if CPU_FREQ
-	select MEMORY
-	select TEGRA20_MC
 	help
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index 42e6d66..efc6b36 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -21,8 +21,14 @@ config TI_EMIF
 	  temperature changes
 
 config TEGRA20_MC
-	bool
+	bool "Tegra20 Memory Controller(MC) driver"
+	default y
 	depends on ARCH_TEGRA_2x_SOC
+	help
+	  This driver is for the Memory Controller(MC) module available
+	  in Tegra20 SoCs, mainly for a address translation fault
+	  analysis, especially for IOMMU/GART(Graphics Address
+	  Relocation Table) module.
 
 config TEGRA30_MC
 	bool
-- 
1.7.5.4


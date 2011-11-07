Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1KGOUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:20:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19645 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1KGOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:20:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Nov 2011 06:20:33 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v3 7/8] arm/tegra: implement support for tegra30
Date: Mon, 7 Nov 2011 16:20:14 +0200
Message-ID: <1320675617-20751-8-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for tegra30 SoC. This includes a device tree compatible type for
this SoC ("nvidia,tegra30") and adds L2 cache initialization for this new SoC.
The clock framework is still missing, which prevents most drivers from working.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig    |   18 +++++++++++++-----
 arch/arm/mach-tegra/board-dt.c |    1 +
 arch/arm/mach-tegra/board.h    |    1 +
 arch/arm/mach-tegra/common.c   |    6 ++++++
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 91aff7c..f2eb6d1 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -2,11 +2,8 @@ if ARCH_TEGRA
 
 comment "NVIDIA Tegra options"
 
-choice
-	prompt "Select Tegra processor family for target system"
-
 config ARCH_TEGRA_2x_SOC
-	bool "Tegra 2 family"
+	bool "Enable support for Tegra20 family"
 	select CPU_V7
 	select ARM_GIC
 	select ARCH_REQUIRE_GPIOLIB
@@ -17,7 +14,18 @@ config ARCH_TEGRA_2x_SOC
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
 
-endchoice
+config ARCH_TEGRA_3x_SOC
+	bool "Enable support for Tegra30 family"
+	select CPU_V7
+	select ARM_GIC
+	select ARCH_REQUIRE_GPIOLIB
+	select USB_ARCH_HAS_EHCI if USB_SUPPORT
+	select USB_ULPI if USB_SUPPORT
+	select USB_ULPI_VIEWPORT if USB_SUPPORT
+	select USE_OF
+	help
+	  Support for NVIDIA Tegra T30 processor family, based on the
+	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
 
 config TEGRA_PCI
 	bool "PCI Express support"
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index a7bae50..1680e96 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -123,6 +123,7 @@ static struct {
 	void (*init)(void);
 } early_init[] __initdata = {
 	{ "nvidia,tegra20", tegra20_init_early },
+	{ "nvidia,tegra30", tegra30_init_early },
 };
 
 static void __init tegra_init_early(void)
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index b86cdab..708b330a 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 
 void __init tegra20_init_early(void);
+void __init tegra30_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_init_clock(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 35cf81a..0257d6d 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -94,3 +94,9 @@ void __init tegra20_init_early(void)
 	tegra_init_cache(0x331, 0x441);
 	tegra_common_init();
 }
+
+void __init tegra30_init_early(void)
+{
+	tegra_init_cache(0x441, 0x551);
+	tegra_setup_system_reset();
+}
-- 
1.7.7.rc0.72.g4b5ea.dirty


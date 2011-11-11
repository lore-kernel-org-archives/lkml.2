Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab1KKLWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:22:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6956 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab1KKLWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:22:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Nov 2011 03:22:28 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v4 02/10] arm/tegra: cleanup tegra20 support
Date: Fri, 11 Nov 2011 13:22:08 +0200
Message-ID: <1321010541-31337-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* add a dependency to ARCH_TEGRA_2x_SOC in Kconfig to all tegra20 based boards
  and TEGRA_PCI
* make powergating dependent on ARCH_TEGRA_2x_SOC
* remove dependency on ARCH_TEGRA_2x_SOC for clock.c

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig  |    8 ++++++++
 arch/arm/mach-tegra/Makefile |    3 +--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 91aff7c..2b1d49b 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -21,18 +21,21 @@ endchoice
 
 config TEGRA_PCI
 	bool "PCI Express support"
+	depends on ARCH_TEGRA_2x_SOC
 	select PCI
 
 comment "Tegra board type"
 
 config MACH_HARMONY
        bool "Harmony board"
+       depends on ARCH_TEGRA_2x_SOC
        select MACH_HAS_SND_SOC_TEGRA_WM8903 if SND_SOC
        help
          Support for nVidia Harmony development platform
 
 config MACH_KAEN
        bool "Kaen board"
+       depends on ARCH_TEGRA_2x_SOC
        select MACH_SEABOARD
        select MACH_HAS_SND_SOC_TEGRA_WM8903 if SND_SOC
        help
@@ -40,11 +43,13 @@ config MACH_KAEN
 
 config MACH_PAZ00
        bool "Paz00 board"
+       depends on ARCH_TEGRA_2x_SOC
        help
          Support for the Toshiba AC100/Dynabook AZ netbook
 
 config MACH_SEABOARD
        bool "Seaboard board"
+       depends on ARCH_TEGRA_2x_SOC
        select MACH_HAS_SND_SOC_TEGRA_WM8903 if SND_SOC
        help
          Support for nVidia Seaboard development platform. It will
@@ -59,18 +64,21 @@ config MACH_TEGRA_DT
 
 config MACH_TRIMSLICE
        bool "TrimSlice board"
+       depends on ARCH_TEGRA_2x_SOC
        select TEGRA_PCI
        help
          Support for CompuLab TrimSlice platform
 
 config MACH_WARIO
        bool "Wario board"
+       depends on ARCH_TEGRA_2x_SOC
        select MACH_SEABOARD
        help
          Support for the Wario version of Seaboard
 
 config MACH_VENTANA
        bool "Ventana board"
+       depends on ARCH_TEGRA_2x_SOC
        select MACH_TEGRA_DT
        help
          Support for the nVidia Ventana development platform
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 91a07e1..7dc1db3 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -5,9 +5,8 @@ obj-y                                   += irq.o
 obj-y                                   += clock.o
 obj-y                                   += timer.o
 obj-y                                   += pinmux.o
-obj-y                                   += powergate.o
 obj-y					+= fuse.o
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clock.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= powergate.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-t2-tables.o
-- 
1.7.7.rc0.72.g4b5ea.dirty


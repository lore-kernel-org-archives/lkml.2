Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab1KQQ0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:26:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6453 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab1KQQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:24:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Nov 2011 08:23:51 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 02/10] arm/tegra: cleanup tegra20 support
Date: Thu, 17 Nov 2011 18:19:16 +0200
Message-ID: <1321546766-26770-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
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
index c9ec38e..26ff456 100644
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


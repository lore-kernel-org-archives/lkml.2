Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1JATXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:23:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1JATWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:22:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/11] ARM: pm: let platforms select cpu_suspend support
Date: Sat,  1 Oct 2011 21:21:55 +0200
Message-Id: <1317496920-7764-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:MQlxwkHRUX6YpFToju0L9OHzsvMZNPFESu+O1Yxmmoo
 swAokzh/MeL55LGcs6OElz5F1BVWQ8YAqR74Iv7FBCysJGEFKm
 vjxb7oHg+KDfz3NnMLWsSWiLbcfl6lwG8ySZ14OAq1z3KRahlo
 hKZAfWcIxqcaMGzYVMatMxdWAmuT++LSJ8q62KLi5+b3PL+kTf
 XfwlOYZs9wmUSCd55Mn/FiA0BvKnE2HyhdeiizGXV0Cl4P2rEC
 j0sy6I9Z5fMIfw/M+U80vKH/Qpa/LNLVuZDH69dLHpfmCtuWhm
 cJbpfvTa/W8CJLsnEobLAfaMU7Ijt8Q1oSRMPNTn2HpJc5YbZI
 JGEy3USwg081P9qgVafEWfzENwPamn0f2Gbse9O5g
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the cpu_suspend functions is only built-in
when CONFIG_PM_SLEEP is enabled, but omap3/4, exynos4
and pxa always call cpu_suspend when CONFIG_PM is enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig              |    4 ++++
 arch/arm/kernel/Makefile      |    2 +-
 arch/arm/mach-exynos4/Kconfig |    1 +
 arch/arm/mach-omap2/Kconfig   |    2 ++
 arch/arm/mm/proc-v7.S         |    2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 497af51..3445f50 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -631,6 +631,7 @@ config ARCH_PXA
 	select SPARSE_IRQ
 	select AUTO_ZRELADDR
 	select MULTI_IRQ_HANDLER
+	select ARM_CPU_SUSPEND if PM
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
@@ -2077,6 +2078,9 @@ config ARCH_SUSPEND_POSSIBLE
 		CPU_V6 || CPU_V6K || CPU_V7 || CPU_XSC3 || CPU_XSCALE
 	def_bool y
 
+config ARM_CPU_SUSPEND
+	def_bool PM_SLEEP
+
 endmenu
 
 source "net/Kconfig"
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index f7887dc..4ce3303 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_MODULES)		+= armksyms.o module.o
 obj-$(CONFIG_ARTHUR)		+= arthur.o
 obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
 obj-$(CONFIG_PCI)		+= bios32.o isa.o
-obj-$(CONFIG_PM_SLEEP)		+= sleep.o
+obj-$(CONFIG_ARM_CPU_SUSPEND)	+= sleep.o
 obj-$(CONFIG_HAVE_SCHED_CLOCK)	+= sched_clock.o
 obj-$(CONFIG_SMP)		+= smp.o smp_tlb.o
 obj-$(CONFIG_HAVE_ARM_SCU)	+= smp_scu.o
diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index 0c77ab9..fc1f92d 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -12,6 +12,7 @@ if ARCH_EXYNOS4
 config CPU_EXYNOS4210
 	bool
 	select S3C_PL330_DMA
+	select ARM_CPU_SUSPEND if PM
 	help
 	  Enable EXYNOS4210 CPU support
 
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 57b66d5..89bfb49 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -36,6 +36,7 @@ config ARCH_OMAP3
 	select ARM_L1_CACHE_SHIFT_6 if !ARCH_OMAP4
 	select ARCH_HAS_OPP
 	select PM_OPP if PM
+	select ARM_CPU_SUSPEND if PM
 
 config ARCH_OMAP4
 	bool "TI OMAP4"
@@ -50,6 +51,7 @@ config ARCH_OMAP4
 	select ARCH_HAS_OPP
 	select PM_OPP if PM
 	select USB_ARCH_HAS_EHCI
+	select ARM_CPU_SUSPEND if PM
 
 comment "OMAP Core Type"
 	depends on ARCH_OMAP2
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index a30e785..591accd 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -217,7 +217,7 @@ ENDPROC(cpu_v7_set_pte_ext)
 /* Suspend/resume support: derived from arch/arm/mach-s5pv210/sleep.S */
 .globl	cpu_v7_suspend_size
 .equ	cpu_v7_suspend_size, 4 * 9
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_v7_do_suspend)
 	stmfd	sp!, {r4 - r11, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ FCSE/PID
-- 
1.7.5.4


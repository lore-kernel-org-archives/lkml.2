Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511Ab2JWU7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:59:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55348 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 007/193] arch/arm: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:20 -0700
Message-Id: <1351022666-6960-8-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/Kconfig       |   51 +++++++++++++++++++++++-------------------------
 arch/arm/Kconfig.debug |    4 ++--
 2 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 73067ef..7048415 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1519,8 +1519,7 @@ config SMP
 	  If you don't know what to do here, say N.
 
 config SMP_ON_UP
-	bool "Allow booting SMP kernel on uniprocessor systems (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Allow booting SMP kernel on uniprocessor systems"
 	depends on SMP && !XIP_KERNEL
 	default y
 	help
@@ -1603,8 +1602,8 @@ config NR_CPUS
 	default "4"
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	bool "Support for hot-pluggable CPUs"
+	depends on SMP && HOTPLUG
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
@@ -1645,8 +1644,8 @@ config HZ
 	default 100
 
 config THUMB2_KERNEL
-	bool "Compile the kernel in Thumb-2 mode (EXPERIMENTAL)"
-	depends on CPU_V7 && !CPU_V6 && !CPU_V6K && EXPERIMENTAL
+	bool "Compile the kernel in Thumb-2 mode"
+	depends on CPU_V7 && !CPU_V6 && !CPU_V6K
 	select AEABI
 	select ARM_ASM_UNIFIED
 	select ARM_UNWIND
@@ -1707,8 +1706,8 @@ config AEABI
 	  To use this you need GCC version 4.0.0 or later.
 
 config OABI_COMPAT
-	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
-	depends on AEABI && EXPERIMENTAL && !THUMB2_KERNEL
+	bool "Allow old ABI binaries to run with this kernel"
+	depends on AEABI && !THUMB2_KERNEL
 	default y
 	help
 	  This option preserves the old syscall interface along with the
@@ -1831,8 +1830,7 @@ config SECCOMP
 	  defined by each seccomp mode.
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Enable -fstack-protector buffer overflow detection"
 	help
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -1916,8 +1914,8 @@ config ZBOOT_ROM
 	  (zImage) directly from ROM or flash.  If unsure, say N.
 
 choice
-	prompt "Include SD/MMC loader in zImage (EXPERIMENTAL)"
-	depends on ZBOOT_ROM && ARCH_SH7372 && EXPERIMENTAL
+	prompt "Include SD/MMC loader in zImage"
+	depends on ZBOOT_ROM && ARCH_SH7372
 	default ZBOOT_ROM_NONE
 	help
 	  Include experimental SD/MMC loading code in the ROM-able zImage.
@@ -1928,25 +1926,25 @@ choice
 	  rest the kernel image to RAM.
 
 config ZBOOT_ROM_NONE
-	bool "No SD/MMC loader in zImage (EXPERIMENTAL)"
+	bool "No SD/MMC loader in zImage"
 	help
 	  Do not load image from SD or MMC
 
 config ZBOOT_ROM_MMCIF
-	bool "Include MMCIF loader in zImage (EXPERIMENTAL)"
+	bool "Include MMCIF loader in zImage"
 	help
 	  Load image from MMCIF hardware block.
 
 config ZBOOT_ROM_SH_MOBILE_SDHI
-	bool "Include SuperH Mobile SDHI loader in zImage (EXPERIMENTAL)"
+	bool "Include SuperH Mobile SDHI loader in zImage"
 	help
 	  Load image from SDHI hardware block
 
 endchoice
 
 config ARM_APPENDED_DTB
-	bool "Use appended device tree blob to zImage (EXPERIMENTAL)"
-	depends on OF && !ZBOOT_ROM && EXPERIMENTAL
+	bool "Use appended device tree blob to zImage"
+	depends on OF && !ZBOOT_ROM
 	help
 	  With this option, the boot code will look for a device tree binary
 	  (DTB) appended to zImage
@@ -2063,8 +2061,8 @@ config XIP_PHYS_ADDR
 	  own flash usage.
 
 config KEXEC
-	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && (!SMP || HOTPLUG_CPU)
+	bool "Kexec system call"
+	depends on (!SMP || HOTPLUG_CPU)
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -2085,8 +2083,7 @@ config ATAGS_PROC
 	  file in procfs. Useful with kexec.
 
 config CRASH_DUMP
-	bool "Build kdump crash kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Build kdump crash kernel"
 	help
 	  Generate crash dump after being started by kexec. This should
 	  be normally only set in special crash dump kernels which are
@@ -2152,8 +2149,8 @@ config CPU_FREQ_S3C
 	  Internal configuration node for common cpufreq on Samsung SoC
 
 config CPU_FREQ_S3C24XX
-	bool "CPUfreq driver for Samsung S3C24XX series CPUs (EXPERIMENTAL)"
-	depends on ARCH_S3C24XX && CPU_FREQ && EXPERIMENTAL
+	bool "CPUfreq driver for Samsung S3C24XX series CPUs"
+	depends on ARCH_S3C24XX && CPU_FREQ
 	select CPU_FREQ_S3C
 	help
 	  This enables the CPUfreq driver for the Samsung S3C24XX family
@@ -2164,8 +2161,8 @@ config CPU_FREQ_S3C24XX
 	  If in doubt, say N.
 
 config CPU_FREQ_S3C24XX_PLL
-	bool "Support CPUfreq changing of PLL frequency (EXPERIMENTAL)"
-	depends on CPU_FREQ_S3C24XX && EXPERIMENTAL
+	bool "Support CPUfreq changing of PLL frequency"
+	depends on CPU_FREQ_S3C24XX
 	help
 	  Compile in support for changing the PLL frequency from the
 	  S3C24XX series CPUfreq driver. The PLL takes time to settle
@@ -2227,8 +2224,8 @@ config FPE_NWFPE_XP
 	  You almost surely want to say N here.
 
 config FPE_FASTFPE
-	bool "FastFPE math emulation (EXPERIMENTAL)"
-	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3 && EXPERIMENTAL
+	bool "FastFPE math emulation"
+	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3
 	---help---
 	  Say Y here to include the FAST floating point emulator in the kernel.
 	  This is an experimental much faster emulator which now also has full
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b0f3857..98e4bfb 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -31,8 +31,8 @@ config FRAME_POINTER
 	  reported is severely limited.
 
 config ARM_UNWIND
-	bool "Enable stack unwinding support (EXPERIMENTAL)"
-	depends on AEABI && EXPERIMENTAL
+	bool "Enable stack unwinding support"
+	depends on AEABI
 	default y
 	help
 	  This option enables stack unwinding support in the kernel
-- 
1.7.9.5


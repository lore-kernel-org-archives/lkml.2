Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab2KEXHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:07:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52971 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab2KEXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:06:34 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 025/104] arch/arm: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:42 -0800
Message-Id: <1352156701-4038-26-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/Kconfig       |   19 ++++++++-----------
 arch/arm/Kconfig.debug |    2 +-
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ade7e92..550ca17 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1520,7 +1520,6 @@ config SMP
 
 config SMP_ON_UP
 	bool "Allow booting SMP kernel on uniprocessor systems (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	depends on SMP && !XIP_KERNEL
 	default y
 	help
@@ -1708,7 +1707,7 @@ config AEABI
 
 config OABI_COMPAT
 	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
-	depends on AEABI && EXPERIMENTAL && !THUMB2_KERNEL
+	depends on AEABI && !THUMB2_KERNEL
 	default y
 	help
 	  This option preserves the old syscall interface along with the
@@ -1832,7 +1831,6 @@ config SECCOMP
 
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -1849,7 +1847,7 @@ config XEN_DOM0
 
 config XEN
 	bool "Xen guest support on ARM (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ARM && OF
+	depends on ARM && OF
 	depends on CPU_V7 && !CPU_V6
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
@@ -1918,7 +1916,7 @@ config ZBOOT_ROM
 
 choice
 	prompt "Include SD/MMC loader in zImage (EXPERIMENTAL)"
-	depends on ZBOOT_ROM && ARCH_SH7372 && EXPERIMENTAL
+	depends on ZBOOT_ROM && ARCH_SH7372
 	default ZBOOT_ROM_NONE
 	help
 	  Include experimental SD/MMC loading code in the ROM-able zImage.
@@ -1947,7 +1945,7 @@ endchoice
 
 config ARM_APPENDED_DTB
 	bool "Use appended device tree blob to zImage (EXPERIMENTAL)"
-	depends on OF && !ZBOOT_ROM && EXPERIMENTAL
+	depends on OF && !ZBOOT_ROM
 	help
 	  With this option, the boot code will look for a device tree binary
 	  (DTB) appended to zImage
@@ -2065,7 +2063,7 @@ config XIP_PHYS_ADDR
 
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && (!SMP || HOTPLUG_CPU)
+	depends on (!SMP || HOTPLUG_CPU)
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -2087,7 +2085,6 @@ config ATAGS_PROC
 
 config CRASH_DUMP
 	bool "Build kdump crash kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  Generate crash dump after being started by kexec. This should
 	  be normally only set in special crash dump kernels which are
@@ -2154,7 +2151,7 @@ config CPU_FREQ_S3C
 
 config CPU_FREQ_S3C24XX
 	bool "CPUfreq driver for Samsung S3C24XX series CPUs (EXPERIMENTAL)"
-	depends on ARCH_S3C24XX && CPU_FREQ && EXPERIMENTAL
+	depends on ARCH_S3C24XX && CPU_FREQ
 	select CPU_FREQ_S3C
 	help
 	  This enables the CPUfreq driver for the Samsung S3C24XX family
@@ -2166,7 +2163,7 @@ config CPU_FREQ_S3C24XX
 
 config CPU_FREQ_S3C24XX_PLL
 	bool "Support CPUfreq changing of PLL frequency (EXPERIMENTAL)"
-	depends on CPU_FREQ_S3C24XX && EXPERIMENTAL
+	depends on CPU_FREQ_S3C24XX
 	help
 	  Compile in support for changing the PLL frequency from the
 	  S3C24XX series CPUfreq driver. The PLL takes time to settle
@@ -2229,7 +2226,7 @@ config FPE_NWFPE_XP
 
 config FPE_FASTFPE
 	bool "FastFPE math emulation (EXPERIMENTAL)"
-	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3 && EXPERIMENTAL
+	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3
 	---help---
 	  Say Y here to include the FAST floating point emulator in the kernel.
 	  This is an experimental much faster emulator which now also has full
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b0f3857..9e94bfa 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -32,7 +32,7 @@ config FRAME_POINTER
 
 config ARM_UNWIND
 	bool "Enable stack unwinding support (EXPERIMENTAL)"
-	depends on AEABI && EXPERIMENTAL
+	depends on AEABI
 	default y
 	help
 	  This option enables stack unwinding support in the kernel
-- 
1.7.9.5


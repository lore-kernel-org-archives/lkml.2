Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab2KEX1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:27:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:53146 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab2KEXFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:23 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Paul Mundt <lethal@linux-sh.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 038/104] arch/sh: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:55 -0800
Message-Id: <1352156701-4038-39-git-send-email-keescook@chromium.org>
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

CC: Paul Mundt <lethal@linux-sh.org>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/sh/Kconfig     |   13 ++++++-------
 arch/sh/Kconfig.cpu |    3 +--
 arch/sh/mm/Kconfig  |    4 ++--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index babc2b8..4765379 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -648,7 +648,7 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on SUPERH32 && EXPERIMENTAL && MMU
+	depends on SUPERH32 && MMU
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -665,7 +665,7 @@ config KEXEC
 
 config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on SUPERH32 && EXPERIMENTAL && BROKEN_ON_SMP
+	depends on SUPERH32 && BROKEN_ON_SMP
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
@@ -679,7 +679,7 @@ config CRASH_DUMP
 
 config KEXEC_JUMP
 	bool "kexec jump (EXPERIMENTAL)"
-	depends on SUPERH32 && KEXEC && HIBERNATION && EXPERIMENTAL
+	depends on SUPERH32 && KEXEC && HIBERNATION
 	help
 	  Jump between original kernel and kexeced kernel and invoke
 	  code via KEXEC
@@ -713,7 +713,7 @@ config SECCOMP
 
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on SUPERH32 && EXPERIMENTAL
+	depends on SUPERH32
 	help
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -764,7 +764,7 @@ config NR_CPUS
 
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
@@ -843,7 +843,7 @@ config ENTRY_OFFSET
 
 config ROMIMAGE_MMCIF
 	bool "Include MMCIF loader in romImage (EXPERIMENTAL)"
-	depends on CPU_SUBTYPE_SH7724 && EXPERIMENTAL
+	depends on CPU_SUBTYPE_SH7724
 	help
 	  Say Y here to include experimental MMCIF loading code in
 	  romImage. With this enabled it is possible to write the romImage
@@ -929,7 +929,6 @@ source "fs/Kconfig.binfmt"
 endmenu
 
 menu "Power management options (EXPERIMENTAL)"
-depends on EXPERIMENTAL
 
 source "kernel/power/Kconfig"
 
diff --git a/arch/sh/Kconfig.cpu b/arch/sh/Kconfig.cpu
index 770ff2d..05b518e 100644
--- a/arch/sh/Kconfig.cpu
+++ b/arch/sh/Kconfig.cpu
@@ -33,7 +33,7 @@ config SH64_FPU_DENORM_FLUSH
 config SH_FPU_EMU
 	def_bool n
 	prompt "FPU emulation support"
-	depends on !SH_FPU && EXPERIMENTAL
+	depends on !SH_FPU
 	help
 	  Selecting this option will enable support for software FPU emulation.
 	  Most SH-3 users will want to say Y here, whereas most SH-4 users will
@@ -68,7 +68,6 @@ config SH_STORE_QUEUES
 
 config SPECULATIVE_EXECUTION
 	bool "Speculative subroutine return"
-	depends on EXPERIMENTAL
 	depends on CPU_SUBTYPE_SH7780 || CPU_SUBTYPE_SH7785 || CPU_SUBTYPE_SH7786
 	help
 	  This enables support for a speculative instruction fetch for
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index cb8f992..533ccbb 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -83,7 +83,7 @@ config 32BIT
 
 config PMB
 	bool "Support 32-bit physical addressing through PMB"
-	depends on MMU && EXPERIMENTAL && CPU_SH4A && !CPU_SH4AL_DSP
+	depends on MMU && CPU_SH4A && !CPU_SH4AL_DSP
 	select 32BIT
 	select UNCACHED_MAPPING
 	help
@@ -110,7 +110,7 @@ config VSYSCALL
 
 config NUMA
 	bool "Non Uniform Memory Access (NUMA) Support"
-	depends on MMU && SYS_SUPPORTS_NUMA && EXPERIMENTAL
+	depends on MMU && SYS_SUPPORTS_NUMA
 	default n
 	help
 	  Some SH systems have many various memories scattered around
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1EKVKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:10:16 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755664Ab1EKVGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:44 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] C6X: add toplevel configury and makefile
Date: Wed, 11 May 2011 16:13:54 -0400
Message-Id: <1305144843-5058-8-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-7-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/Kconfig       |  213 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/c6x/Kconfig.debug |   25 ++++++
 arch/c6x/Makefile      |   33 ++++++++
 3 files changed, 271 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/Kconfig
 create mode 100644 arch/c6x/Kconfig.debug
 create mode 100644 arch/c6x/Makefile

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
new file mode 100644
index 0000000..d4881c1
--- /dev/null
+++ b/arch/c6x/Kconfig
@@ -0,0 +1,213 @@
+#
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+#
+
+config TMS320C6X
+	def_bool y
+	select GENERIC_IRQ_SHOW
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
+	select GENERIC_FIND_LAST_BIT
+	select GENERIC_FIND_BIT_LE
+
+config MMU
+	def_bool n
+
+config ZONE_DMA
+	def_bool y
+
+config SBUS
+	def_bool n
+
+config FPU
+	def_bool n
+
+config HIGHMEM
+	def_bool n
+
+config NUMA
+	def_bool n
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config RWSEM_XCHGADD_ALGORITHM
+	def_bool n
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_TIME
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config GENERIC_CLOCKEVENTS_BUILD
+	def_bool y
+	depends on GENERIC_CLOCKEVENTS
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+
+config GENERIC_BUG
+	def_bool y
+
+config COMMON_CLKDEV
+	def_bool y
+
+config BIG_KERNEL
+	bool "Build a big kernel"
+	help
+	  The C6X function call instruction has a limited range of +/- 2MiB.
+	  This is sufficient for most kernels, but some kernel configurations
+	  with lots of compiled-in functionality may require a larger range
+	  for function calls. Use this option to have the compiler generate
+	  function calls with 32-bit range. This will make the kernel both
+	  larger and slower.
+
+	  If unsure, say N.
+
+config XIP_KERNEL
+	bool "Kernel Execute-In-Place"
+	help
+	  Execute-In-Place allows the kernel to run from non-volatile storage
+	  directly addressable by the CPU, such as NOR flash. This saves RAM
+	  space since the text section of the kernel is not loaded from flash
+	  to RAM.  Read-write sections, such as the data section and stack,
+	  are still copied to RAM.  The XIP kernel is not compressed since
+	  it has to run directly from flash, so it will take more space to
+	  store it.  The flash address used to link the kernel object files,
+	  and for storing it, is configuration dependent. Therefore, if you
+	  say Y here, you must know the proper physical address where to
+	  store the kernel image depending on your own flash memory usage.
+
+	  If unsure, say N.
+
+config XIP_KERNEL_TEXT_ADDR
+	hex "XIP Kernel Physical Location"
+	depends on XIP_KERNEL
+	default "0xB0000000"
+	help
+	  This is the physical address where the kernel image will be
+	  stored.  This address is dependent on your own platform
+	  device constraints.
+
+source "init/Kconfig"
+
+# Use the generic interrupt handling code in kernel/irq/
+
+source "kernel/Kconfig.freezer"
+
+config CMDLINE
+	string "Kernel command line"
+	default "console=ttyS0,57600"
+
+config CPU_BIG_ENDIAN
+	bool "Build big-endian kernel"
+	help
+	  Say Y if you plan on running a kernel in big-endian mode.
+	  Note that your board must be properly built and your board
+	  port must properly enable any big-endian related features
+	  of your chipset/board/processor.
+
+config FORCE_MAX_ZONEORDER
+	int
+	default "13"
+
+menu "Processor type and features"
+
+config TMS320C64XPLUS
+	bool "TMS320C64X+"
+	select SERIAL_CORE
+
+config HVC_C6X
+	bool "HVC console (CIO)"
+	select HVC_DRIVER
+	def_bool y
+
+source "arch/c6x/platforms/Kconfig"
+
+config USE_RT_TIMER
+	bool "Compensate for lost ticks"
+	default n
+
+config SGMII
+	bool "Ethernet SGMII support"
+	default n
+
+config TMS320C64X_GEMAC_0
+	bool "First Ethernet interface"
+	depends on TMS320C64X_GEMAC && SOC_TMS320C6472
+	default y
+
+config TMS320C64X_GEMAC_1
+	bool "Second Ethernet interface"
+	depends on TMS320C64X_GEMAC && SOC_TMS320C6472
+	default n
+
+config TMS320C6X_CACHES_ON
+	bool "L2 cache support"
+	default y
+
+config KERNEL_RAM_BASE_ADDRESS
+	hex "Virtual address of memory base"
+	default 0xe0000000 if SOC_TMS320C6455
+	default 0xe0000000 if SOC_TMS320C6457
+	default 0xe0000000 if SOC_TMS320C6472
+	default 0x80000000
+
+source "mm/Kconfig"
+
+source "kernel/Kconfig.preempt"
+
+source "kernel/Kconfig.hz"
+source "kernel/time/Kconfig"
+
+endmenu
+
+menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
+
+config PCI
+	bool "PCI support"
+	help
+	  Support for PCI bus.
+endmenu
+
+menu "Executable file formats"
+
+source "fs/Kconfig.binfmt"
+
+endmenu
+
+menu "Power management options"
+
+config PM
+	bool "Power Management support"
+	help
+	  Support processor power management modes
+
+endmenu
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
+
+source "arch/c6x/Kconfig.debug"
+
diff --git a/arch/c6x/Kconfig.debug b/arch/c6x/Kconfig.debug
new file mode 100644
index 0000000..49b18b2
--- /dev/null
+++ b/arch/c6x/Kconfig.debug
@@ -0,0 +1,25 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config EARLY_PRINTK
+	bool "Early printk"
+	default n
+	help
+	  This option enables special console drivers which allow the kernel
+	  to print messages very early in the bootup process.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. After enabling this
+	  feature, you must add "earlyprintk=hvc" to the command line (bootargs).
+
+config ACCESS_CHECK
+	bool "Check the user pointer address"
+	default y
+	help
+	  Usually the pointer transfer from user space is checked to see if its
+	  address is in the kernel space.
+
+	  Say N here to disable that check to improve the performance.
+
+endmenu
diff --git a/arch/c6x/Makefile b/arch/c6x/Makefile
new file mode 100644
index 0000000..3561875
--- /dev/null
+++ b/arch/c6x/Makefile
@@ -0,0 +1,33 @@
+#
+# linux/arch/c6x/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+cflags-y := -D__linux__ -D__TMS320C6X__
+
+cflags-$(CONFIG_TMS320C64XPLUS) += -D__TMS320C6XPLUS__ -march=c64x+ -msdata=none -mno-dsbt
+
+cflags-$(CONFIG_BIG_KERNEL) += -mlong-calls
+
+CFLAGS_MODULE   += -mlong-calls
+
+KBUILD_CPPFLAGS += -I$(srctree)/arch/c6x/platforms/include -I$(obj)/arch/c6x/kernel
+
+KBUILD_CFLAGS   += $(cflags-y)
+KBUILD_AFLAGS   += $(cflags-y)
+
+ifdef CONFIG_CPU_BIG_ENDIAN
+KBUILD_CFLAGS   += -mbig-endian
+KBUILD_AFLAGS	+= -mbig-endian
+LINKFLAGS	+= -mbig-endian
+KBUILD_LDFLAGS	+= -mbig-endian
+LDFLAGS	+= -EB
+endif
+
+head-y		:= arch/c6x/kernel/head.o
+core-y		+= arch/c6x/kernel/ arch/c6x/mm/ arch/c6x/platforms/
+libs-y		+= arch/c6x/lib/
+
-- 
1.6.2.5


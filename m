Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030296Ab2GFVHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:07:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34078 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab2GFVHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:07:33 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 35/36] AArch64: Build infrastructure
Date: Fri,  6 Jul 2012 22:06:16 +0100
Message-Id: <1341608777-12982-36-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:41.0729 (UTC) FILETIME=[618D8910:01CD5BBB]
X-MC-Unique: 112070622064701201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66L7nCA005335

This patch adds Makefile and Kconfig files required for building an
AArch64 kernel.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/Kconfig              |  263 +++++++++++++++++++++++++++++++++++++
 arch/aarch64/Kconfig.debug        |   44 ++++++
 arch/aarch64/Makefile             |   71 ++++++++++
 arch/aarch64/boot/.gitignore      |    2 +
 arch/aarch64/boot/Makefile        |   38 ++++++
 arch/aarch64/boot/install.sh      |   52 ++++++++
 arch/aarch64/include/asm/prom.h   |    1 +
 arch/aarch64/kernel/.gitignore    |    1 +
 arch/aarch64/kernel/Makefile      |   27 ++++
 arch/aarch64/kernel/vmlinux.lds.S |  146 ++++++++++++++++++++
 arch/aarch64/mm/Kconfig           |    5 +
 arch/aarch64/mm/Makefile          |    6 +
 init/Kconfig                      |    3 +-
 lib/Kconfig.debug                 |    6 +-
 14 files changed, 662 insertions(+), 3 deletions(-)
 create mode 100644 arch/aarch64/Kconfig
 create mode 100644 arch/aarch64/Kconfig.debug
 create mode 100644 arch/aarch64/Makefile
 create mode 100644 arch/aarch64/boot/.gitignore
 create mode 100644 arch/aarch64/boot/Makefile
 create mode 100644 arch/aarch64/boot/install.sh
 create mode 100644 arch/aarch64/include/asm/prom.h
 create mode 100644 arch/aarch64/kernel/.gitignore
 create mode 100644 arch/aarch64/kernel/Makefile
 create mode 100644 arch/aarch64/kernel/vmlinux.lds.S
 create mode 100644 arch/aarch64/mm/Kconfig
 create mode 100644 arch/aarch64/mm/Makefile

diff --git a/arch/aarch64/Kconfig b/arch/aarch64/Kconfig
new file mode 100644
index 0000000..060edb4
--- /dev/null
+++ b/arch/aarch64/Kconfig
@@ -0,0 +1,263 @@
+config AARCH64
+	def_bool y
+	select OF
+	select OF_EARLY_FLATTREE
+	select IRQ_DOMAIN
+	select HAVE_AOUT
+	select HAVE_DMA_ATTRS
+	select HAVE_DMA_API_DEBUG
+	select HAVE_IDE
+	select HAVE_MEMBLOCK
+	select RTC_LIB
+	select SYS_SUPPORTS_APM_EMULATION
+	select HAVE_GENERIC_DMA_COHERENT
+	select GENERIC_IOMAP
+	select HAVE_IRQ_WORK
+	select HAVE_PERF_EVENTS
+	select HAVE_ARCH_TRACEHOOK
+	select PERF_USE_VMALLOC
+	select HAVE_HW_BREAKPOINT if PERF_EVENTS
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select HAVE_SPARSE_IRQ
+	select SPARSE_IRQ
+	select GENERIC_IRQ_SHOW
+	select GENERIC_SMP_IDLE_THREAD
+	help
+	  ARM 64-bit (AArch64) Linux support.
+
+config 64BIT
+	def_bool AARCH64
+
+config ARCH_PHYS_ADDR_T_64BIT
+	def_bool AARCH64
+
+config HAVE_PWM
+	bool
+
+config SYS_SUPPORTS_APM_EMULATION
+	bool
+
+config NO_IOPORT
+	def_bool y
+
+config GENERIC_GPIO
+	bool
+
+config GENERIC_TIME_VSYSCALL
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config STACKTRACE_SUPPORT
+	def_bool y
+
+config LOCKDEP_SUPPORT
+	def_bool y
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool y
+
+config HARDIRQS_SW_RESEND
+	def_bool y
+
+config GENERIC_IRQ_PROBE
+	def_bool y
+
+config GENERIC_LOCKBREAK
+	def_bool y
+	depends on SMP && PREEMPT
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+config ARCH_HAS_ILOG2_U32
+	bool
+
+config ARCH_HAS_ILOG2_U64
+	bool
+
+config ARCH_HAS_CPUFREQ
+	bool
+	help
+	  Internal node to signify that the ARCH has CPUFREQ support
+	  and that the relevant menu configurations are displayed for
+	  it.
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_CSUM
+        def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+
+config ZONE_DMA
+	bool
+
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool y
+
+config NEED_DMA_MAP_STATE
+	def_bool y
+
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
+config SWIOTLB
+	def_bool y
+
+config IOMMU_HELPER
+	def_bool SWIOTLB
+
+source "init/Kconfig"
+
+source "kernel/Kconfig.freezer"
+
+menu "System Type"
+
+source "arch/aarch64/mm/Kconfig"
+
+endmenu
+
+menu "Bus support"
+
+config ARM_AMBA
+	bool
+
+endmenu
+
+menu "Kernel Features"
+
+source "kernel/time/Kconfig"
+
+config AARCH64_64K_PAGES
+	bool "Enable 64KB pages support"
+	help
+	  This feature enables 64KB pages support (4KB by default)
+	  allowing only two levels of page tables and faster TLB
+	  look-up. AArch32 emulation is not available when this feature
+	  is enabled.
+
+config SMP
+	bool "Symmetric Multi-Processing"
+	depends on GENERIC_CLOCKEVENTS
+	select USE_GENERIC_SMP_HELPERS
+	help
+	  This enables support for systems with more than one CPU.  If
+	  you say N here, the kernel will run on single and
+	  multiprocessor machines, but will use only one CPU of a
+	  multiprocessor machine. If you say Y here, the kernel will run
+	  on many, but not all, single processor machines. On a single
+	  processor machine, the kernel will run faster if you say N
+	  here.
+
+	  If you don't know what to do here, say N.
+
+config NR_CPUS
+	int "Maximum number of CPUs (2-32)"
+	range 2 32
+	depends on SMP
+	default "4"
+
+source kernel/Kconfig.preempt
+
+config HZ
+	int
+	default 100
+
+config ARCH_HAS_HOLES_MEMORYMODEL
+	def_bool y if SPARSEMEM
+
+config ARCH_SPARSEMEM_ENABLE
+	def_bool y
+	select SPARSEMEM_VMEMMAP_ENABLE
+
+config ARCH_SPARSEMEM_DEFAULT
+	def_bool ARCH_SPARSEMEM_ENABLE
+
+config ARCH_SELECT_MEMORY_MODEL
+	def_bool ARCH_SPARSEMEM_ENABLE
+
+config HAVE_ARCH_PFN_VALID
+	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
+
+config HW_PERF_EVENTS
+	bool "Enable hardware performance counter support for perf events"
+	depends on PERF_EVENTS
+	default y
+	help
+	  Enable hardware performance counter support for perf events. If
+	  disabled, perf events will use software events only.
+
+source "mm/Kconfig"
+
+endmenu
+
+menu "Boot options"
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+	help
+	  Provide a set of default command-line options at build time by
+	  entering them here. As a minimum, you should specify the the
+	  root device (e.g. root=/dev/nfs).
+
+config CMDLINE_FORCE
+	bool "Always use the default kernel command string"
+	help
+	  Always use the default kernel command string, even if the boot
+	  loader passes other arguments to the kernel.
+	  This is useful if you cannot or don't want to change the
+	  command-line options your boot loader passes to the kernel.
+
+endmenu
+
+menu "Userspace binary formats"
+
+source "fs/Kconfig.binfmt"
+
+config AARCH32_EMULATION
+	bool "Kernel support for 32-bit EL0"
+	depends on !AARCH64_64K_PAGES
+	select COMPAT_BINFMT_ELF
+	help
+	  This option enables support for a 32-bit EL0 running under a 64-bit
+	  kernel at EL1. AArch32-specific components such as system calls,
+	  the user helper functions, VFP support and the ptrace interface are
+	  handled appropriately by the kernel.
+
+	  If you want to execute 32-bit userspace applications, say Y.
+
+config COMPAT
+	def_bool y
+	depends on AARCH32_EMULATION
+
+config SYSVIPC_COMPAT
+	def_bool y
+	depends on COMPAT && SYSVIPC
+
+endmenu
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "arch/aarch64/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff --git a/arch/aarch64/Kconfig.debug b/arch/aarch64/Kconfig.debug
new file mode 100644
index 0000000..b8cdcd1
--- /dev/null
+++ b/arch/aarch64/Kconfig.debug
@@ -0,0 +1,44 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config FRAME_POINTER
+	bool
+	default y
+
+config DEBUG_USER
+	bool "Verbose user fault messages"
+	help
+	  When a user program crashes due to an exception, the kernel can
+	  print a brief message explaining what the problem was. This is
+	  sometimes helpful for debugging but serves no purpose on a
+	  production system. Most people should say N here.
+
+	  In addition, you need to pass user_debug=N on the kernel command
+	  line to enable this feature.  N consists of the sum of:
+
+	      1 - undefined instruction events
+	      2 - system calls
+	      4 - invalid data aborts
+	      8 - SIGSEGV faults
+	     16 - SIGBUS faults
+
+config DEBUG_ERRORS
+	bool "Verbose kernel error messages"
+	depends on DEBUG_KERNEL
+	help
+	  This option controls verbose debugging information which can be
+	  printed when the kernel detects an internal error. This debugging
+	  information is useful to kernel hackers when tracking down problems,
+	  but mostly meaningless to other people. It's safe to say Y unless
+	  you are concerned with the code size or don't want to see these
+	  messages.
+
+config DEBUG_STACK_USAGE
+	bool "Enable stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T output.
+
+endmenu
diff --git a/arch/aarch64/Makefile b/arch/aarch64/Makefile
new file mode 100644
index 0000000..5f22c9e
--- /dev/null
+++ b/arch/aarch64/Makefile
@@ -0,0 +1,71 @@
+#
+# arch/aarch64/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 1995-2001 by Russell King
+
+LDFLAGS_vmlinux	:=-p --no-undefined -X
+CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
+OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
+GZFLAGS		:=-9
+
+LIBGCC 		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+
+KBUILD_DEFCONFIG := vexpress_defconfig
+
+KBUILD_CFLAGS	+= -mgeneral-regs-only
+KBUILD_CPPFLAGS	+= -mlittle-endian
+AS		+= -EL
+LD		+= -EL
+
+comma = ,
+
+CHECKFLAGS	+= -D__aarch64__
+
+# Default value
+head-y		:= arch/aarch64/kernel/head.o
+
+# The byte offset of the kernel image in RAM from the start of RAM.
+TEXT_OFFSET := 0x00080000
+
+export	TEXT_OFFSET GZFLAGS
+
+core-y		+= arch/aarch64/kernel/ arch/aarch64/mm/
+libs-y		:= arch/aarch64/lib/ $(libs-y)
+libs-y		+= $(LIBGCC)
+
+# Default target when executing plain make
+KBUILD_IMAGE := Image.gz
+
+all:	$(KBUILD_IMAGE)
+
+boot := arch/aarch64/boot
+
+Image Image.gz: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
+zinstall install: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
+
+%.dtb:
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
+# We use MRPROPER_FILES and CLEAN_FILES now
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+define archhelp
+  echo  '* Image.gz      - Compressed kernel image (arch/$(ARCH)/boot/Image.gz)'
+  echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
+  echo  '  install       - Install uncompressed kernel'
+  echo  '  zinstall      - Install compressed kernel'
+  echo  '                  Install using (your) ~/bin/installkernel or'
+  echo  '                  (distribution) /sbin/installkernel or'
+  echo  '                  install to $$(INSTALL_PATH) and run lilo'
+endef
diff --git a/arch/aarch64/boot/.gitignore b/arch/aarch64/boot/.gitignore
new file mode 100644
index 0000000..8dab0bb
--- /dev/null
+++ b/arch/aarch64/boot/.gitignore
@@ -0,0 +1,2 @@
+Image
+Image.gz
diff --git a/arch/aarch64/boot/Makefile b/arch/aarch64/boot/Makefile
new file mode 100644
index 0000000..b1bc3bd
--- /dev/null
+++ b/arch/aarch64/boot/Makefile
@@ -0,0 +1,38 @@
+#
+# arch/aarch64/boot/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2012, ARM Ltd.
+# Author: Will Deacon <will.deacon@arm.com>
+#
+# Based on the ia64 boot/Makefile.
+#
+
+targets := Image Image.gz
+
+$(obj)/Image: vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo '  Kernel: $@ is ready'
+
+$(obj)/Image.gz: $(obj)/Image FORCE
+	$(call if_changed,gzip)
+	@echo '  Kernel: $@ is ready'
+
+$(obj)/%.dtb: $(src)/dts/%.dts
+	$(call cmd,dtc)
+
+install: $(obj)/Image
+	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
+	$(obj)/Image System.map "$(INSTALL_PATH)"
+
+zinstall: $(obj)/Image.gz
+	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
+	$(obj)/Image.gz System.map "$(INSTALL_PATH)"
+
+clean-files += *.dtb
diff --git a/arch/aarch64/boot/install.sh b/arch/aarch64/boot/install.sh
new file mode 100644
index 0000000..6717ae5
--- /dev/null
+++ b/arch/aarch64/boot/install.sh
@@ -0,0 +1,52 @@
+#!/bin/sh
+#
+# arch/aarch64/boot/install.sh
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 1995 by Linus Torvalds
+#
+# Adapted from code in arch/i386/boot/Makefile by H. Peter Anvin
+# Adapted from code in arch/i386/boot/install.sh by Russell King
+#
+# "make install" script for aarch64 architecture
+#
+# Arguments:
+#   $1 - kernel version
+#   $2 - kernel image file
+#   $3 - kernel map file
+#   $4 - default install path (blank if root directory)
+#
+
+# User may have a custom install script
+if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
+if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
+
+if [ "$(basename $2)" = "Image.gz" ]; then
+# Compressed install
+  echo "Installing compressed kernel"
+  base=vmlinuz
+else
+# Normal install
+  echo "Installing normal kernel"
+  base=vmlinux
+fi
+
+if [ -f $4/$base-$1 ]; then
+  mv $4/$base-$1 $4/$base-$1.old
+fi
+cat $2 > $4/$base-$1
+
+# Install system map file
+if [ -f $4/System.map-$1 ]; then
+  mv $4/System.map-$1 $4/System.map-$1.old
+fi
+cp $3 $4/System.map-$1
+
+if [ -x /sbin/loadmap ]; then
+  /sbin/loadmap
+else
+  echo "You have to install it yourself"
+fi
diff --git a/arch/aarch64/include/asm/prom.h b/arch/aarch64/include/asm/prom.h
new file mode 100644
index 0000000..68b90e6
--- /dev/null
+++ b/arch/aarch64/include/asm/prom.h
@@ -0,0 +1 @@
+/* Empty for now */
diff --git a/arch/aarch64/kernel/.gitignore b/arch/aarch64/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/aarch64/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
diff --git a/arch/aarch64/kernel/Makefile b/arch/aarch64/kernel/Makefile
new file mode 100644
index 0000000..92c8a12
--- /dev/null
+++ b/arch/aarch64/kernel/Makefile
@@ -0,0 +1,27 @@
+#
+# Makefile for the linux kernel.
+#
+
+CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+
+# Object file lists.
+aarch64-obj-y		:= debug-monitors.o elf.o entry.o irq.o	fpsimd.o	\
+			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
+			   sys.o stacktrace.o time.o traps.o io.o vdso.o
+
+aarch64-obj-$(CONFIG_AARCH32_EMULATION)	+= sys32.o kuser32.o signal32.o 	\
+					   sys_compat.o
+aarch64-obj-$(CONFIG_MODULES)		+= aarch64ksyms.o module.o
+aarch64-obj-$(CONFIG_SMP)		+= smp.o
+aarch64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
+aarch64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
+
+obj-y					+= $(aarch64-obj-y) vdso/
+obj-m					+= $(aarch64-obj-m)
+head-y					:= head.o
+extra-y					:= $(head-y) vmlinux.lds
+
+# vDSO - this must be built first to generate the symbol offsets
+$(call objectify,$(aarch64-obj-y)): $(obj)/vdso/vdso-offsets.h
+$(obj)/vdso/vdso-offsets.h: $(obj)/vdso
diff --git a/arch/aarch64/kernel/vmlinux.lds.S b/arch/aarch64/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..5eab87b
--- /dev/null
+++ b/arch/aarch64/kernel/vmlinux.lds.S
@@ -0,0 +1,146 @@
+/*
+ * ld script to make ARM Linux kernel
+ * taken from the i386 version by Russell King
+ * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ */
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/thread_info.h>
+#include <asm/memory.h>
+#include <asm/page.h>
+
+#define PROC_INFO							\
+	VMLINUX_SYMBOL(__proc_info_begin) = .;				\
+	*(.proc.info.init)						\
+	VMLINUX_SYMBOL(__proc_info_end) = .;
+
+#define ARM_CPU_DISCARD(x)	x
+#define ARM_CPU_KEEP(x)
+
+#define ARM_EXIT_KEEP(x)
+#define ARM_EXIT_DISCARD(x)	x
+
+OUTPUT_ARCH(aarch64)
+ENTRY(stext)
+
+jiffies = jiffies_64;
+
+SECTIONS
+{
+	/*
+	 * XXX: The linker does not define how output sections are
+	 * assigned to input sections when there are multiple statements
+	 * matching the same input section name.  There is no documented
+	 * order of matching.
+	 */
+	/DISCARD/ : {
+		ARM_EXIT_DISCARD(EXIT_TEXT)
+		ARM_EXIT_DISCARD(EXIT_DATA)
+		EXIT_CALL
+		*(.discard)
+		*(.discard.*)
+	}
+
+	. = PAGE_OFFSET + TEXT_OFFSET;
+
+	.head.text : {
+		_text = .;
+		HEAD_TEXT
+	}
+	.text : {			/* Real text segment		*/
+		_stext = .;		/* Text and read-only data	*/
+			*(.smp.pen.text)
+			__exception_text_start = .;
+			*(.exception.text)
+			__exception_text_end = .;
+			IRQENTRY_TEXT
+			TEXT_TEXT
+			SCHED_TEXT
+			LOCK_TEXT
+			*(.fixup)
+			*(.gnu.warning)
+		. = ALIGN(16);
+		*(.got)			/* Global offset table		*/
+			ARM_CPU_KEEP(PROC_INFO)
+	}
+
+	RO_DATA(PAGE_SIZE)
+
+	_etext = .;			/* End of text and rodata section */
+
+	. = ALIGN(PAGE_SIZE);
+	__init_begin = .;
+
+	INIT_TEXT_SECTION(8)
+	.exit.text : {
+		ARM_EXIT_KEEP(EXIT_TEXT)
+	}
+	. = ALIGN(16);
+	.init.proc.info : {
+		ARM_CPU_DISCARD(PROC_INFO)
+	}
+	. = ALIGN(16);
+	.init.data : {
+		INIT_DATA
+		INIT_SETUP(16)
+		INIT_CALLS
+		CON_INITCALL
+		SECURITY_INITCALL
+		INIT_RAM_FS
+	}
+	.exit.data : {
+		ARM_EXIT_KEEP(EXIT_DATA)
+	}
+
+	PERCPU_SECTION(64)
+
+	__init_end = .;
+	. = ALIGN(THREAD_SIZE);
+	__data_loc = .;
+
+	.data : AT(__data_loc) {
+		_data = .;		/* address in memory */
+		_sdata = .;
+
+		/*
+		 * first, the init task union, aligned
+		 * to an 8192 byte boundary.
+		 */
+		INIT_TASK_DATA(THREAD_SIZE)
+		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(64)
+		READ_MOSTLY_DATA(64)
+
+		/*
+		 * The exception fixup table (might need resorting at runtime)
+		 */
+		. = ALIGN(32);
+		__start___ex_table = .;
+		*(__ex_table)
+		__stop___ex_table = .;
+
+		/*
+		 * and the usual data section
+		 */
+		DATA_DATA
+		CONSTRUCTORS
+
+		_edata = .;
+	}
+	_edata_loc = __data_loc + SIZEOF(.data);
+
+	NOTES
+
+	BSS_SECTION(0, 0, 0)
+	_end = .;
+
+	STABS_DEBUG
+	.comment 0 : { *(.comment) }
+}
+
+/*
+ * These must never be empty
+ * If you have to comment these two assert statements out, your
+ * binutils is too old (for other reasons as well)
+ */
+ASSERT((__proc_info_end - __proc_info_begin), "missing CPU support")
diff --git a/arch/aarch64/mm/Kconfig b/arch/aarch64/mm/Kconfig
new file mode 100644
index 0000000..8e94e52
--- /dev/null
+++ b/arch/aarch64/mm/Kconfig
@@ -0,0 +1,5 @@
+config MMU
+	def_bool y
+
+config CPU_64
+	def_bool y
diff --git a/arch/aarch64/mm/Makefile b/arch/aarch64/mm/Makefile
new file mode 100644
index 0000000..81a9d8b
--- /dev/null
+++ b/arch/aarch64/mm/Makefile
@@ -0,0 +1,6 @@
+obj-y				:= dma-mapping.o extable.o fault.o init.o \
+				   cache.o copypage.o flush.o \
+				   ioremap.o mmap.o pgd.o mmu.o \
+				   context.o tlb.o proc.o
+
+obj-$(CONFIG_MODULES)		+= proc-syms.o
diff --git a/init/Kconfig b/init/Kconfig
index d07dcf9..bc49205 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1138,7 +1138,8 @@ menuconfig EXPERT
 
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
-	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
+	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION) \
+		|| AARCH32_EMULATION
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ff5bdee..c424793 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -452,7 +452,8 @@ config SLUB_STATS
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
 	depends on DEBUG_KERNEL && EXPERIMENTAL && \
-		(X86 || ARM || PPC || MIPS || S390 || SPARC64 || SUPERH || MICROBLAZE || TILE)
+		(X86 || ARM || PPC || MIPS || S390 || SPARC64 || SUPERH || \
+		 MICROBLAZE || TILE || AARCH64)
 
 	select DEBUG_FS
 	select STACKTRACE if STACKTRACE_SUPPORT
@@ -739,7 +740,8 @@ config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
-		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || TILE
+		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || \
+		   TILE || AARCH64
 	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number


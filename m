Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0LYSmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 13:42:09 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:46529 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab0LYSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 13:42:05 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: =?gb2312?B?0anMziC53A==?= <guanxuetao@mprc.pku.edu.cn>
Subject: [PATCHv1 01/12] unicore32 core architecture: build infrastructure
Date: Sun, 26 Dec 2010 02:41:58 +0800
Message-ID: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcukYz57n2ogBs3DQyGg4EsCNqUS6g==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

This patch implements build infrastructure.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/.gitignore               |   70 +++++++++
 arch/unicore32/Kconfig                  |  258 +++++++++++++++++++++++++++++++
 arch/unicore32/Kconfig.debug            |   86 ++++++++++
 arch/unicore32/Makefile                 |  153 ++++++++++++++++++
 arch/unicore32/configs/debug_defconfig  |  211 +++++++++++++++++++++++++
 arch/unicore32/configs/nb0916_defconfig |  203 ++++++++++++++++++++++++
 arch/unicore32/include/asm/Kbuild       |    4 +
 arch/unicore32/include/asm/linkage.h    |   22 +++
 arch/unicore32/kernel/Makefile          |   34 ++++
 arch/unicore32/kernel/asm-offsets.c     |  112 +++++++++++++
 arch/unicore32/kernel/ksyms.c           |   87 +++++++++++
 arch/unicore32/kernel/module.c          |  152 ++++++++++++++++++
 arch/unicore32/kernel/vmlinux.lds.S     |  120 ++++++++++++++
 firmware/Makefile                       |    2 +-
 14 files changed, 1513 insertions(+), 1 deletions(-)

diff --git a/arch/unicore32/.gitignore b/arch/unicore32/.gitignore
new file mode 100644
index 0000000..f0fc866
--- /dev/null
+++ b/arch/unicore32/.gitignore
@@ -0,0 +1,70 @@
+#
+# Generated include files
+#
+include/asm/atomic.h
+include/asm/auxvec.h
+include/asm/bitsperlong.h
+include/asm/bug.h
+include/asm/bugs.h
+include/asm/cputime.h
+include/asm/current.h
+include/asm/device.h
+include/asm/emergency-restart.h
+include/asm/errno.h
+include/asm/fb.h
+include/asm/fcntl.h
+include/asm/hardirq.h
+include/asm/hw_irq.h
+include/asm/ioctl.h
+include/asm/ioctls.h
+include/asm/ipcbuf.h
+include/asm/irq_regs.h
+include/asm/kdebug.h
+include/asm/kmap_types.h
+include/asm/local.h
+include/asm/mman.h
+include/asm/module.h
+include/asm/msgbuf.h
+include/asm/param.h
+include/asm/parport.h
+include/asm/percpu.h
+include/asm/poll.h
+include/asm/posix_types.h
+include/asm/resource.h
+include/asm/scatterlist.h
+include/asm/sections.h
+include/asm/sembuf.h
+include/asm/serial.h
+include/asm/shmbuf.h
+include/asm/shmparam.h
+include/asm/siginfo.h
+include/asm/signal.h
+include/asm/socket.h
+include/asm/sockios.h
+include/asm/statfs.h
+include/asm/termbits.h
+include/asm/termios.h
+include/asm/topology.h
+include/asm/types.h
+include/asm/ucontext.h
+include/asm/unaligned.h
+include/asm/user.h
+include/asm/vga.h
+include/asm/xor.h
+#
+# Generated ld script file
+#
+kernel/vmlinux.lds
+#
+# Generated images in boot
+#
+boot/Image
+boot/zImage
+boot/uImage
+#
+# Generated files in boot/compressed
+#
+boot/compressed/piggy.S
+boot/compressed/piggy.gzip
+boot/compressed/vmlinux
+boot/compressed/vmlinux.lds
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
new file mode 100644
index 0000000..da59420
--- /dev/null
+++ b/arch/unicore32/Kconfig
@@ -0,0 +1,258 @@
+config UNICORE32
+	bool
+	default y
+	select HAVE_MEMBLOCK
+	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_DMA_ATTRS
+	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_BZIP2
+	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_LZMA
+	select GENERIC_FIND_FIRST_BIT
+	select ARCH_WANT_FRAME_POINTERS
+	help
+	  UniCore-32 is 32-bit Instruction Set Architecture,
+	  including a series of low-power-consumption RISC chip
+	  designs licensed by PKUnity Ltd.
+	  Please see web page at <http://www.pkunity.com/>.
+
+config HAVE_PWM
+	bool
+
+config GENERIC_GPIO
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	bool
+
+config NO_IOPORT
+	bool
+
+config GENERIC_HARDIRQS
+	bool
+	default y
+
+config STACKTRACE_SUPPORT
+	bool
+	default y
+
+config HAVE_LATENCYTOP_SUPPORT
+	bool
+	default y
+
+config LOCKDEP_SUPPORT
+	bool
+	default y
+
+config GENERIC_IRQ_PROBE
+	bool
+	default y
+
+config RWSEM_GENERIC_SPINLOCK
+	bool
+	default y
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
+
+config GENERIC_HWEIGHT
+	bool
+	default y
+
+config GENERIC_CALIBRATE_DELAY
+	bool
+	default y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+
+config NEED_DMA_MAP_STATE
+       def_bool y
+
+config REALMODE
+	bool
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
+source "init/Kconfig"
+
+source "kernel/Kconfig.freezer"
+
+menu "System Type"
+
+config MMU
+	def_bool y
+
+config ARCH_FPGA
+	bool
+
+choice
+	prompt "PKUnity system type"
+	default ARCH_PUV3
+
+	config ARCH_PUV3
+	bool "PKUnity v3 (SuperK)"
+	select CPU_UCV2
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
+	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_HAS_CPUFREQ
+
+endchoice
+
+# CONFIGs for ARCH_PUV3
+
+if ARCH_PUV3
+
+choice
+	prompt "Board Selection"
+	default PUV3_DB0913
+
+config PUV3_FPGA_DLX200
+	select ARCH_FPGA
+	bool "FPGA board"
+
+config PUV3_DB0913
+	bool "DEBUG board (0913)"
+
+config PUV3_NB0916
+	bool "NetBook board (0916)"
+	select HAVE_PWM
+
+config PUV3_SMW0919
+	bool "Security Mini-Workstation board (0919)"
+
+endchoice
+
+config PUV3_PM
+	bool
+	depends on !ARCH_FPGA
+	default y
+
+endif
+
+source "arch/unicore32/mm/Kconfig"
+
+comment "Floating poing support"
+
+config UNICORE_FPU_F64
+	bool "UniCore-FPU (F64) support"
+	depends on !ARCH_FPGA
+	default y
+
+endmenu
+
+menu "Bus support"
+
+config PCI
+	bool "PCI Support"
+	help
+	  Find out whether you have a PCI motherboard. PCI is the name of a
+	  bus system, i.e. the way the CPU talks to the other stuff inside
+	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
+	  VESA. If you have PCI, say Y, otherwise N.
+
+source "drivers/pci/Kconfig"
+
+source "drivers/pcmcia/Kconfig"
+
+endmenu
+
+menu "Kernel Features"
+
+source "kernel/time/Kconfig"
+
+source "kernel/Kconfig.preempt"
+
+source "kernel/Kconfig.hz"
+
+source "mm/Kconfig"
+
+config LEDS
+	bool "CPU heartbeat LEDs"
+	depends on GENERIC_GPIO
+	default y
+
+config ALIGNMENT_TRAP
+	bool
+	default y
+	help
+	  Unicore processors can not fetch/store information which is not
+	  naturally aligned on the bus, i.e., a 4 byte fetch must start at an
+	  address divisible by 4. On 32-bit Unicore processors, these non-aligned
+	  fetch/store instructions will be emulated in software if you say
+	  here, which has a severe performance impact. This is necessary for
+	  correct operation of some network protocols. With an IP-only
+	  configuration it is safe to say N, otherwise say Y.
+
+endmenu
+
+menu "Boot options"
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+
+config CMDLINE_FORCE
+	bool "Always use the default kernel command string"
+	depends on CMDLINE != ""
+	help
+	  Always use the default kernel command string, even if the boot
+	  loader passes other arguments to the kernel.
+	  This is useful if you cannot or don't want to change the
+	  command-line options your boot loader passes to the kernel.
+
+	  If unsure, say N.
+
+endmenu
+
+menu "Userspace binary formats"
+
+source "fs/Kconfig.binfmt"
+
+endmenu
+
+menu "Power management options"
+
+source "kernel/power/Kconfig"
+
+if ARCH_HAS_CPUFREQ
+source "drivers/cpufreq/Kconfig"
+endif
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y if !ARCH_FPGA
+
+config ARCH_HIBERNATION_POSSIBLE
+	bool
+	default y if !ARCH_FPGA
+
+endmenu
+
+source "net/Kconfig"
+
+if ARCH_PUV3
+source "drivers/staging/puv3/Kconfig"
+endif
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "arch/unicore32/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
new file mode 100644
index 0000000..e59ab3c
--- /dev/null
+++ b/arch/unicore32/Kconfig.debug
@@ -0,0 +1,86 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config STRICT_DEVMEM
+	bool "Filter access to /dev/mem"
+	depends on MMU
+	---help---
+	  If this option is disabled, you allow userspace (root) access to all
+	  of memory, including kernel and userspace memory. Accidental
+	  access to this is obviously disastrous, but specific access can
+	  be used by people debugging the kernel.
+
+	  If this option is switched on, the /dev/mem file only allows
+	  userspace access to memory mapped peripherals.
+
+          If in doubt, say Y.
+
+config EARLY_PRINTK
+	bool "Early printk"
+	default DEBUG_OCD
+	help
+	  Write kernel log output directly into the ocd or to a serial port.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. For normal operation
+	  it is not recommended because it looks ugly and doesn't cooperate
+	  with klogd/syslogd or the X server. You should normally N here,
+	  unless you want to debug such a crash.
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
+config DEBUG_STACK_USAGE
+	bool "Enable stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T output.
+
+# These options are only for real kernel hackers who want to get their hands dirty.
+config DEBUG_LL
+	bool "Kernel low-level debugging functions"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to include definitions of printascii, printch, printhex
+	  in the kernel.  This is helpful if you are debugging code that
+	  executes before the console is initialized.
+
+config DEBUG_OCD
+	bool "Kernel low-level debugging via On-Chip-Debugger"
+	depends on DEBUG_LL
+	default y
+	help
+	  Say Y here if you want the debug print routines to direct their
+	  output to the UniCore On-Chip-Debugger channel using CP #1.
+
+config DEBUG_OCD_BREAKPOINT
+	bool "Breakpoint support via On-Chip-Debugger"
+	depends on DEBUG_OCD
+
+config DEBUG_UART
+	int "Kernel low-level debugging messages via serial port"
+	depends on DEBUG_LL
+	range 0 1
+	default "0"
+	help
+	  Choice for UART for kernel low-level using PKUnity UARTS,
+	  should be between zero and one. The port must have been
+	  initialised by the boot-loader before use.
+
+endmenu
diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
new file mode 100644
index 0000000..e82e7a3
--- /dev/null
+++ b/arch/unicore32/Makefile
@@ -0,0 +1,153 @@
+#
+# arch/unicore32/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2002~2010 by Guan Xue-tao
+LOCALVERSION	:= -uc32
+
+CROSS_COMPILE	:= /usr/unicore/gnu-toolchain-unicore/uc4/bin/unicore32-linux-
+
+INSTALL_MOD_PATH := $(obj)/usr
+
+LDFLAGS_vmlinux	:=-p --no-undefined -X
+
+OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
+GZFLAGS		:=-9
+#KBUILD_CFLAGS	+=-pipe
+# Explicitly specifiy 32-bit UniCore ISA:
+KBUILD_CFLAGS	+=$(call cc-option,-municore,)
+
+# Never generate .eh_frame
+KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
+
+ifeq ($(CONFIG_FRAME_POINTER),y)
+KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mno-sched-prolog
+endif
+
+KBUILD_CPPFLAGS	+= -mlittle-endian
+AS		+= -EL
+LD		+= -EL
+
+comma = ,
+
+# Need -Uunicore32 for gcc < 3.x
+# delete -mstructure-size-boundary=32, and default being 8
+# delete -funsigned-char, and default being signed-char
+KBUILD_CFLAGS	+=$(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uunicore32
+KBUILD_AFLAGS	+=-msoft-float
+
+CHECKFLAGS	+= -D__unicore32__
+
+#Default value
+head-y		:= arch/unicore32/kernel/head.o arch/unicore32/kernel/init_task.o
+textofs-y	:= 0x00408000
+
+# The byte offset of the kernel image in RAM from the start of RAM.
+TEXT_OFFSET := $(textofs-y)
+
+export	TEXT_OFFSET GZFLAGS
+
+core-y				+= arch/unicore32/kernel/ arch/unicore32/mm/
+core-$(CONFIG_UNICORE_FPU_F64)	+= arch/unicore32/uc-f64/
+
+drivers-$(CONFIG_ARCH_PUV3)	+= drivers/staging/puv3/
+
+libs-y				+= arch/unicore32/lib/
+libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libc.a)
+libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
+
+# Default target when executing plain make
+KBUILD_IMAGE := zImage
+
+all:	$(KBUILD_IMAGE)
+
+boot := arch/unicore32/boot
+
+ASM_GENERIC_HEADERS	:= arch/unicore32/include/asm/atomic.h			\
+			   arch/unicore32/include/asm/auxvec.h			\
+			   arch/unicore32/include/asm/bitsperlong.h		\
+			   arch/unicore32/include/asm/bug.h			\
+			   arch/unicore32/include/asm/bugs.h			\
+			   arch/unicore32/include/asm/cputime.h			\
+			   arch/unicore32/include/asm/current.h			\
+			   arch/unicore32/include/asm/device.h			\
+			   arch/unicore32/include/asm/emergency-restart.h	\
+			   arch/unicore32/include/asm/errno.h			\
+			   arch/unicore32/include/asm/fb.h			\
+			   arch/unicore32/include/asm/fcntl.h			\
+			   arch/unicore32/include/asm/hardirq.h			\
+			   arch/unicore32/include/asm/hw_irq.h			\
+			   arch/unicore32/include/asm/ioctl.h			\
+			   arch/unicore32/include/asm/ioctls.h			\
+			   arch/unicore32/include/asm/ipcbuf.h			\
+			   arch/unicore32/include/asm/irq_regs.h		\
+			   arch/unicore32/include/asm/kdebug.h			\
+			   arch/unicore32/include/asm/kmap_types.h		\
+			   arch/unicore32/include/asm/local.h			\
+			   arch/unicore32/include/asm/mman.h			\
+			   arch/unicore32/include/asm/module.h			\
+			   arch/unicore32/include/asm/msgbuf.h			\
+			   arch/unicore32/include/asm/param.h			\
+			   arch/unicore32/include/asm/parport.h			\
+			   arch/unicore32/include/asm/percpu.h			\
+			   arch/unicore32/include/asm/poll.h			\
+			   arch/unicore32/include/asm/posix_types.h		\
+			   arch/unicore32/include/asm/resource.h		\
+			   arch/unicore32/include/asm/scatterlist.h		\
+			   arch/unicore32/include/asm/sections.h		\
+			   arch/unicore32/include/asm/sembuf.h			\
+			   arch/unicore32/include/asm/serial.h			\
+			   arch/unicore32/include/asm/shmbuf.h			\
+			   arch/unicore32/include/asm/shmparam.h		\
+			   arch/unicore32/include/asm/siginfo.h			\
+			   arch/unicore32/include/asm/signal.h			\
+			   arch/unicore32/include/asm/socket.h			\
+			   arch/unicore32/include/asm/sockios.h			\
+			   arch/unicore32/include/asm/statfs.h			\
+			   arch/unicore32/include/asm/termbits.h		\
+			   arch/unicore32/include/asm/termios.h			\
+			   arch/unicore32/include/asm/topology.h		\
+			   arch/unicore32/include/asm/types.h			\
+			   arch/unicore32/include/asm/ucontext.h		\
+			   arch/unicore32/include/asm/unaligned.h		\
+			   arch/unicore32/include/asm/user.h			\
+			   arch/unicore32/include/asm/vga.h			\
+			   arch/unicore32/include/asm/xor.h
+
+%.h:
+	$(Q)echo '#include <asm-generic/$(notdir $@)>' > $@
+
+archprepare: $(ASM_GENERIC_HEADERS)
+
+# Convert bzImage to zImage
+bzImage: zImage
+
+zImage Image uImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
+zinstall install: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
+
+CLEAN_DIRS += $(INSTALL_MOD_PATH)/lib
+CLEAN_FILES += $(ASM_GENERIC_HEADERS)
+
+# We use MRPROPER_FILES and CLEAN_FILES now
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+define archhelp
+  echo  '* zImage        - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
+  echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
+  echo  '  uImage        - U-Boot wrapped zImage'
+  echo  '  install       - Install uncompressed kernel'
+  echo  '  zinstall      - Install compressed kernel'
+  echo  '                  Install using (your) ~/bin/$(INSTALLKERNEL) or'
+  echo  '                  (distribution) /sbin/$(INSTALLKERNEL) or'
+  echo  '                  install to $$(INSTALL_PATH) and run lilo'
+endef
diff --git a/arch/unicore32/configs/debug_defconfig b/arch/unicore32/configs/debug_defconfig
new file mode 100644
index 0000000..97f0b2b
--- /dev/null
+++ b/arch/unicore32/configs/debug_defconfig
@@ -0,0 +1,211 @@
+### General setup
+CONFIG_EXPERIMENTAL=y
+CONFIG_LOCALVERSION="-debug"
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_HOTPLUG=y
+#	Initial RAM filesystem and RAM disk (initramfs/initrd) support
+#CONFIG_BLK_DEV_INITRD=y
+#CONFIG_INITRAMFS_SOURCE="arch/unicore/ramfs/ramfs_config"
+
+### Enable loadable module support
+CONFIG_MODULES=n
+CONFIG_MODULE_UNLOAD=y
+
+### System Type
+CONFIG_ARCH_PUV3=y
+#	Board Selection
+CONFIG_PUV3_NB0916=y
+#	Processor Features
+CONFIG_CPU_DCACHE_LINE_DISABLE=y
+CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE=n
+
+### Bus support
+CONFIG_PCI=y
+CONFIG_PCI_LEGACY=n
+
+### Boot options
+#	for debug, adding: earlyprintk=ocd,keep initcall_debug
+#	others support: test_suspend=mem root=/dev/sda
+#	hibernate support: resume=/dev/sda3
+CONFIG_CMDLINE="earlyprintk=ocd,keep ignore_loglevel"
+# TODO: mem=512M video=unifb:1024x600-16@75
+# for nfs: root=/dev/nfs rw nfsroot=192.168.10.88:/home/udb/nfs/,rsize=1024,wsize=1024
+#	ip=192.168.10.83:192.168.10.88:192.168.10.1:255.255.255.0::eth0:off
+CONFIG_CMDLINE_FORCE=y
+
+### Power management options
+CONFIG_PM=y
+CONFIG_HIBERNATION=y
+CONFIG_PM_STD_PARTITION="/dev/sda3"
+CONFIG_CPU_FREQ=n
+CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
+
+### Networking support
+CONFIG_NET=y
+#	Networking options
+CONFIG_PACKET=m
+CONFIG_UNIX=m
+#	TCP/IP networking
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IPV6=n
+#	Wireless
+CONFIG_WIRELESS=y
+CONFIG_WIRELESS_EXT=y
+CONFIG_MAC80211=m
+
+### PKUnity SoC Features
+CONFIG_USB_WLAN_HED_AQ3=n
+CONFIG_USB_CMMB_INNOFIDEI=n
+CONFIG_I2C_BATTERY_BQ27200=n
+CONFIG_I2C_EEPROM_AT24=n
+CONFIG_LCD_BACKLIGHT=n
+
+CONFIG_PUV3_RTC=y
+CONFIG_PUV3_UMAL=y
+CONFIG_PUV3_UNIGFX=y
+CONFIG_PUV3_MUSB=n
+CONFIG_PUV3_AC97=n
+CONFIG_PUV3_NAND=n
+CONFIG_PUV3_MMC=n
+CONFIG_PUV3_UART=n
+
+### Device Drivers
+#	Memory Technology Device (MTD) support
+CONFIG_MTD=m
+CONFIG_MTD_UBI=m
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=m
+#	RAM/ROM/Flash chip drivers
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_CFI_AMDSTD=m
+#	Mapping drivers for chip access
+CONFIG_MTD_PHYSMAP=m
+
+#	Block devices
+CONFIG_BLK_DEV_LOOP=m
+
+#	SCSI device support
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_BLK_DEV_SR=m
+CONFIG_CHR_DEV_SG=m
+
+#	Serial ATA (prod) and Parallel ATA (experimental) drivers
+CONFIG_ATA=y
+CONFIG_SATA_VIA=y
+
+#	Network device support
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_NETDEV_1000=y
+#	Wireless LAN
+CONFIG_WLAN_80211=n
+CONFIG_RT2X00=n
+CONFIG_RT73USB=n
+
+#	Input device support
+CONFIG_INPUT_EVDEV=m
+#	Keyboards
+CONFIG_KEYBOARD_GPIO=m
+
+#	Hardware Monitoring support
+#CONFIG_SENSORS_LM75=m
+#	Generic Thermal sysfs driver
+#CONFIG_THERMAL=m
+#CONFIG_THERMAL_HWMON=y
+
+#	Multimedia support
+CONFIG_MEDIA_SUPPORT=n
+CONFIG_VIDEO_DEV=n
+CONFIG_USB_VIDEO_CLASS=n
+
+#	Graphics support
+#	Console display driver support
+CONFIG_VGA_CONSOLE=n
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+#	Bootup logo
+CONFIG_LOGO=n
+
+#	Sound card support
+CONFIG_SOUND=m
+#	Advanced Linux Sound Architecture
+CONFIG_SND=m
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+
+#	USB support
+CONFIG_USB_ARCH_HAS_HCD=n
+CONFIG_USB=n
+CONFIG_USB_DEVICEFS=n
+CONFIG_USB_PRINTER=n
+CONFIG_USB_STORAGE=n
+#	Inventra Highspeed Dual Role Controller
+CONFIG_USB_MUSB_HDRC=n
+
+#	LED Support
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+#	LED Triggers
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_IDE_DISK=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+
+#	Real Time Clock
+CONFIG_RTC_LIB=m
+CONFIG_RTC_CLASS=m
+
+### File systems
+CONFIG_EXT2_FS=m
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_FUSE_FS=m
+#	CD-ROM/DVD Filesystems
+CONFIG_ISO9660_FS=m
+CONFIG_JOLIET=y
+CONFIG_UDF_FS=m
+#	DOS/FAT/NT Filesystems
+CONFIG_VFAT_FS=m
+#	Pseudo filesystems
+CONFIG_PROC_FS=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+#	Miscellaneous filesystems
+CONFIG_MISC_FILESYSTEMS=y
+CONFIG_JFFS2_FS=m
+CONFIG_UBIFS_FS=m
+#	Network File Systems
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_ROOT_NFS=y
+#	Partition Types
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_MSDOS_PARTITION=y
+#	Native language support
+CONFIG_NLS=y
+CONFIG_NLS_CODEPAGE_437=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_ISO8859_1=m
+CONFIG_NLS_UTF8=m
+
+### Kernel hacking
+CONFIG_FRAME_WARN=8096
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_LOCKING=n
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_FRAME_POINTER=y
+CONFIG_DEBUG_USER=y
+CONFIG_DEBUG_LL=y
+
diff --git a/arch/unicore32/configs/nb0916_defconfig b/arch/unicore32/configs/nb0916_defconfig
new file mode 100644
index 0000000..203bf87
--- /dev/null
+++ b/arch/unicore32/configs/nb0916_defconfig
@@ -0,0 +1,203 @@
+### General setup
+CONFIG_EXPERIMENTAL=y
+CONFIG_LOCALVERSION="-nb0916"
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_HOTPLUG=y
+#	Initial RAM filesystem and RAM disk (initramfs/initrd) support
+#CONFIG_BLK_DEV_INITRD=y
+#CONFIG_INITRAMFS_SOURCE="arch/unicore/ramfs/ramfs_config"
+
+### Enable loadable module support
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+
+### System Type
+CONFIG_ARCH_PUV3=y
+#	Board Selection
+CONFIG_PUV3_NB0916=y
+#	Processor Features
+CONFIG_CPU_DCACHE_LINE_DISABLE=y
+CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE=n
+
+### Bus support
+CONFIG_PCI=y
+CONFIG_PCI_LEGACY=n
+
+### Boot options
+#	for debug, adding: earlyprintk=ocd,keep initcall_debug
+#	others support: test_suspend=mem root=/dev/sda
+#	hibernate support: resume=/dev/sda3
+CONFIG_CMDLINE=""
+# CONFIG_CMDLINE_FORCE is not set
+
+### Power management options
+CONFIG_PM=y
+CONFIG_HIBERNATION=y
+CONFIG_PM_STD_PARTITION="/dev/sda3"
+CONFIG_CPU_FREQ=n
+CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
+
+### Networking support
+CONFIG_NET=y
+#	Networking options
+CONFIG_PACKET=m
+CONFIG_UNIX=m
+#	TCP/IP networking
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IPV6=n
+#	Wireless
+CONFIG_WIRELESS=y
+CONFIG_WIRELESS_EXT=y
+CONFIG_MAC80211=m
+
+### PKUnity SoC Features
+CONFIG_USB_WLAN_HED_AQ3=n
+CONFIG_USB_CMMB_INNOFIDEI=n
+CONFIG_I2C_BATTERY_BQ27200=m
+CONFIG_I2C_EEPROM_AT24=m
+CONFIG_LCD_BACKLIGHT=m
+
+CONFIG_PUV3_RTC=m
+CONFIG_PUV3_UMAL=m
+CONFIG_PUV3_UNIGFX=y
+CONFIG_PUV3_MUSB=n
+CONFIG_PUV3_AC97=n
+CONFIG_PUV3_NAND=n
+CONFIG_PUV3_MMC=n
+CONFIG_PUV3_UART=n
+
+### Device Drivers
+#	Memory Technology Device (MTD) support
+CONFIG_MTD=m
+CONFIG_MTD_UBI=m
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=m
+#	RAM/ROM/Flash chip drivers
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_CFI_AMDSTD=m
+#	Mapping drivers for chip access
+CONFIG_MTD_PHYSMAP=m
+
+#	Block devices
+CONFIG_BLK_DEV_LOOP=m
+
+#	SCSI device support
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_BLK_DEV_SR=m
+CONFIG_CHR_DEV_SG=m
+
+#	Serial ATA (prod) and Parallel ATA (experimental) drivers
+CONFIG_ATA=y
+CONFIG_SATA_VIA=y
+
+#	Network device support
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_NETDEV_1000=y
+#	Wireless LAN
+CONFIG_WLAN_80211=y
+CONFIG_RT2X00=m
+CONFIG_RT73USB=n
+
+#	Input device support
+CONFIG_INPUT_EVDEV=m
+#	Keyboards
+CONFIG_KEYBOARD_GPIO=m
+
+#	Hardware Monitoring support
+#CONFIG_SENSORS_LM75=m
+#	Generic Thermal sysfs driver
+#CONFIG_THERMAL=m
+#CONFIG_THERMAL_HWMON=y
+
+#	Multimedia support
+CONFIG_MEDIA_SUPPORT=m
+CONFIG_VIDEO_DEV=m
+CONFIG_USB_VIDEO_CLASS=m
+
+#	Graphics support
+#	Console display driver support
+CONFIG_VGA_CONSOLE=n
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+#	Bootup logo
+CONFIG_LOGO=n
+
+#	Sound card support
+CONFIG_SOUND=m
+#	Advanced Linux Sound Architecture
+CONFIG_SND=m
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+
+#	USB support
+CONFIG_USB_ARCH_HAS_HCD=y
+CONFIG_USB=y
+CONFIG_USB_DEVICEFS=y
+CONFIG_USB_PRINTER=m
+CONFIG_USB_STORAGE=m
+#	Inventra Highspeed Dual Role Controller
+CONFIG_USB_MUSB_HDRC=m
+
+#	LED Support
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+#	LED Triggers
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_IDE_DISK=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+
+#	Real Time Clock
+CONFIG_RTC_LIB=m
+CONFIG_RTC_CLASS=m
+
+### File systems
+CONFIG_EXT2_FS=m
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_FUSE_FS=m
+#	CD-ROM/DVD Filesystems
+CONFIG_ISO9660_FS=m
+CONFIG_JOLIET=y
+CONFIG_UDF_FS=m
+#	DOS/FAT/NT Filesystems
+CONFIG_VFAT_FS=m
+#	Pseudo filesystems
+CONFIG_PROC_FS=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+#	Miscellaneous filesystems
+CONFIG_MISC_FILESYSTEMS=y
+CONFIG_JFFS2_FS=m
+CONFIG_UBIFS_FS=m
+#	Network File Systems
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_ROOT_NFS=y
+#	Partition Types
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_MSDOS_PARTITION=y
+#	Native language support
+CONFIG_NLS=y
+CONFIG_NLS_CODEPAGE_437=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_ISO8859_1=m
+CONFIG_NLS_UTF8=m
+
+### Kernel hacking
+CONFIG_FRAME_WARN=8096
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_KERNEL=n
+CONFIG_DEBUG_USER=n
+
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
new file mode 100644
index 0000000..c43b56c
--- /dev/null
+++ b/arch/unicore32/include/asm/Kbuild
@@ -0,0 +1,4 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += hwcap.h
+
diff --git a/arch/unicore32/include/asm/linkage.h b/arch/unicore32/include/asm/linkage.h
new file mode 100644
index 0000000..d1618bd
--- /dev/null
+++ b/arch/unicore32/include/asm/linkage.h
@@ -0,0 +1,22 @@
+/*
+ * linux/arch/unicore32/include/asm/linkage.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_LINKAGE_H__
+#define __UNICORE_LINKAGE_H__
+
+#define __ALIGN .align 0
+#define __ALIGN_STR ".align 0"
+
+#define ENDPROC(name) \
+	.type name, %function; \
+	END(name)
+
+#endif
diff --git a/arch/unicore32/kernel/Makefile b/arch/unicore32/kernel/Makefile
new file mode 100644
index 0000000..7a1d12f
--- /dev/null
+++ b/arch/unicore32/kernel/Makefile
@@ -0,0 +1,34 @@
+#
+# Makefile for the linux kernel.
+#
+
+CPPFLAGS_vmlinux.lds		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+AFLAGS_head.o			:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+
+# Object file lists.
+
+obj-y		:= elf.o entry.o process.o ptrace.o setup.o signal.o \
+		   sys_unicore.o stacktrace.o traps.o
+
+obj-$(CONFIG_MODULES)		+= ksyms.o module.o
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+
+obj-$(CONFIG_CPU_FREQ)		+= cpu-ucv2.o
+
+# obj-y for architecture PKUnity v3
+obj-$(CONFIG_ARCH_PUV3)		+= clock.o irq.o time.o
+
+obj-$(CONFIG_PUV3_PM)		+= pm.o sleep.o
+obj-$(CONFIG_HIBERNATION)	+= hibernate.o hibernate_asm.o
+
+obj-$(CONFIG_PCI)		+= pci.o
+
+# obj-y for specific machines
+obj-$(CONFIG_ARCH_PUV3)		+= puv3-core.o
+obj-$(CONFIG_PUV3_NB0916)	+= puv3-nb0916.o
+obj-$(CONFIG_PUV3_SMW0919)	+= puv3-smw0919.o
+
+head-y				:= head.o
+obj-$(CONFIG_DEBUG_LL)		+= debug.o
+
+extra-y				:= $(head-y) init_task.o vmlinux.lds
diff --git a/arch/unicore32/kernel/asm-offsets.c b/arch/unicore32/kernel/asm-offsets.c
new file mode 100644
index 0000000..ffcbe75
--- /dev/null
+++ b/arch/unicore32/kernel/asm-offsets.c
@@ -0,0 +1,112 @@
+/*
+ * linux/arch/unicore32/kernel/asm-offsets.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * Generate definitions needed by assembly language modules.
+ * This code generates raw asm output which is post-processed to extract
+ * and format the required data.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/kbuild.h>
+#include <linux/suspend.h>
+#include <linux/thread_info.h>
+#include <asm/memory.h>
+#include <asm/suspend.h>
+
+/*
+ * GCC 3.0, 3.1: general bad code generation.
+ * GCC 3.2.0: incorrect function argument offset calculation.
+ * GCC 3.2.x: miscompiles NEW_AUX_ENT in fs/binfmt_elf.c
+ *	(http://gcc.gnu.org/PR8896) and incorrect structure
+ *		initialisation in fs/jffs2/erase.c
+ */
+#if (__GNUC__ < 4)
+#error Your compiler should upgrade to uc4
+#error	Known good compilers: 4.2.2
+#endif
+
+int main(void)
+{
+	DEFINE(TSK_ACTIVE_MM,	offsetof(struct task_struct, active_mm));
+	BLANK();
+	DEFINE(TI_FLAGS,	offsetof(struct thread_info, flags));
+	DEFINE(TI_PREEMPT,	offsetof(struct thread_info, preempt_count));
+	DEFINE(TI_ADDR_LIMIT,	offsetof(struct thread_info, addr_limit));
+	DEFINE(TI_TASK,		offsetof(struct thread_info, task));
+	DEFINE(TI_EXEC_DOMAIN,	offsetof(struct thread_info, exec_domain));
+	DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
+	DEFINE(TI_CPU_SAVE,	offsetof(struct thread_info, cpu_context));
+	DEFINE(TI_USED_CP,	offsetof(struct thread_info, used_cp));
+#ifdef CONFIG_UNICORE_FPU_F64
+	DEFINE(TI_FPSTATE,	offsetof(struct thread_info, fpstate));
+#endif
+	BLANK();
+	DEFINE(S_R0,		offsetof(struct pt_regs, UCreg_00));
+	DEFINE(S_R1,		offsetof(struct pt_regs, UCreg_01));
+	DEFINE(S_R2,		offsetof(struct pt_regs, UCreg_02));
+	DEFINE(S_R3,		offsetof(struct pt_regs, UCreg_03));
+	DEFINE(S_R4,		offsetof(struct pt_regs, UCreg_04));
+	DEFINE(S_R5,		offsetof(struct pt_regs, UCreg_05));
+	DEFINE(S_R6,		offsetof(struct pt_regs, UCreg_06));
+	DEFINE(S_R7,		offsetof(struct pt_regs, UCreg_07));
+	DEFINE(S_R8,		offsetof(struct pt_regs, UCreg_08));
+	DEFINE(S_R9,		offsetof(struct pt_regs, UCreg_09));
+	DEFINE(S_R10,		offsetof(struct pt_regs, UCreg_10));
+	DEFINE(S_R11,		offsetof(struct pt_regs, UCreg_11));
+	DEFINE(S_R12,		offsetof(struct pt_regs, UCreg_12));
+	DEFINE(S_R13,		offsetof(struct pt_regs, UCreg_13));
+	DEFINE(S_R14,		offsetof(struct pt_regs, UCreg_14));
+	DEFINE(S_R15,		offsetof(struct pt_regs, UCreg_15));
+	DEFINE(S_R16,		offsetof(struct pt_regs, UCreg_16));
+	DEFINE(S_R17,		offsetof(struct pt_regs, UCreg_17));
+	DEFINE(S_R18,		offsetof(struct pt_regs, UCreg_18));
+	DEFINE(S_R19,		offsetof(struct pt_regs, UCreg_19));
+	DEFINE(S_R20,		offsetof(struct pt_regs, UCreg_20));
+	DEFINE(S_R21,		offsetof(struct pt_regs, UCreg_21));
+	DEFINE(S_R22,		offsetof(struct pt_regs, UCreg_22));
+	DEFINE(S_R23,		offsetof(struct pt_regs, UCreg_23));
+	DEFINE(S_R24,		offsetof(struct pt_regs, UCreg_24));
+	DEFINE(S_R25,		offsetof(struct pt_regs, UCreg_25));
+	DEFINE(S_R26,		offsetof(struct pt_regs, UCreg_26));
+	DEFINE(S_FP,		offsetof(struct pt_regs, UCreg_fp));
+	DEFINE(S_IP,		offsetof(struct pt_regs, UCreg_ip));
+	DEFINE(S_SP,		offsetof(struct pt_regs, UCreg_sp));
+	DEFINE(S_LR,		offsetof(struct pt_regs, UCreg_lr));
+	DEFINE(S_PC,		offsetof(struct pt_regs, UCreg_pc));
+	DEFINE(S_PSR,		offsetof(struct pt_regs, UCreg_asr));
+	DEFINE(S_OLD_R0,	offsetof(struct pt_regs, UCreg_ORIG_00));
+	DEFINE(S_FRAME_SIZE,	sizeof(struct pt_regs));
+	BLANK();
+	DEFINE(VMA_VM_MM,	offsetof(struct vm_area_struct, vm_mm));
+	DEFINE(VMA_VM_FLAGS,	offsetof(struct vm_area_struct, vm_flags));
+	BLANK();
+	DEFINE(VM_EXEC,		VM_EXEC);
+	BLANK();
+	DEFINE(PAGE_SZ,		PAGE_SIZE);
+	BLANK();
+	DEFINE(SYS_ERROR0,	0x9f0000);
+	BLANK();
+	DEFINE(PBE_ADDRESS,		offsetof(struct pbe, address));
+	DEFINE(PBE_ORIN_ADDRESS,	offsetof(struct pbe, orig_address));
+	DEFINE(PBE_NEXT,		offsetof(struct pbe, next));
+	DEFINE(SWSUSP_CPU,		offsetof(struct swsusp_arch_regs, \
+							cpu_context));
+#ifdef	CONFIG_UNICORE_FPU_F64
+	DEFINE(SWSUSP_FPSTATE,		offsetof(struct swsusp_arch_regs, \
+							fpstate));
+#endif
+	BLANK();
+	DEFINE(DMA_BIDIRECTIONAL,	DMA_BIDIRECTIONAL);
+	DEFINE(DMA_TO_DEVICE,		DMA_TO_DEVICE);
+	DEFINE(DMA_FROM_DEVICE,		DMA_FROM_DEVICE);
+	return 0;
+}
diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
new file mode 100644
index 0000000..1574609
--- /dev/null
+++ b/arch/unicore32/kernel/ksyms.c
@@ -0,0 +1,87 @@
+/*
+ * linux/arch/unicore32/kernel/ksyms.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/cryptohash.h>
+#include <linux/delay.h>
+#include <linux/in6.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <asm/checksum.h>
+#include <asm/system.h>
+
+
+EXPORT_SYMBOL(__backtrace);
+
+	/* platform dependent support */
+EXPORT_SYMBOL(__udelay);
+EXPORT_SYMBOL(__const_udelay);
+
+	/* networking */
+EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+EXPORT_SYMBOL(csum_partial_copy_nocheck);
+EXPORT_SYMBOL(__csum_ipv6_magic);
+
+	/* io */
+#ifndef __raw_readsb
+EXPORT_SYMBOL(__raw_readsb);
+#endif
+#ifndef __raw_readsw
+EXPORT_SYMBOL(__raw_readsw);
+#endif
+#ifndef __raw_readsl
+EXPORT_SYMBOL(__raw_readsl);
+#endif
+#ifndef __raw_writesb
+EXPORT_SYMBOL(__raw_writesb);
+#endif
+#ifndef __raw_writesw
+EXPORT_SYMBOL(__raw_writesw);
+#endif
+#ifndef __raw_writesl
+EXPORT_SYMBOL(__raw_writesl);
+#endif
+
+	/* string / mem functions */
+EXPORT_SYMBOL(strchr);
+EXPORT_SYMBOL(strrchr);
+EXPORT_SYMBOL(memset);
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(memmove);
+EXPORT_SYMBOL(memchr);
+
+	/* user mem (segment) */
+EXPORT_SYMBOL(__strnlen_user);
+EXPORT_SYMBOL(__strncpy_from_user);
+
+EXPORT_SYMBOL(copy_page);
+
+EXPORT_SYMBOL(__copy_from_user);
+EXPORT_SYMBOL(__copy_to_user);
+EXPORT_SYMBOL(__clear_user);
+
+EXPORT_SYMBOL(__get_user_1);
+EXPORT_SYMBOL(__get_user_2);
+EXPORT_SYMBOL(__get_user_4);
+
+EXPORT_SYMBOL(__put_user_1);
+EXPORT_SYMBOL(__put_user_2);
+EXPORT_SYMBOL(__put_user_4);
+EXPORT_SYMBOL(__put_user_8);
+
+	/* crypto hash */
+EXPORT_SYMBOL(sha_transform);
+
diff --git a/arch/unicore32/kernel/module.c b/arch/unicore32/kernel/module.c
new file mode 100644
index 0000000..3e5a38d
--- /dev/null
+++ b/arch/unicore32/kernel/module.c
@@ -0,0 +1,152 @@
+/*
+ * linux/arch/unicore32/kernel/module.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/moduleloader.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/gfp.h>
+
+#include <asm/pgtable.h>
+#include <asm/sections.h>
+
+void *module_alloc(unsigned long size)
+{
+	struct vm_struct *area;
+
+	size = PAGE_ALIGN(size);
+	if (!size)
+		return NULL;
+
+	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
+	if (!area)
+		return NULL;
+
+	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
+}
+
+void module_free(struct module *module, void *region)
+{
+	vfree(region);
+}
+
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+			      Elf_Shdr *sechdrs,
+			      char *secstrings,
+			      struct module *mod)
+{
+	return 0;
+}
+
+int
+apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
+	       unsigned int relindex, struct module *module)
+{
+	Elf32_Shdr *symsec = sechdrs + symindex;
+	Elf32_Shdr *relsec = sechdrs + relindex;
+	Elf32_Shdr *dstsec = sechdrs + relsec->sh_info;
+	Elf32_Rel *rel = (void *)relsec->sh_addr;
+	unsigned int i;
+
+	for (i = 0; i < relsec->sh_size / sizeof(Elf32_Rel); i++, rel++) {
+		unsigned long loc;
+		Elf32_Sym *sym;
+		s32 offset;
+
+		offset = ELF32_R_SYM(rel->r_info);
+		if (offset < 0 || offset >
+				(symsec->sh_size / sizeof(Elf32_Sym))) {
+			printk(KERN_ERR "%s: bad relocation, "
+					"section %d reloc %d\n",
+					module->name, relindex, i);
+			return -ENOEXEC;
+		}
+
+		sym = ((Elf32_Sym *)symsec->sh_addr) + offset;
+
+		if (rel->r_offset < 0 || rel->r_offset >
+				dstsec->sh_size - sizeof(u32)) {
+			printk(KERN_ERR "%s: out of bounds relocation, "
+				"section %d reloc %d offset %d size %d\n",
+				module->name, relindex, i, rel->r_offset,
+				dstsec->sh_size);
+			return -ENOEXEC;
+		}
+
+		loc = dstsec->sh_addr + rel->r_offset;
+
+		switch (ELF32_R_TYPE(rel->r_info)) {
+		case R_UNICORE_NONE:
+			/* ignore */
+			break;
+
+		case R_UNICORE_ABS32:
+			*(u32 *)loc += sym->st_value;
+			break;
+
+		case R_UNICORE_PC24:
+		case R_UNICORE_CALL:
+		case R_UNICORE_JUMP24:
+			offset = (*(u32 *)loc & 0x00ffffff) << 2;
+			if (offset & 0x02000000)
+				offset -= 0x04000000;
+
+			offset += sym->st_value - loc;
+			if (offset & 3 ||
+			    offset <= (s32)0xfe000000 ||
+			    offset >= (s32)0x02000000) {
+				printk(KERN_ERR
+				       "%s: relocation out of range, section "
+				       "%d reloc %d sym '%s'\n", module->name,
+				       relindex, i, strtab + sym->st_name);
+				return -ENOEXEC;
+			}
+
+			offset >>= 2;
+
+			*(u32 *)loc &= 0xff000000;
+			*(u32 *)loc |= offset & 0x00ffffff;
+			break;
+
+		default:
+			printk(KERN_ERR "%s: unknown relocation: %u\n",
+			       module->name, ELF32_R_TYPE(rel->r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+}
+
+int
+apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
+		   unsigned int symindex, unsigned int relsec,
+		   struct module *module)
+{
+	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
+	       module->name);
+	return -ENOEXEC;
+}
+
+int
+module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
+		struct module *module)
+{
+	return 0;
+}
+
+void
+module_arch_cleanup(struct module *mod)
+{
+}
diff --git a/arch/unicore32/kernel/vmlinux.lds.S b/arch/unicore32/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..d8cd090
--- /dev/null
+++ b/arch/unicore32/kernel/vmlinux.lds.S
@@ -0,0 +1,120 @@
+/*
+ * linux/arch/unicore32/kernel/vmlinux.lds.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/thread_info.h>
+#include <asm/memory.h>
+#include <asm/page.h>
+
+OUTPUT_ARCH(unicore32)
+ENTRY(stext)
+
+jiffies = jiffies_64;
+
+SECTIONS
+{
+	. = PAGE_OFFSET + TEXT_OFFSET;
+
+	.init : {			/* Init code and data		*/
+		_stext = .;
+		_sinittext = .;
+			HEAD_TEXT
+			INIT_TEXT
+		_einittext = .;
+
+		INIT_SETUP(16)
+
+		INIT_CALLS
+		CON_INITCALL
+		SECURITY_INITCALL
+		INIT_RAM_FS
+
+		__init_begin = _stext;
+		INIT_DATA
+	}
+
+	PERCPU(PAGE_SIZE)
+
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;
+
+	/DISCARD/ : {			/* Exit code and data		*/
+		*(.UNICORE.exidx.exit.text)
+		*(.UNICORE.extab.exit.text)
+		*(.UNICORE.exidx.cpuexit.text)
+		*(.UNICORE.extab.cpuexit.text)
+#ifndef CONFIG_HOTPLUG
+		*(.UNICORE.exidx.devexit.text)
+		*(.UNICORE.extab.devexit.text)
+#endif
+	}
+
+	.text : {			/* Real text segment		*/
+		_text = .;		/* Text and read-only data	*/
+			__exception_text_start = .;
+			*(.exception.text)
+			__exception_text_end = .;
+			TEXT_TEXT
+			SCHED_TEXT
+			LOCK_TEXT
+			*(.fixup)
+			*(.gnu.warning)
+			*(.rodata)
+			*(.rodata.*)
+		. = ALIGN(4);
+		*(.got)			/* Global offset table		*/
+	}
+
+	RO_DATA(PAGE_SIZE)
+
+	_etext = .;			/* End of text and rodata section */
+
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
+
+		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(32)
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
+	BSS_SECTION(0, 0, 0)
+	_end = .;
+
+	STABS_DEBUG
+	.comment 0 : { *(.comment) }
+}
diff --git a/firmware/Makefile b/firmware/Makefile
index 74d47cd..6d36f8a 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -164,7 +164,7 @@ quiet_cmd_fwbin = MK_FW   $@
 				firmware/%.gen.S,%,$@))))";		     \
 		  ASM_WORD=$(if $(CONFIG_64BIT),.quad,.long);		     \
 		  ASM_ALIGN=$(if $(CONFIG_64BIT),3,2);			     \
-		  PROGBITS=$(if $(CONFIG_ARM),%,@)progbits;		     \
+		  PROGBITS=$(if $(CONFIG_ARM) and $(CONFIG_UNICORE32),%,@)progbits; \
 		  echo "/* Generated by firmware/Makefile */"		> $@;\
 		  echo "    .section .rodata"				>>$@;\
 		  echo "    .p2align $${ASM_ALIGN}"			>>$@;\


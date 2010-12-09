Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0LIJbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:31:55 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53612 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab0LIJbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:31:53 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 002/211] unicore32: new file arch/unicore32/Kconfig
Date: Thu, 9 Dec 2010 17:31:48 +0800
Message-ID: <01ce01cb9783$e77278e0$b6576aa0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXg9On9FOgLcPDTU6V5ml3OYJ6DQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	Global Kconfig file for UniCore32

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig |  260
++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 260 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
new file mode 100644
index 0000000..50ca508
--- /dev/null
+++ b/arch/unicore32/Kconfig
@@ -0,0 +1,260 @@
+config UNICORE32
+	bool
+	default y
+	select HAVE_MEMBLOCK
+	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_BZIP2
+	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_LZMA
+	select GENERIC_FIND_FIRST_BIT
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
+config TRACE_IRQFLAGS_SUPPORT
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
+	  naturally aligned on the bus, i.e., a 4 byte fetch must start at
an
+	  address divisible by 4. On 32-bit Unicore processors, these
non-aligned
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



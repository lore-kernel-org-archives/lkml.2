Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2EETML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:12:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54756 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2EETMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:12:09 -0400
Date: Sat, 5 May 2012 12:11:58 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-a6359d1eec43d1fd6ffbac958149844873e0084f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120503085035.867948914@linutronix.de>
References: <20120503085035.867948914@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] init_task: Replace CONFIG_HAVE_GENERIC_INIT_TASK
Git-Commit-ID: a6359d1eec43d1fd6ffbac958149844873e0084f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:12:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6359d1eec43d1fd6ffbac958149844873e0084f
Gitweb:     http://git.kernel.org/tip/a6359d1eec43d1fd6ffbac958149844873e0084f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:03:02 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:46 +0200

init_task: Replace CONFIG_HAVE_GENERIC_INIT_TASK

Now that all archs except ia64 are converted, replace the config and
let the ia64 select CONFIG_ARCH_INIT_TASK

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120503085035.867948914@linutronix.de

---
 arch/Kconfig            |    3 ++-
 arch/alpha/Kconfig      |    1 -
 arch/arm/Kconfig        |    1 -
 arch/avr32/Kconfig      |    1 -
 arch/blackfin/Kconfig   |    1 -
 arch/c6x/Kconfig        |    1 -
 arch/cris/Kconfig       |    1 -
 arch/frv/Kconfig        |    1 -
 arch/h8300/Kconfig      |    1 -
 arch/hexagon/Kconfig    |    1 -
 arch/ia64/Kconfig       |    1 +
 arch/m32r/Kconfig       |    1 -
 arch/m68k/Kconfig       |    1 -
 arch/microblaze/Kconfig |    1 -
 arch/mips/Kconfig       |    1 -
 arch/mn10300/Kconfig    |    1 -
 arch/openrisc/Kconfig   |    1 -
 arch/parisc/Kconfig     |    1 -
 arch/powerpc/Kconfig    |    1 -
 arch/s390/Kconfig       |    1 -
 arch/score/Kconfig      |    1 -
 arch/sh/Kconfig         |    1 -
 arch/sparc/Kconfig      |    1 -
 arch/tile/Kconfig       |    1 -
 arch/um/Kconfig.common  |    1 -
 arch/unicore32/Kconfig  |    1 -
 arch/x86/Kconfig        |    1 -
 arch/xtensa/Kconfig     |    1 -
 init/Makefile           |    5 ++++-
 29 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 2dd8fdd..597b132 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -148,7 +148,8 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
-config HAVE_GENERIC_INIT_TASK
+# Select if arch init_task initializer is different to init/init_task.c
+config ARCH_INIT_TASK
        bool
 
 config HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 74d0004..991b8bb 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -16,7 +16,6 @@ config ALPHA
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 8b36535..cb253ce 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -35,7 +35,6 @@ config ARM
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index f4289ca..3dea7231 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -12,7 +12,6 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 8570d6e..779b9c8 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -38,7 +38,6 @@ config BLACKFIN
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 4189fb5..1c3ccd4 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -10,7 +10,6 @@ config TMS320C6X
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_GENERIC_INIT_TASK
 	select HAVE_MEMBLOCK
 	select SPARSE_IRQ
 	select IRQ_DOMAIN
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 15e30a7..2995035 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -50,7 +50,6 @@ config CRIS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
-	select HAVE_GENERIC_INIT_TASK
 
 config HZ
 	int
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index ed6dbd2..a685910 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -9,7 +9,6 @@ config FRV
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
-	select HAVE_GENERIC_INIT_TASK
 
 config ZONE_DMA
 	bool
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 5fac425..56e890d 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -5,7 +5,6 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
-	select HAVE_GENERIC_INIT_TASK
 
 config SYMBOL_PREFIX
 	string
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 6ee5488..d2e4a33 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -28,7 +28,6 @@ config HEXAGON
 	select NO_IOPORT
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	# mostly generic routines, with some accelerated ones
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 1197547..022ea3a 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -34,6 +34,7 @@ config IA64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select ARCH_INIT_TASK
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 8b8bd7f..ef80a65 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -11,7 +11,6 @@ config M32R
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
-	select HAVE_GENERIC_INIT_TASK
 
 config SBUS
 	bool
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 1891127..d318c60 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,7 +8,6 @@ config M68K
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select FPU if MMU
-	select HAVE_GENERIC_INIT_TASK
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 21ccba6..ac22dc7 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -22,7 +22,6 @@ config MICROBLAZE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
-	select HAVE_GENERIC_INIT_TASK
 
 config SWAP
 	def_bool n
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d6c7890..186fc8c 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -30,7 +30,6 @@ config MIPS
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 menu "Machine selection"
 
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index d28b6eb..3aa3de0 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -6,7 +6,6 @@ config MN10300
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
-	select HAVE_GENERIC_INIT_TASK
 
 config AM33_2
 	def_bool n
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 6d92193..a478719 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -17,7 +17,6 @@ config OPENRISC
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
-	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	def_bool y
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 4c6ca0d..ddb8b24 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -18,7 +18,6 @@ config PARISC
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 946e881..c815535 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -145,7 +145,6 @@ config PPC
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 6c0eb21..15cab3e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -123,7 +123,6 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index c760bcc..4b28577 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -9,7 +9,6 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
-       select HAVE_GENERIC_INIT_TASK
 
 choice
 	prompt "System type"
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index a0cd70b..244cfd0 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -29,7 +29,6 @@ config SUPERH
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 99aad7c..e417f35 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -31,7 +31,6 @@ config SPARC
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 4fa3ff5..96033e2 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -13,7 +13,6 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select HAVE_GENERIC_INIT_TASK
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index f03473c..20a49ba 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -10,7 +10,6 @@ config UML
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
-	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	bool
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index e24ca398..eeb8054 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -13,7 +13,6 @@ config UNICORE32
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2246959..046bf4b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -83,7 +83,6 @@ config X86
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index d0ab5bb..8a3f835 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -10,7 +10,6 @@ config XTENSA
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/init/Makefile b/init/Makefile
index c55eac9..7bc47ee 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -9,7 +9,10 @@ else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
-obj-$(CONFIG_HAVE_GENERIC_INIT_TASK) += init_task.o
+
+ifneq ($(CONFIG_ARCH_INIT_TASK),y)
+obj-y                          += init_task.o
+endif
 
 mounts-y			:= do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o

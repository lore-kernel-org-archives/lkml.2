Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1HBWw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:52:28 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:41662 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1HBWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:52:07 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Richard Henderson <rth@twiddle.net>,
        Mikael Starvik <starvik@axis.com>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 10/19] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
Date: Tue, 02 Aug 2011 18:14:43 -0400
Message-id: <0f579173fd1c9f5dba6703ed8e44a767edf948b5.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

cmpxchg() is widely used by lockless code, including NMI-safe lockless
code.  But on some architectures, the cmpxchg() implementation is not
NMI-safe, on these architectures the lockless code may need a
spin_trylock_irqsave() based implementation.

This patch adds a Kconfig option: ARCH_HAVE_NMI_SAFE_CMPXCHG, so that
NMI-safe lockless code can depend on it or provide different
implementation according to it.

On many architectures, cmpxchg is only NMI-safe for several specific
operand sizes. So, ARCH_HAVE_NMI_SAFE_CMPXCHG define in this patch
only guarantees cmpxchg is NMI-safe for sizeof(unsigned long).

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
CC: Richard Henderson <rth@twiddle.net>
CC: Mikael Starvik <starvik@axis.com>
CC: David Howells <dhowells@redhat.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>
CC: Tony Luck <tony.luck@intel.com>
CC: Hirokazu Takata <takata@linux-m32r.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michal Simek <monstr@monstr.eu>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Chen Liqin <liqin.chen@sunplusct.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@redhat.com>
CC: Chris Zankel <chris@zankel.net>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/Kconfig         |    3 +++
 arch/alpha/Kconfig   |    1 +
 arch/avr32/Kconfig   |    1 +
 arch/frv/Kconfig     |    1 +
 arch/ia64/Kconfig    |    1 +
 arch/m68k/Kconfig    |    1 +
 arch/parisc/Kconfig  |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/s390/Kconfig    |    1 +
 arch/sh/Kconfig      |    1 +
 arch/sparc/Kconfig   |    1 +
 arch/tile/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 13 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 26b0e23..4b0669c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -178,4 +178,7 @@ config HAVE_ARCH_MUTEX_CPU_RELAX
 config HAVE_RCU_TABLE_FREE
 	bool
 
+config ARCH_HAVE_NMI_SAFE_CMPXCHG
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 60219bf..23f8d8c 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -13,6 +13,7 @@ config ALPHA
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index e9d689b..197e96f 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	select GENERIC_IRQ_PROBE
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index cb884e4..bad27a6 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -7,6 +7,7 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 config ZONE_DMA
 	bool
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 38280ef..b1227dd 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -27,6 +27,7 @@ config IA64
 	select GENERIC_PENDING_IRQ if SMP
 	select IRQ_PER_CPU
 	select GENERIC_IRQ_SHOW
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index d66e34c..effe8f0 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	select GENERIC_ATOMIC64 if MMU
 	select HAVE_GENERIC_HARDIRQS if !MMU
 	select GENERIC_IRQ_SHOW if !MMU
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 65adc86..e077b0b 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -15,6 +15,7 @@ config PARISC
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2729c66..e55f754 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -134,6 +134,7 @@ config PPC
 	select GENERIC_IRQ_SHOW_LEVEL
 	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_SYSCALL_TRACEPOINTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c03fef7..0f98bbd 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -81,6 +81,7 @@ config S390
 	select INIT_ALL_POSSIBLE
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index bbdeb48..66405eb 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -11,6 +11,7 @@ config SUPERH
 	select HAVE_DMA_ATTRS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 253986b..a63cddf 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -53,6 +53,7 @@ config SPARC64
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select IRQ_PREFLOW_FASTEOI
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 0249b8b..b30f71a 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -12,6 +12,7 @@ config TILE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if !M386
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..a680a60 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -70,6 +70,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
-- 
1.7.6.396.ge0613


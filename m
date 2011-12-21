Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1LUQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:27:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab1LUQ1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:27:11 -0500
Date: Wed, 21 Dec 2011 18:29:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 01/16] lib: move GENERIC_IOMAP to lib/Kconfig
Message-ID: <80c8c1d0eae918c30a79c07143c5bffff57b253f.1324484752.git.mst@redhat.com>
References: <cover.1324484752.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1324484752.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define GENERIC_IOMAP in a central location
instead of all architectures. This will be helpful
for the follow-up patch which makes it select
other configs. Code is also a bit shorter this way.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Jonas Bonn <jonas@southpole.se>
---
 arch/alpha/Kconfig             |    4 ----
 arch/cris/Kconfig              |    5 +----
 arch/hexagon/Kconfig           |    4 +---
 arch/ia64/Kconfig              |    5 +----
 arch/m68k/Kconfig              |    4 +---
 arch/openrisc/Kconfig          |    3 ---
 arch/powerpc/platforms/Kconfig |    3 ---
 arch/score/Kconfig             |    4 +---
 arch/sh/Kconfig                |    3 ---
 arch/unicore32/Kconfig         |    4 +---
 arch/x86/Kconfig               |    4 +---
 lib/Kconfig                    |    3 +++
 12 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 3d74801..3636b11 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -70,10 +70,6 @@ config GENERIC_ISA_DMA
 	bool
 	default y
 
-config GENERIC_IOMAP
-	bool
-	default n
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 408b055..b3abfb0 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -19,10 +19,6 @@ config GENERIC_CMOS_UPDATE
 config ARCH_USES_GETTIMEOFFSET
 	def_bool n
 
-config GENERIC_IOMAP
-       bool
-       default y
-
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
@@ -52,6 +48,7 @@ config CRIS
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IOMAP
 
 config HZ
 	int
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 02513c2..9059e39 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -26,6 +26,7 @@ config HEXAGON
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select NO_IOPORT
+	select GENERIC_IOMAP
 	# mostly generic routines, with some accelerated ones
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
@@ -73,9 +74,6 @@ config GENERIC_CSUM
 config GENERIC_IRQ_PROBE
 	def_bool y
 
-config GENERIC_IOMAP
-	def_bool y
-
 #config ZONE_DMA
 #	bool
 #	default y
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 27489b6..2732e1b 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -29,6 +29,7 @@ config IA64
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_IOMAP
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -102,10 +103,6 @@ config EFI
 	bool
 	default y
 
-config GENERIC_IOMAP
-	bool
-	default y
-
 config ARCH_CLOCKSOURCE_DATA
 	def_bool y
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 361d540..973e686 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -38,9 +38,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_IOMAP
-	def_bool MMU
-
 config TIME_LOW_RES
 	bool
 	default y
@@ -73,6 +70,7 @@ source "kernel/Kconfig.freezer"
 config MMU
 	bool "MMU-based Paged Memory Management Support"
 	default y
+	select GENERIC_IOMAP
 	help
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index e518a5a..081a54f 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -38,9 +38,6 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_IOMAP
-	def_bool y
-
 config NO_IOPORT
 	def_bool y
 
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 3fe6d92..100feed 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -175,9 +175,6 @@ config PPC_INDIRECT_MMIO
 config PPC_IO_WORKAROUNDS
 	bool
 
-config GENERIC_IOMAP
-	bool
-
 source "drivers/cpufreq/Kconfig"
 
 menu "CPU Frequency drivers"
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index df169e8..455ce2d 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -4,6 +4,7 @@ config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
+       select GENERIC_IOMAP
 
 choice
 	prompt "System type"
@@ -33,9 +34,6 @@ endmenu
 config CPU_SCORE7
 	bool
 
-config GENERIC_IOMAP
-	def_bool y
-
 config NO_DMA
 	bool
 	default y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5629e20..5aeab58 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -84,9 +84,6 @@ config GENERIC_GPIO
 config GENERIC_CALIBRATE_DELAY
 	bool
 
-config GENERIC_IOMAP
-	bool
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 942ed61..eeb8054 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -12,6 +12,7 @@ config UNICORE32
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
+	select GENERIC_IOMAP
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
@@ -30,9 +31,6 @@ config GENERIC_CLOCKEVENTS
 config GENERIC_CSUM
 	def_bool y
 
-config GENERIC_IOMAP
-	def_bool y
-
 config NO_IOPORT
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efb4294..1b90fc4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -75,6 +75,7 @@ config X86
 	select HAVE_BPF_JIT if (X86_64 && NET)
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_IOMAP
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -140,9 +141,6 @@ config NEED_SG_DMA_LENGTH
 config GENERIC_ISA_DMA
 	def_bool ISA_DMA_API
 
-config GENERIC_IOMAP
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 	depends on BUG
diff --git a/lib/Kconfig b/lib/Kconfig
index 32f3e5a..0058927 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -19,6 +19,9 @@ config RATIONAL
 config GENERIC_FIND_FIRST_BIT
 	bool
 
+config GENERIC_IOMAP
+	bool
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
-- 
1.7.8.382.g3daff


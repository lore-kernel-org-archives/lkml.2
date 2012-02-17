Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2BQMIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:08:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50955 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2BQMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:08:22 -0500
Subject: [PATCH] mm: add config NUMA stub to all architectures
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 Feb 2012 16:08:15 +0400
Message-ID: <20120217120815.25909.15632.stgit@zurg>
In-Reply-To: <4F3E42E0.4030108@openvz.org>
References: <4F3E42E0.4030108@openvz.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Config NUMA must be defined for all architectures,
otherwise IS_ENABLED(CONFIG_NUMA) does not work.
Some arch-specific Kconfig already has this stub.
This patch adds it to all remaining.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 arch/arm/Kconfig        |    3 +++
 arch/avr32/Kconfig      |    2 ++
 arch/blackfin/Kconfig   |    3 +++
 arch/cris/Kconfig       |    3 +++
 arch/frv/Kconfig        |    3 +++
 arch/h8300/Kconfig      |    3 +++
 arch/hexagon/Kconfig    |    3 +++
 arch/m68k/Kconfig       |    3 +++
 arch/microblaze/Kconfig |    3 +++
 arch/openrisc/Kconfig   |    3 +++
 arch/parisc/Kconfig     |    3 +++
 arch/s390/Kconfig       |    3 +++
 arch/score/Kconfig      |    3 +++
 arch/um/Kconfig.common  |    3 +++
 arch/unicore32/Kconfig  |    3 +++
 arch/xtensa/Kconfig     |    3 +++
 16 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a48aecc..42d610b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -246,6 +246,9 @@ config MMU
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
 
+config NUMA
+	def_bool n
+
 #
 # The "ARM system type" choice list is ordered alphabetically by option
 # text.  Please add new entries in the option alphabetic order.
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 3dea7231..3d0cd3c 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -69,6 +69,8 @@ config SUBARCH_AVR32B
 	bool
 config MMU
 	bool
+config NUMA
+	def_bool n
 config PERFORMANCE_COUNTERS
 	bool
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index abe5a9e..9e60636 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -5,6 +5,9 @@ config SYMBOL_PREFIX
 config MMU
 	def_bool n
 
+config NUMA
+	def_bool n
+
 config FPU
 	def_bool n
 
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index b3abfb0..85c8271 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -2,6 +2,9 @@ config MMU
 	bool
 	default y
 
+config NUMA
+	def_bool n
+
 config ZONE_DMA
 	bool
 	default y
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index a685910..3a3e3c9 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -64,6 +64,9 @@ config MMU
 	  CPUs support this. Currently only the FR451 has a sufficiently
 	  featured MMU.
 
+config NUMA
+	def_bool n
+
 config FRV_OUTOFLINE_ATOMIC_OPS
 	bool "Out-of-line the FRV atomic operations"
 	default n
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 56e890d..2ccd6ff 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -14,6 +14,9 @@ config MMU
 	bool
 	default n
 
+config NUMA
+	def_bool n
+
 config SWAP
 	bool
 	default n
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 9059e39..c6be112 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -62,6 +62,9 @@ config KTIME_SCALAR
 config MMU
 	def_bool y
 
+config NUMA
+	def_bool n
+
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index ae413d4..b5e0e6a 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -84,6 +84,9 @@ config MMU
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
 
+config NUMA
+	def_bool n
+
 config MMU_MOTOROLA
 	bool
 
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index c8d6efb..c4c1218 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -86,6 +86,9 @@ config NO_MMU
 	depends on !MMU
 	default y
 
+config NUMA
+	def_bool n
+
 comment "Boot options"
 
 config CMDLINE_BOOL
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index bc428b5..f3fe483 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -20,6 +20,9 @@ config OPENRISC
 config MMU
 	def_bool y
 
+config NUMA
+	def_bool n
+
 config SYMBOL_PREFIX
         string
         default ""
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 242a1b7..a4ab0d5 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -27,6 +27,9 @@ config PARISC
 config MMU
 	def_bool y
 
+config NUMA
+	def_bool n
+
 config STACK_GROWSUP
 	def_bool y
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d172758..27da802 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -1,6 +1,9 @@
 config MMU
 	def_bool y
 
+config NUMA
+	def_bool n
+
 config ZONE_DMA
 	def_bool y
 
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4b28577..ad4d3a1 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -88,6 +88,9 @@ source "init/Kconfig"
 config MMU
 	def_bool y
 
+config NUMA
+	def_bool n
+
 menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index b37ae70..702cbde 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -14,6 +14,9 @@ config MMU
 	bool
 	default y
 
+config NUMA
+	def_bool n
+
 config NO_IOMEM
 	def_bool y
 
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..6a845d4 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -79,6 +79,9 @@ menu "System Type"
 config MMU
 	def_bool y
 
+config NUMA
+	def_bool n
+
 config ARCH_FPGA
 	bool
 
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 8a3f835..bb52e90 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -46,6 +46,9 @@ source "kernel/Kconfig.freezer"
 config MMU
 	def_bool n
 
+config NUMA
+	def_bool n
+
 config VARIANT_IRQ_SWITCH
 	def_bool n
 


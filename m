Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2LEQJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:51 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51591 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2LEQJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:45 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 36/44] Add metag to various Kconfig dependency lists
Date: Wed, 5 Dec 2012 16:08:54 +0000
Message-ID: <1354723742-6195-37-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add [!]METAG to various Kconfig dependencies in generic code, as
described below:

 - Kconfig.debug: don't allow stack utilization instrumentation on
        metag, and allow building with frame pointers.

 - char: don't build rtc or genrtc on METAG
	The metag architecture doesn't have a PC RTC or implement the
	RTC interface that genrtc expects, so add METAG to the list of
	architectures not to build RTC or GEN_RTC on.

 - i8042: don't build on METAG
	The metag architecture port doesn't support the i8042 keyboard
	controller, so add METAG to the list of architectures not to
	build it's driver on.

 - parport: don't build on METAG
	The metag architecture port doesn't support PC parallel ports,
	so add METAG to the list of architectures not to build it's
	driver on.

 - vga console: don't build on METAG
	The metag architecture doesn't support VGA so add METAG to the
	list of architectures not to build support on.

TODO: invert the dependency logic of most of these with the help of a
      new LEGACY_PC_IO Kconfig symbol

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/char/Kconfig          |    5 +++--
 drivers/input/serio/Kconfig   |    2 +-
 drivers/parport/Kconfig       |    3 ++-
 drivers/video/console/Kconfig |    2 +-
 lib/Kconfig.debug             |    4 ++--
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 72bedad..59f7d70 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -283,7 +283,8 @@ if RTC_LIB=n
 config RTC
 	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
-			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN && !UML
+			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN \
+			&& !UML && !METAG
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -331,7 +332,7 @@ config JS_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN && !UML
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN && !UML && !METAG
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 55f2c22..60b2a09 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,7 @@ config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !METAG
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 4b6e4e7..ff2cea5 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -36,7 +36,8 @@ if PARPORT
 config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
-		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && !XTENSA
+		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && \
+		!XTENSA && !METAG
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index e2c96d0..3ee55e1 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -6,7 +6,7 @@ menu "Console display driver support"
 
 config VGA_CONSOLE
 	bool "VGA text console" if EXPERT || !X86
-	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
+	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER) && !METAG
 	default y
 	help
 	  Saying Y here will allow you to use Linux in text mode through a
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28e9d6c9..445fbe6 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -730,7 +730,7 @@ config STACKTRACE
 
 config DEBUG_STACK_USAGE
 	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL && !IA64 && !PARISC
+	depends on DEBUG_KERNEL && !IA64 && !PARISC && !METAG
 	help
 	  Enables the display of the minimum amount of free stack which each
 	  task has ever had available in the sysrq-T and sysrq-P debug output.
@@ -911,7 +911,7 @@ config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
 		(CRIS || M68K || FRV || UML || \
-		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || \
 		ARCH_WANT_FRAME_POINTERS
 	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
 	help
-- 
1.7.7.6



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2IBRDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 13:03:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39144 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754204Ab2IBRDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 13:03:04 -0400
Message-ID: <1346605381.16620.5.camel@joe2Laptop>
Subject: [RFC PATCH] Kconfig: Make EARLY_PRINTK "depends on" PRINTK
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Richard Kuo <rkuo@codeaurora.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 02 Sep 2012 10:03:01 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While breaking up what I think is the overly large printk.c,
this non-dependency between CONFIG_PRINTK and CONFIG_EARLY_PRINTK
showed up.

Perhaps CONFIG_EARLY_PRINTK should be marked "depends on" PRINTK.

Uncompiled, untested.

---

 arch/alpha/Kconfig.debug      |    2 +-
 arch/arm/Kconfig.debug        |    2 +-
 arch/blackfin/Kconfig.debug   |    1 +
 arch/hexagon/Kconfig          |    1 +
 arch/m68k/Kconfig.debug       |    2 +-
 arch/microblaze/Kconfig.debug |    2 +-
 arch/mips/Kconfig.debug       |    2 +-
 arch/powerpc/Kconfig          |    1 +
 arch/tile/Kconfig.debug       |    1 +
 arch/um/Kconfig.debug         |    1 +
 arch/unicore32/Kconfig.debug  |    1 +
 arch/x86/Kconfig.debug        |    1 +
 12 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/Kconfig.debug b/arch/alpha/Kconfig.debug
index 3f6265f..7f051ec 100644
--- a/arch/alpha/Kconfig.debug
+++ b/arch/alpha/Kconfig.debug
@@ -4,7 +4,7 @@ source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool
-	depends on ALPHA_GENERIC || ALPHA_SRM
+	depends on (ALPHA_GENERIC || ALPHA_SRM) && PRINTK
 	default y
 
 config ALPHA_LEGACY_START_ADDRESS
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index f15f82b..ce6d532 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -375,7 +375,7 @@ endchoice
 
 config EARLY_PRINTK
 	bool "Early printk"
-	depends on DEBUG_LL
+	depends on DEBUG_LL && PRINTK
 	help
 	  Say Y here if you want to have an early console using the
 	  kernel low-level debugging functions. Add earlyprintk to your
diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
index 7959469..292bb2b 100644
--- a/arch/blackfin/Kconfig.debug
+++ b/arch/blackfin/Kconfig.debug
@@ -202,6 +202,7 @@ config DEBUG_BFIN_NO_KERN_HWTRACE
 
 config EARLY_PRINTK
 	bool "Early printk" 
+	depends on PRINTK
 	default n
 	select SERIAL_CORE_CONSOLE
 	help
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index b2fdfb7..30b84c9 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -57,6 +57,7 @@ config PCI
 
 config EARLY_PRINTK
 	def_bool y
+	depends on PRINTK
 
 config MMU
 	def_bool y
diff --git a/arch/m68k/Kconfig.debug b/arch/m68k/Kconfig.debug
index 87233ac..cb47cbb 100644
--- a/arch/m68k/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@ -12,7 +12,7 @@ config BOOTPARAM_STRING
 
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED
-	depends on MVME16x || MAC
+	depends on (MVME16x || MAC) && PRINTK
 	default y
 	help
           Write kernel log output directly to a serial port.
diff --git a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
index 012e377..2f60150 100644
--- a/arch/microblaze/Kconfig.debug
+++ b/arch/microblaze/Kconfig.debug
@@ -10,7 +10,7 @@ source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool "Early printk function for kernel"
-	depends on SERIAL_UARTLITE_CONSOLE || SERIAL_8250_CONSOLE
+	depends on (SERIAL_UARTLITE_CONSOLE || SERIAL_8250_CONSOLE) && PRINTK
 	default n
 	help
 	  This option turns on/off early printk messages to console.
diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 5a43aa0..f9338da 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -8,7 +8,7 @@ source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool "Early printk" if EXPERT
-	depends on SYS_HAS_EARLY_PRINTK
+	depends on SYS_HAS_EARLY_PRINTK && PRINTK
 	default y
 	help
 	  This option enables special console drivers which allow the kernel
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 352f416..6ba5995 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -142,6 +142,7 @@ config PPC
 
 config EARLY_PRINTK
 	bool
+	depends on PRINTK
 	default y
 
 config COMPAT
diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index ddbfc33..be306cc 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -4,6 +4,7 @@ source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool "Early printk" if EXPERT && DEBUG_KERNEL
+	depends on PRINTK
 	default y
 	help
 	  Write kernel log output directly via the hypervisor console.
diff --git a/arch/um/Kconfig.debug b/arch/um/Kconfig.debug
index 68205fd..d3f7567 100644
--- a/arch/um/Kconfig.debug
+++ b/arch/um/Kconfig.debug
@@ -30,6 +30,7 @@ config GCOV
 
 config EARLY_PRINTK
 	bool "Early printk"
+	depends on PRINTK
 	default y
 	---help---
 	  Write kernel log output directly to stdout.
diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
index 1a36262..98f644c 100644
--- a/arch/unicore32/Kconfig.debug
+++ b/arch/unicore32/Kconfig.debug
@@ -18,6 +18,7 @@ config STRICT_DEVMEM
 
 config EARLY_PRINTK
 	def_bool DEBUG_OCD
+	depends on PRINTK
 	help
 	  Write kernel log output directly into the ocd or to a serial port.
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..185fd51 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -32,6 +32,7 @@ config X86_VERBOSE_BOOTUP
 
 config EARLY_PRINTK
 	bool "Early printk" if EXPERT
+	depends on PRINTK
 	default y
 	---help---
 	  Write kernel log output directly into the VGA buffer or to a serial



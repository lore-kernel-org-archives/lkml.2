Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2KMRx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:53:58 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39327 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753884Ab2KMRx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:53:56 -0500
Message-ID: <1352829239.24230.45.camel@joe-AO722>
Subject: [TRIVIAL PATCH] treewide: Kconfig Make EARLY_PRINTK and TTY_PRINTK
 "depends on" PRINTK
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Nov 2012 09:53:59 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dependency on PRINTK for these 2 CONFIG options

Signed-off-by: Joe Perches <joe@perches.com>
---
Add bcc's for the affected arch maintainers to avoid long recipient list

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
 drivers/char/Kconfig          |    2 +-
 13 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/Kconfig.debug b/arch/alpha/Kconfig.debug
index 3f6265f..499d414 100644
--- a/arch/alpha/Kconfig.debug
+++ b/arch/alpha/Kconfig.debug
@@ -4,7 +4,7 @@ source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool
-	depends on ALPHA_GENERIC || ALPHA_SRM
+	depends on PRINTK && (ALPHA_GENERIC || ALPHA_SRM)
 	default y
 
 config ALPHA_LEGACY_START_ADDRESS
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b0f3857..7decd48 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -422,7 +422,7 @@ config DEBUG_LL_INCLUDE
 
 config EARLY_PRINTK
 	bool "Early printk"
-	depends on DEBUG_LL
+	depends on PRINTK && DEBUG_LL
 	help
 	  Say Y here if you want to have an early console using the
 	  kernel low-level debugging functions. Add earlyprintk to your
diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
index 7959469..2b30f15 100644
--- a/arch/blackfin/Kconfig.debug
+++ b/arch/blackfin/Kconfig.debug
@@ -203,6 +203,7 @@ config DEBUG_BFIN_NO_KERN_HWTRACE
 config EARLY_PRINTK
 	bool "Early printk" 
 	default n
+	depends on PRINTK
 	select SERIAL_CORE_CONSOLE
 	help
 	  This option enables special console drivers which allow the kernel
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 0744f7d..5dabc6d 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -58,6 +58,7 @@ config PCI
 
 config EARLY_PRINTK
 	def_bool y
+	depends on PRINTK
 
 config MMU
 	def_bool y
diff --git a/arch/m68k/Kconfig.debug b/arch/m68k/Kconfig.debug
index 87233ac..4188fff 100644
--- a/arch/m68k/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@ -12,7 +12,7 @@ config BOOTPARAM_STRING
 
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED
-	depends on MVME16x || MAC
+	depends on PRINTK && (MVME16x || MAC)
 	default y
 	help
           Write kernel log output directly to a serial port.
diff --git a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
index 012e377..60c4dc5 100644
--- a/arch/microblaze/Kconfig.debug
+++ b/arch/microblaze/Kconfig.debug
@@ -10,7 +10,7 @@ source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool "Early printk function for kernel"
-	depends on SERIAL_UARTLITE_CONSOLE || SERIAL_8250_CONSOLE
+	depends on PRINTK && (SERIAL_UARTLITE_CONSOLE || SERIAL_8250_CONSOLE)
 	default n
 	help
 	  This option turns on/off early printk messages to console.
diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 5a43aa0..3d783b3 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -8,7 +8,7 @@ source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool "Early printk" if EXPERT
-	depends on SYS_HAS_EARLY_PRINTK
+	depends on PRINTK && SYS_HAS_EARLY_PRINTK
 	default y
 	help
 	  This option enables special console drivers which allow the kernel
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a902a5c..8e7bf97 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -148,6 +148,7 @@ config PPC
 config EARLY_PRINTK
 	bool
 	default y
+	depends on PRINTK
 
 config COMPAT
 	bool
diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index ddbfc33..5d6d3f4 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -5,6 +5,7 @@ source "lib/Kconfig.debug"
 config EARLY_PRINTK
 	bool "Early printk" if EXPERT && DEBUG_KERNEL
 	default y
+	depends on PRINTK
 	help
 	  Write kernel log output directly via the hypervisor console.
 
diff --git a/arch/um/Kconfig.debug b/arch/um/Kconfig.debug
index 68205fd..3c9d82d 100644
--- a/arch/um/Kconfig.debug
+++ b/arch/um/Kconfig.debug
@@ -31,6 +31,7 @@ config GCOV
 config EARLY_PRINTK
 	bool "Early printk"
 	default y
+	depends on PRINTK
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
index b322f12..989e572 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -33,6 +33,7 @@ config X86_VERBOSE_BOOTUP
 config EARLY_PRINTK
 	bool "Early printk" if EXPERT
 	default y
+	depends on PRINTK
 	---help---
 	  Write kernel log output directly into the VGA buffer or to a serial
 	  port.
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 72bedad..1e91c26 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -53,7 +53,7 @@ source "drivers/tty/serial/Kconfig"
 
 config TTY_PRINTK
 	bool "TTY driver to output user messages via printk"
-	depends on EXPERT
+	depends on EXPERT && PRINTK
 	default n
 	---help---
 	  If you say Y here, the support for writing user messages (i.e.



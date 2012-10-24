Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499Ab2JXSyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:54:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45621 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934943Ab2JXSyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:54:17 -0400
Message-ID: <1351104856.24165.9.camel@joe-AO722>
Subject: Re: mmotm 2012-10-22-17-08 uploaded (printk build errors)
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Date: Wed, 24 Oct 2012 11:54:16 -0700
In-Reply-To: <5085F14D.7060005@xenotime.net>
References: <20121023000924.C56EF5C0050@hpza9.eem.corp.google.com>
	 <5085F14D.7060005@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 18:22 -0700, Randy Dunlap wrote:

> on i386, when CONFIG_PRINTK is not enabled:
> 
> note:  some of these build errors could result from my use of
> -sik (keep going, ignore build errors).
> 
> 
> case 1.  CONFIG_TTY_PRINTK=y, CONFIG_EARLY_PRINTK=y
> 
> see config-r8272

[]

> case 2.  CONFIG_TTY_PRINTK=n, CONFIG_EARLY_PRINTK=n
> 
> see config-r8274

[]

Shouldn't CONFIG_EARLY_PRINTK and CONFIG_TTY_PRINTK
be marked
	depends on CONFIG_PRINTK
?

 arch/alpha/Kconfig.debug      | 2 +-
 arch/arm/Kconfig.debug        | 2 +-
 arch/blackfin/Kconfig.debug   | 1 +
 arch/hexagon/Kconfig          | 1 +
 arch/m68k/Kconfig.debug       | 2 +-
 arch/microblaze/Kconfig.debug | 2 +-
 arch/mips/Kconfig.debug       | 2 +-
 arch/powerpc/Kconfig          | 1 +
 arch/tile/Kconfig.debug       | 1 +
 arch/um/Kconfig.debug         | 1 +
 arch/unicore32/Kconfig.debug  | 1 +
 arch/x86/Kconfig.debug        | 1 +
 drivers/char/Kconfig          | 2 +-
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
index a902a5c..787abc4 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -147,6 +147,7 @@ config PPC
 
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
index b322f12..0800387 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -32,6 +32,7 @@ config X86_VERBOSE_BOOTUP
 
 config EARLY_PRINTK
 	bool "Early printk" if EXPERT
+	depends_on PRINTK
 	default y
 	---help---
 	  Write kernel log output directly into the VGA buffer or to a serial
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



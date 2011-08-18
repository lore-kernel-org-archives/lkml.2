Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1HRTME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:12:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48376 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1HRTMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:12:01 -0400
Date: Thu, 18 Aug 2011 20:11:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 78/91] um: switch to use of drivers/Kconfig
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu80V-00083a-Uk@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Kconfig.rest           |   23 +----------------------
 drivers/char/Kconfig           |    6 +++---
 drivers/char/ttyprintk.c       |    2 +-
 drivers/input/Kconfig          |    2 +-
 drivers/isdn/Kconfig           |    2 +-
 drivers/misc/Kconfig           |    1 +
 drivers/power/Kconfig          |    1 +
 drivers/rtc/Kconfig            |    2 +-
 drivers/tty/Kconfig            |    2 +-
 drivers/watchdog/Kconfig       |    2 +-
 security/integrity/ima/Kconfig |    2 +-
 sound/Kconfig                  |    2 +-
 12 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/arch/um/Kconfig.rest b/arch/um/Kconfig.rest
index 0ccad0f..567eb5f 100644
--- a/arch/um/Kconfig.rest
+++ b/arch/um/Kconfig.rest
@@ -2,20 +2,14 @@ source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
 
-source "drivers/block/Kconfig"
-
 source "arch/um/Kconfig.char"
 
-source "drivers/base/Kconfig"
+source "drivers/Kconfig"
 
 source "net/Kconfig"
 
 source "arch/um/Kconfig.net"
 
-source "drivers/net/Kconfig"
-
-source "drivers/connector/Kconfig"
-
 source "fs/Kconfig"
 
 source "security/Kconfig"
@@ -24,19 +18,4 @@ source "crypto/Kconfig"
 
 source "lib/Kconfig"
 
-source "drivers/scsi/Kconfig"
-
-source "drivers/md/Kconfig"
-
-if BROKEN
-	source "drivers/mtd/Kconfig"
-endif
-
-source "drivers/leds/Kconfig"
-
-#This is just to shut up some Kconfig warnings, so no prompt.
-config INPUT
-	tristate
-	default n
-
 source "arch/um/Kconfig.debug"
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 423fd56..4364303 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -298,7 +298,7 @@ if RTC_LIB=n
 config RTC
 	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
-			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN
+			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN && !UML
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -346,7 +346,7 @@ config JS_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN && !UML
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -490,7 +490,7 @@ config SCx200_GPIO
 
 config PC8736x_GPIO
 	tristate "NatSemi PC8736x GPIO Support"
-	depends on X86_32
+	depends on X86_32 && !UML
 	default SCx200_GPIO	# mostly N
 	select NSC_GPIO		# needed for support routines
 	help
diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index a1f68af..f228615 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -170,7 +170,7 @@ static const struct tty_operations ttyprintk_ops = {
 	.ioctl = tpk_ioctl,
 };
 
-struct tty_port_operations null_ops = { };
+static struct tty_port_operations null_ops = { };
 
 static struct tty_driver *ttyprintk_driver;
 
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 23e82e4..001b147 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Input device support"
-	depends on !S390
+	depends on !S390 && !UML
 
 config INPUT
 	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EXPERT
diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index 4fb6016..a233ed5 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -5,7 +5,7 @@
 menuconfig ISDN
 	bool "ISDN support"
 	depends on NET
-	depends on !S390
+	depends on !S390 && !UML
 	---help---
 	  ISDN ("Integrated Services Digital Network", called RNIS in France)
 	  is a fully digital telephone service that can be used for voice and
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0a4d86c..4447ea3 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -146,6 +146,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+	depends on HAS_IOMEM
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 57de051..9f88641 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -70,6 +70,7 @@ config BATTERY_DS2760
 
 config BATTERY_DS2780
 	tristate "DS2780 battery driver"
+	depends on HAS_IOMEM
 	select W1
 	select W1_SLAVE_DS2780
 	help
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 5a538fc..53eb4e5 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -8,7 +8,7 @@ config RTC_LIB
 menuconfig RTC_CLASS
 	bool "Real Time Clock"
 	default n
-	depends on !S390
+	depends on !S390 && !UML
 	select RTC_LIB
 	help
 	  Generic RTC class support. If you say yes here, you will
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index bd7cc05..aa07914 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -1,6 +1,6 @@
 config VT
 	bool "Virtual terminal" if EXPERT
-	depends on !S390
+	depends on !S390 && !UML
 	select INPUT
 	default y
 	---help---
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 86b0735..be740ce 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -726,7 +726,7 @@ config SBC8360_WDT
 
 config SBC7240_WDT
 	tristate "SBC Nano 7240 Watchdog Timer"
-	depends on X86_32
+	depends on X86_32 && !UML
 	---help---
 	  This is the driver for the hardware watchdog found on the IEI
 	  single board computers EPIC Nano 7240 (and likely others). This
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index b6ecfd4..5294d73 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -8,7 +8,7 @@ config IMA
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select TCG_TPM if !S390
+	select TCG_TPM if !S390 && !UML
 	select TCG_TIS if TCG_TPM
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
diff --git a/sound/Kconfig b/sound/Kconfig
index 1fef141..261a03c 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -59,7 +59,7 @@ config SOUND_OSS_CORE_PRECLAIM
 
 source "sound/oss/dmasound/Kconfig"
 
-if !M68K
+if !M68K && !UML
 
 menuconfig SND
 	tristate "Advanced Linux Sound Architecture"
-- 
1.7.2.5



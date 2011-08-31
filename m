Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1HaTha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:37:30 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:41704 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1HaTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:37:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH "find-renames version" 4/4] TTY: serial, move 68360 driver to staging
Date: Wed, 31 Aug 2011 21:37:24 +0200
Message-Id: <1314819444-11864-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314819086.30506.3.camel@lappy>
References: <1314819086.30506.3.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been broken at least since 2008. At that time,
a88487c79b (Fix compile errors in SGI console drivers) broke this
driver completely.

And since nobody noticed for the past 3 years, move it into staging. I
think this will rot there and we will throw it away completely after
some time. Or maybe someone will volunteer to fix it ;).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alan Cox <alan@linux.intel.com>
---

 *********
 Just attaching with --find-renames for clarity...
 *********

 drivers/staging/Kconfig                       |    2 ++
 drivers/staging/Makefile                      |    1 +
 drivers/{tty => staging}/serial/68360serial.c |    0
 drivers/staging/serial/Kconfig                |   16 ++++++++++++++++
 drivers/staging/serial/Makefile               |    1 +
 drivers/staging/serial/TODO                   |    6 ++++++
 drivers/tty/serial/Kconfig                    |   17 -----------------
 drivers/tty/serial/Makefile                   |    1 -
 8 files changed, 26 insertions(+), 18 deletions(-)
 rename drivers/{tty => staging}/serial/68360serial.c (100%)
 create mode 100644 drivers/staging/serial/Kconfig
 create mode 100644 drivers/staging/serial/Makefile
 create mode 100644 drivers/staging/serial/TODO

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index eac0a7f..cb3b60d 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -24,6 +24,8 @@ menuconfig STAGING
 
 if STAGING
 
+source "drivers/staging/serial/Kconfig"
+
 source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 20be112..1d865d2 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -3,6 +3,7 @@
 # fix for build system bug...
 obj-$(CONFIG_STAGING)		+= staging.o
 
+obj-y				+= serial/
 obj-$(CONFIG_ET131X)		+= et131x/
 obj-$(CONFIG_SLICOSS)		+= slicoss/
 obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
diff --git a/drivers/tty/serial/68360serial.c b/drivers/staging/serial/68360serial.c
similarity index 100%
rename from drivers/tty/serial/68360serial.c
rename to drivers/staging/serial/68360serial.c
diff --git a/drivers/staging/serial/Kconfig b/drivers/staging/serial/Kconfig
new file mode 100644
index 0000000..9489688
--- /dev/null
+++ b/drivers/staging/serial/Kconfig
@@ -0,0 +1,16 @@
+config SERIAL_68360_SMC
+	bool "68360 SMC uart support"
+	depends on M68360
+	help
+	  This driver supports the SMC serial ports of the Motorola 68360 CPU.
+
+config SERIAL_68360_SCC
+	bool "68360 SCC uart support"
+	depends on M68360
+	help
+	  This driver supports the SCC serial ports of the Motorola 68360 CPU.
+
+config SERIAL_68360
+	bool
+	depends on SERIAL_68360_SMC || SERIAL_68360_SCC
+	default y
diff --git a/drivers/staging/serial/Makefile b/drivers/staging/serial/Makefile
new file mode 100644
index 0000000..37a6a0b
--- /dev/null
+++ b/drivers/staging/serial/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SERIAL_68360) += 68360serial.o
diff --git a/drivers/staging/serial/TODO b/drivers/staging/serial/TODO
new file mode 100644
index 0000000..a19cda8
--- /dev/null
+++ b/drivers/staging/serial/TODO
@@ -0,0 +1,6 @@
+These are a few serial drivers that either do not build, or do not work if they
+do build, or if they seem to work, are for obsolete hardware, or are full of
+unfixable races and no one uses them anymore.
+
+If no one steps up to adopt any of these drivers, they will be removed
+in the 3.4 release.
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 10babe2..4cbb5a5 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1035,23 +1035,6 @@ config SERIAL_MCF_CONSOLE
 	help
 	  Enable a ColdFire internal serial port to be the system console.
 
-config SERIAL_68360_SMC
-	bool "68360 SMC uart support"
-	depends on M68360
-	help
-	  This driver supports the SMC serial ports of the Motorola 68360 CPU.
-
-config SERIAL_68360_SCC
-	bool "68360 SCC uart support"
-	depends on M68360
-	help
-	  This driver supports the SCC serial ports of the Motorola 68360 CPU.
-
-config SERIAL_68360
-	bool
-	depends on SERIAL_68360_SMC || SERIAL_68360_SCC
-	default y
-
 config SERIAL_PMACZILOG
 	tristate "Mac or PowerMac z85c30 ESCC support"
 	depends on (M68K && MAC) || (PPC_OF && PPC_PMAC)
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 7874813..3644de5 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -49,7 +49,6 @@ obj-$(CONFIG_SERIAL_MAX3107_AAVA) += max3107-aava.o
 obj-$(CONFIG_SERIAL_IP22_ZILOG) += ip22zilog.o
 obj-$(CONFIG_SERIAL_MUX) += mux.o
 obj-$(CONFIG_SERIAL_68328) += 68328serial.o
-obj-$(CONFIG_SERIAL_68360) += 68360serial.o
 obj-$(CONFIG_SERIAL_MCF) += mcf.o
 obj-$(CONFIG_SERIAL_PMACZILOG) += pmac_zilog.o
 obj-$(CONFIG_SERIAL_DZ) += dz.o
-- 
1.7.6.1



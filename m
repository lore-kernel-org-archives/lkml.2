Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0H2VH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 17:07:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab0H2VGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 17:06:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/5] tty: rearrange Kconfig structure
Date: Sun, 29 Aug 2010 23:06:35 +0200
Message-Id: <1283115995-4734-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283115995-4734-1-git-send-email-arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zGDxAlpzppLkDbzvBYDmN1/OnJdTLYdPFbKNSWSx+CI
 I2tFz1Zh8/vd4+XspAsPUHf4wDfqOI5m5ZSVj5FP/izCl/E06m
 HKDDUrkOn2r7gz+usqX4e6++LVlIBzzihAxTvU8zDTixVwOuma
 +WKpXFlVDBRPIJzHyDgMzcg/hij7uBLaUxPeTs+l156DxuevuZ
 Hwxmdr8aXL9BbSqiVw/cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the layout of Kconfig reflect the
new directory structure for the tty device
drivers.

Most significantly, the tty drivers now have
their own menu below the device drivers menu,
instead of being mixed with the other character
device drivers.

All serial drivers that are still registering
to the tty layer instead of to the serial or
hvc drivers are now in the 'nonstandard serial
port' category.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/cris/Kconfig      |    2 ++
 drivers/Kconfig        |    2 ++
 drivers/char/Kconfig   |   10 ----------
 drivers/tty/Kconfig    |   16 ++++++++++++++++
 drivers/tty/hw/Kconfig |   36 ++++++++++++++++++------------------
 5 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index aefe3b1..71fa087 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -682,6 +682,8 @@ source "drivers/rtc/Kconfig"
 #
 source "drivers/input/Kconfig"
 
+source "drivers/tty/Kconfig"
+
 source "drivers/char/Kconfig"
 
 source "fs/Kconfig"
diff --git a/drivers/Kconfig b/drivers/Kconfig
index a2b902f..f37a125 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -44,6 +44,8 @@ source "drivers/telephony/Kconfig"
 
 source "drivers/input/Kconfig"
 
+source "drivers/tty/Kconfig"
+
 source "drivers/char/Kconfig"
 
 source "drivers/i2c/Kconfig"
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 834fb9e..31a0370 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -4,8 +4,6 @@
 
 menu "Character devices"
 
-source "drivers/tty/vt/Kconfig"
-
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
@@ -15,8 +13,6 @@ config DEVKMEM
 	  kind of kernel debugging operations.
 	  When in doubt, say "N".
 
-source "drivers/tty/hw/Kconfig"
-
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
@@ -39,10 +35,6 @@ config SGI_MBCS
          If you have an SGI Altix with an attached SABrick
          say Y or M here, otherwise say N.
 
-source "drivers/serial/Kconfig"
-
-source "drivers/tty/Kconfig"
-
 config BRIQ_PANEL
 	tristate 'Total Impact briQ front panel driver'
 	depends on PPC_CHRP
@@ -147,8 +139,6 @@ config PPDEV
 
 	  If unsure, say N.
 
-source "drivers/tty/hvc/Kconfig"
-
 config IBM_BSR
 	tristate "IBM POWER Barrier Synchronization Register support"
 	depends on PPC_PSERIES
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index a245618..2bb7262 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -1,3 +1,7 @@
+menu "TTY device drivers"
+
+source "drivers/tty/vt/Kconfig"
+
 config UNIX98_PTYS
 	bool "Unix98 PTY support" if EMBEDDED
 	default y
@@ -63,6 +67,14 @@ config LEGACY_PTY_COUNT
 	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
 	  architectures and 24 bytes on 64-bit architectures.
 
+source "drivers/tty/hvc/Kconfig"
+
+source "drivers/serial/Kconfig"
+
+source "drivers/tty/hw/Kconfig"
+
+menu "Non-standard TTY line disciplines"
+
 config R3964
 	tristate "Siemens R3964 line discipline"
 	---help---
@@ -94,3 +106,7 @@ config N_GSM
 	help
 	  This line discipline provides support for the GSM MUX protocol and
 	  presents the mux as a set of 61 individual tty devices.
+
+endmenu
+
+endmenu
diff --git a/drivers/tty/hw/Kconfig b/drivers/tty/hw/Kconfig
index 4328aa4..cffb96b 100644
--- a/drivers/tty/hw/Kconfig
+++ b/drivers/tty/hw/Kconfig
@@ -1,17 +1,4 @@
-config BFIN_JTAG_COMM
-	tristate "Blackfin JTAG Communication"
-	depends on BLACKFIN
-	help
-	  Add support for emulating a TTY device over the Blackfin JTAG.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bfin_jtag_comm.
-
-config BFIN_JTAG_COMM_CONSOLE
-	bool "Console on Blackfin JTAG"
-	depends on BFIN_JTAG_COMM=y
-
-config SERIAL_NONSTANDARD
+menuconfig SERIAL_NONSTANDARD
 	bool "Non-standard serial port support"
 	depends on HAS_IOMEM
 	---help---
@@ -28,6 +15,19 @@ config SERIAL_NONSTANDARD
 
 	  Most people can say N here.
 
+config BFIN_JTAG_COMM
+	tristate "Blackfin JTAG Communication"
+	depends on BLACKFIN && SERIAL_NONSTANDARD
+	help
+	  Add support for emulating a TTY device over the Blackfin JTAG.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_jtag_comm.
+
+config BFIN_JTAG_COMM_CONSOLE
+	bool "Console on Blackfin JTAG"
+	depends on BFIN_JTAG_COMM=y
+
 config COMPUTONE
 	tristate "Computone IntelliPort Plus serial support"
 	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
@@ -261,7 +261,7 @@ config ISTALLION
 
 config NOZOMI
 	tristate "HSDPA Broadband Wireless Data Card - Globe Trotter"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && SERIAL_NONSTANDARD
 	help
 	  If you have a HSDPA driver Broadband Wireless Data Card -
 	  Globe Trotter PCMCIA card, say Y here.
@@ -271,7 +271,7 @@ config NOZOMI
 
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ZORRO && BROKEN
+	depends on EXPERIMENTAL && ZORRO && BROKEN && SERIAL_NONSTANDARD
 	---help---
 	  This option supports the 2232 7-port serial card shipped with the
 	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
@@ -287,7 +287,7 @@ config A2232
 
 config SYNCLINK_CS
 	tristate "SyncLink PC Card support"
-	depends on PCMCIA
+	depends on PCMCIA && SERIAL_NONSTANDARD
 	help
 	  Enable support for the SyncLink PC Card serial adapter, running
 	  asynchronous and HDLC communications up to 512Kbps. The port is
@@ -300,7 +300,7 @@ config SYNCLINK_CS
  
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
-	depends on PCMCIA && NETDEVICES
+	depends on PCMCIA && NETDEVICES && SERIAL_NONSTANDARD
 	select PPP
 	help
 	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
-- 
1.7.1


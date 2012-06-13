Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2FMAhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:37:18 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3685 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FMAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:37:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1339547835!11255719!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: Kconfig: cleanup depends on logic
Date: Tue, 12 Jun 2012 17:37:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206121737.11308.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the config options for comedi depend on COMEDI being
selected. Wrap everything in an 'if COMEDI/endif' block and
remove all the individual 'depends on COMEDI' in the Kconfig.

Also, remove the redundant && ISA/PCI/PCMCIA/USB for the if
blocks with those driver types.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/Kconfig |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 54e32da..848cf7e 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -6,9 +6,10 @@ config COMEDI
 	  Enable support a wide range of data acquisition devices
 	  for Linux.
 
+if COMEDI
+
 config COMEDI_DEBUG
 	bool "Comedi debugging"
-	depends on COMEDI != n
 	---help---
 	  This is an option for use by developers; most people should
 	  say N here. This enables comedi core and driver debugging.
@@ -16,7 +17,6 @@ config COMEDI_DEBUG
 config COMEDI_DEFAULT_BUF_SIZE_KB
 	int "Comedi default initial asynchronous buffer size in KiB"
 	default "2048"
-	depends on COMEDI != n
 	---help---
 	  This is the default asynchronous buffer size which is used for
 	  commands running in the background in kernel space.  This
@@ -26,7 +26,6 @@ config COMEDI_DEFAULT_BUF_SIZE_KB
 config COMEDI_DEFAULT_BUF_MAXSIZE_KB
 	int "Comedi default maximum asynchronous buffer size in KiB"
 	default "20480"
-	depends on COMEDI != n
 	---help---
 	  This is the default maximum asynchronous buffer size which can
 	  be requested by a userspace program without root privileges.
@@ -35,7 +34,6 @@ config COMEDI_DEFAULT_BUF_MAXSIZE_KB
 
 menuconfig COMEDI_MISC_DRIVERS
 	tristate "Comedi misc drivers"
-	depends on COMEDI
 	---help---
 	  Enable comedi misc drivers to be built
 
@@ -103,7 +101,7 @@ endif # COMEDI_MISC_DRIVERS
 
 menuconfig COMEDI_ISA_DRIVERS
 	tristate "Comedi ISA and PC/104 drivers"
-	depends on COMEDI && ISA
+	depends on ISA
 	---help---
 	  Enable comedi ISA and PC/104 drivers to be built
 
@@ -111,7 +109,7 @@ menuconfig COMEDI_ISA_DRIVERS
 	  kernel: saying N will just cause the configurator to skip all
 	  the questions about ISA and PC/104 comedi drivers.
 
-if COMEDI_ISA_DRIVERS && ISA
+if COMEDI_ISA_DRIVERS
 
 config COMEDI_ACL7225B
 	tristate "ADlink NuDAQ ACL-7225b and compatibles support"
@@ -543,7 +541,7 @@ endif # COMEDI_ISA_DRIVERS
 
 menuconfig COMEDI_PCI_DRIVERS
 	tristate "Comedi PCI drivers"
-	depends on COMEDI && PCI
+	depends on PCI
 	---help---
 	  Enable comedi PCI drivers to be built
 
@@ -551,7 +549,7 @@ menuconfig COMEDI_PCI_DRIVERS
 	  kernel: saying N will just cause the configurator to skip all
 	  the questions about PCI comedi drivers.
 
-if COMEDI_PCI_DRIVERS && PCI
+if COMEDI_PCI_DRIVERS
 
 config COMEDI_ADDI_APCI_035
 	tristate "ADDI-DATA APCI_035 support"
@@ -1099,7 +1097,7 @@ endif # COMEDI_PCI_DRIVERS
 
 menuconfig COMEDI_PCMCIA_DRIVERS
 	tristate "Comedi PCMCIA drivers"
-	depends on COMEDI && (PCMCIA || PCCARD)
+	depends on (PCMCIA || PCCARD)
 	---help---
 	  Enable comedi PCMCIA and PCCARD drivers to be built
 
@@ -1107,7 +1105,7 @@ menuconfig COMEDI_PCMCIA_DRIVERS
 	  kernel: saying N will just cause the configurator to skip all
 	  the questions about PCMCIA comedi drivers.
 
-if COMEDI_PCMCIA_DRIVERS && PCMCIA
+if COMEDI_PCMCIA_DRIVERS
 
 config COMEDI_CB_DAS16_CS
 	tristate "CB DAS16 series PCMCIA support"
@@ -1182,7 +1180,7 @@ endif # COMEDI_PCMCIA_DRIVERS
 
 menuconfig COMEDI_USB_DRIVERS
 	tristate "Comedi USB drivers"
-	depends on COMEDI && USB
+	depends on USB
 	---help---
 	  Enable comedi USB drivers to be built
 
@@ -1190,7 +1188,7 @@ menuconfig COMEDI_USB_DRIVERS
 	  kernel: saying N will just cause the configurator to skip all
 	  the questions about USB comedi drivers.
 
-if COMEDI_USB_DRIVERS && USB
+if COMEDI_USB_DRIVERS
 
 config COMEDI_DT9812
 	tristate "DataTranslation DT9812 USB module support"
@@ -1290,7 +1288,6 @@ endif # COMEDI_NI_COMMON
 
 config COMEDI_8255
 	tristate "Generic 8255 support"
-	depends on COMEDI
 	---help---
 	  Enable generic 8255 support.
 
@@ -1306,23 +1303,20 @@ config COMEDI_8255
 
 config COMEDI_FC
 	tristate
-	depends on COMEDI
 
 config COMEDI_AMPLC_DIO200
 	tristate
-	depends on COMEDI
 	select COMEDI_8255
 
 config COMEDI_AMPLC_PC236
 	tristate
-	depends on COMEDI
 	select COMEDI_8255
 
 config COMEDI_AMPLC_PC263
 	tristate
-	depends on COMEDI
 
 config COMEDI_DAS08
 	tristate
-	depends on COMEDI
 	select COMEDI_8255
+
+endif # COMEDI
-- 
1.7.7


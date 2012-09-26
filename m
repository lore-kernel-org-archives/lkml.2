Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2IZUUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:20:24 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:47627 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2IZUUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:20:22 -0400
Date: Wed, 26 Sep 2012 22:20:19 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [Patch v5] ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc
Message-ID: <47b117b0-5776-41c4-8b49-e3a21e80a6a4@shmail0>
In-Reply-To: <c28594f9-45a3-4232-82fc-2f7c65cfb30c@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.190.122.127]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch 
- moves drivers/usb/serial/ezusb.c to drivers/usb/misc/
- renamed CONFIG_USB_EZUSB to CONFIG_USB_EZUSB_FX2 to avoid build errors
- adapts Makefiles and Kconfigs switching from bool to tristate for CONFIG_USB_EZUSB_FX2

Signed-off-by: René Bürgel <rene.buergel@sohard.de>
---
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 1bfcd02..bf7dc43 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -244,3 +244,8 @@ config USB_YUREX
 	  To compile this driver as a module, choose M here: the
 	  module will be called yurex.
 
+config USB_EZUSB_FX2
+	tristate "Functions for loading firmware on EZUSB chips"
+	help
+	  Say Y here if you need EZUSB device support.
+	  (Cypress FX/FX2/FX2LP microcontrollers)
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 796ce7e..f1f7815 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_USB_CYPRESS_CY7C63)	+= cypress_cy7c63.o
 obj-$(CONFIG_USB_CYTHERM)		+= cytherm.o
 obj-$(CONFIG_USB_EMI26)			+= emi26.o
 obj-$(CONFIG_USB_EMI62)			+= emi62.o
+obj-$(CONFIG_USB_EZUSB_FX2)		+= ezusb.o
 obj-$(CONFIG_USB_FTDI_ELAN)		+= ftdi-elan.o
 obj-$(CONFIG_USB_IDMOUSE)		+= idmouse.o
 obj-$(CONFIG_USB_IOWARRIOR)		+= iowarrior.o
diff --git a/drivers/usb/serial/ezusb.c b/drivers/usb/misc/ezusb.c
similarity index 100%
rename from drivers/usb/serial/ezusb.c
rename to drivers/usb/misc/ezusb.c
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index f604f70..76f4622 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -42,11 +42,6 @@ config USB_SERIAL_CONSOLE
 
 	  If unsure, say N.
 
-config USB_EZUSB
-	bool "Functions for loading firmware on EZUSB chips"
-	help
-	    Say Y here if you need EZUSB device support.
-
 config USB_SERIAL_GENERIC
 	bool "USB Generic Serial Driver"
 	help
@@ -94,7 +89,7 @@ config USB_SERIAL_CH341
 
 config USB_SERIAL_WHITEHEAT
 	tristate "USB ConnectTech WhiteHEAT Serial Driver"
-	select USB_EZUSB
+	select USB_EZUSB_FX2
 	help
 	  Say Y here if you want to use a ConnectTech WhiteHEAT 4 port
 	  USB to serial converter device.
@@ -281,7 +276,7 @@ config USB_SERIAL_IUU
 
 config USB_SERIAL_KEYSPAN_PDA
 	tristate "USB Keyspan PDA Single Port Serial Driver"
-	select USB_EZUSB
+	select USB_EZUSB_FX2
 	help
 	  Say Y here if you want to use a Keyspan PDA single port USB to
 	  serial converter device.  This driver makes use of firmware
@@ -292,7 +287,7 @@ config USB_SERIAL_KEYSPAN_PDA
 
 config USB_SERIAL_KEYSPAN
 	tristate "USB Keyspan USA-xxx Serial Driver"
-	select USB_EZUSB
+	select USB_EZUSB_FX2
 	---help---
 	  Say Y here if you want to use Keyspan USB to serial converter
 	  devices.  This driver makes use of Keyspan's official firmware
@@ -596,7 +591,7 @@ config USB_SERIAL_CYBERJACK
 
 config USB_SERIAL_XIRCOM
 	tristate "USB Xircom / Entregra Single Port Serial Driver"
-	select USB_EZUSB
+	select USB_EZUSB_FX2
 	help
 	  Say Y here if you want to use a Xircom or Entregra single port USB to
 	  serial converter device.  This driver makes use of firmware
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index 45871f9..3b3e730 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_USB_SERIAL)			+= usbserial.o
 usbserial-y := usb-serial.o generic.o bus.o
 
 usbserial-$(CONFIG_USB_SERIAL_CONSOLE)	+= console.o
-usbserial-$(CONFIG_USB_EZUSB)		+= ezusb.o
 
 obj-$(CONFIG_USB_SERIAL_AIRCABLE)		+= aircable.o
 obj-$(CONFIG_USB_SERIAL_ARK3116)		+= ark3116.o

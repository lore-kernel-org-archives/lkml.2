Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2ISVkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:40:14 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:37118 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2ISVkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:40:11 -0400
Date: Wed, 19 Sep 2012 23:40:07 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: [Patch v4] ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc
Message-ID: <0ea79bd0-ff8e-44ce-9dba-e9e9ea300678@shmail0>
In-Reply-To: <93adca3f-6a22-45b7-a159-32bb6622efb5@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.7.73.0]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves drivers/usb/serial/ezusb.c to drivers/usb/misc/and
adapts Makefiles and Kconfigs switching from bool to tristate for CONFIG_USB_EZUSB

Signed-off-by: René Bürgel <rene.buergel@sohard.de>
---
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 1bfcd02..1c63b54 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -244,3 +244,7 @@ config USB_YUREX
 	  To compile this driver as a module, choose M here: the
 	  module will be called yurex.
 
+config USB_EZUSB
+	tristate "Functions for loading firmware on EZUSB chips"
+	help
+	    Say Y here if you need EZUSB device support.
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 796ce7e..f1f7815 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_USB_CYPRESS_CY7C63)	+= cypress_cy7c63.o
 obj-$(CONFIG_USB_CYTHERM)		+= cytherm.o
 obj-$(CONFIG_USB_EMI26)			+= emi26.o
 obj-$(CONFIG_USB_EMI62)			+= emi62.o
+obj-$(CONFIG_USB_EZUSB)			+= ezusb.o
 obj-$(CONFIG_USB_FTDI_ELAN)		+= ftdi-elan.o
 obj-$(CONFIG_USB_IDMOUSE)		+= idmouse.o
 obj-$(CONFIG_USB_IOWARRIOR)		+= iowarrior.o
diff --git a/drivers/usb/serial/ezusb.c b/drivers/usb/misc/ezusb.c
similarity index 100%
rename from drivers/usb/serial/ezusb.c
rename to drivers/usb/misc/ezusb.c
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 325d291..73b5e6f 100644
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
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index 1dc483a..12b56bb 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_USB_SERIAL)			+= usbserial.o
 usbserial-y := usb-serial.o generic.o bus.o
 
 usbserial-$(CONFIG_USB_SERIAL_CONSOLE)	+= console.o
-usbserial-$(CONFIG_USB_EZUSB)		+= ezusb.o
 
 obj-$(CONFIG_USB_SERIAL_AIRCABLE)		+= aircable.o
 obj-$(CONFIG_USB_SERIAL_ARK3116)		+= ark3116.o

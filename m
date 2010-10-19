Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab0JSKDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:03:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58982 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab0JSKDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x1I3vFxeB/AQMBH7ZFm5asOwGw1aZ4L+A+CepRhXFQm2q9gzMBIQhHIAm+it4jzG8y
         nrkq2/h5pAdgM9E6yqj7aC03zdOt0GiXFilJC7je4mqSCI9mLafmDQihScLuH0qqZcJg
         kmEXfZeKYiqQ9+UJ+dlVkZoApORD7xK288MlI=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Date: Tue, 19 Oct 2010 13:03:28 +0300
Message-Id: <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
In-Reply-To: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing dependencies, and remove redundant ones, and select sensible
defaults.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/mfd/Kconfig        |    3 ++-
 drivers/regulator/Kconfig  |    1 +
 drivers/usb/gadget/Kconfig |    3 +--
 drivers/usb/musb/Kconfig   |    6 ++----
 drivers/usb/otg/Kconfig    |    2 ++
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db51ea1..0bbaf01 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -156,6 +156,7 @@ config MENELAUS
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y && GENERIC_HARDIRQS
+	default y if ARCH_OMAP3 || ARCH_OMAP4
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
@@ -169,7 +170,7 @@ config TWL4030_CORE
 
 config TWL4030_POWER
 	bool "Support power resources on TWL4030 family chips"
-	depends on TWL4030_CORE && ARM
+	depends on TWL4030_CORE
 	help
 	  Say yes here if you want to use the power resources on the
 	  TWL4030 family chips.  Most of these resources are regulators,
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 172951b..af0439d 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -111,6 +111,7 @@ config REGULATOR_MAX8998
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
 	depends on TWL4030_CORE
+	default y
 	help
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index c530bc6..2aac57e 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -111,7 +111,6 @@ config	USB_GADGET_SELECTED
 #
 choice
 	prompt "USB Peripheral Controller"
-	depends on USB_GADGET
 	help
 	   A USB device uses a controller to talk to its host.
 	   Systems should have only one such upstream link.
@@ -191,7 +190,6 @@ config USB_GADGET_OMAP
 	boolean "OMAP USB Device Controller"
 	depends on ARCH_OMAP
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
-	select USB_OTG_UTILS if ARCH_OMAP
 	help
 	   Many Texas Instruments OMAP processors have flexible full
 	   speed USB device controllers, with support for up to 30
@@ -843,6 +841,7 @@ config USB_CDC_COMPOSITE
 config USB_G_NOKIA
 	tristate "Nokia composite gadget"
 	depends on PHONET
+	depends on USB_GADGET_MUSB_HDRC
 	help
 	  The Nokia composite gadget provides support for acm, obex
 	  and phonet in only one composite gadget driver.
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 20895c4..a3f01f6 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -11,8 +11,7 @@ config USB_MUSB_HDRC
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	depends on (USB || USB_GADGET)
 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
-	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
-	select TWL4030_USB if MACH_OMAP_3430SDP
+	depends on (NOP_USB_XCEIV || TWL4030_USB)
 	select USB_OTG_UTILS
 	help
 	  Say Y here if your system has a dual role high speed USB
@@ -59,8 +58,7 @@ comment "Blackfin high speed USB Support"
 
 config USB_TUSB6010
 	boolean "TUSB 6010 support"
-	depends on USB_MUSB_HDRC && !USB_MUSB_SOC
-	select NOP_USB_XCEIV
+	depends on USB_MUSB_HDRC && !USB_MUSB_SOC && NOP_USB_XCEIV
 	default y
 	help
 	  The TUSB 6010 chip, from Texas Instruments, connects a discrete
diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index 3b12895..2e5fd2d 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -53,6 +53,7 @@ config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030
 	select USB_OTG_UTILS
+	default y if ARCH_OMAP3
 	help
 	  Enable this to support the USB OTG transceiver on TWL4030
 	  family chips (including the TWL5030 and TPS659x0 devices).
@@ -62,6 +63,7 @@ config TWL4030_USB
 config NOP_USB_XCEIV
 	tristate "NOP USB Transceiver Driver"
 	select USB_OTG_UTILS
+	default y if ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN
 	help
 	 this driver is to be used by all the usb transceiver which are either
 	 built-in with usb ip or which are autonomous and doesn't require any
-- 
1.7.3.1.2.g7fe2b


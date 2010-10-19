Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab0JSIFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:05:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab0JSIEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cfWZCaNKpCbbSFLPaY/DSfkD+kvhXzDMM9JmZin/3EQ2y7tRCNh5ergjhEIG2viGBQ
         BBdhZM1N+1NKgUsQ/DZagZyqT/2wQDgiExtx2eJ8nR7WTnhQuWwTA9maZOAPYlM0LKTj
         AzoAhIPv8A4zjgazCYODrAYBxDCx0rgxPo194=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org, linux-main <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 3/3] drivers: cleanup Kconfig stuff
Date: Tue, 19 Oct 2010 11:04:26 +0300
Message-Id: <1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
In-Reply-To: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing dependencies, and remove redundant ones.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/mfd/Kconfig        |    4 +++-
 drivers/usb/gadget/Kconfig |    5 ++---
 drivers/usb/musb/Kconfig   |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db51ea1..523df52 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -156,6 +156,8 @@ config MENELAUS
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on ARCH_OMAP3 || ARCH_OMAP4
+	default y
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
@@ -169,7 +171,7 @@ config TWL4030_CORE
 
 config TWL4030_POWER
 	bool "Support power resources on TWL4030 family chips"
-	depends on TWL4030_CORE && ARM
+	depends on TWL4030_CORE
 	help
 	  Say yes here if you want to use the power resources on the
 	  TWL4030 family chips.  Most of these resources are regulators,
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index c530bc6..1fb074f 100644
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
@@ -842,7 +840,8 @@ config USB_CDC_COMPOSITE
 
 config USB_G_NOKIA
 	tristate "Nokia composite gadget"
-	depends on PHONET
+	depends on PHONET && MACH_NOKIA_RX51
+	depends on USB_GADGET_MUSB_HDRC
 	help
 	  The Nokia composite gadget provides support for acm, obex
 	  and phonet in only one composite gadget driver.
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 20895c4..5484258 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -12,7 +12,7 @@ config USB_MUSB_HDRC
 	depends on (USB || USB_GADGET)
 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
-	select TWL4030_USB if MACH_OMAP_3430SDP
+	select TWL4030_USB if ARCH_OMAP3
 	select USB_OTG_UTILS
 	help
 	  Say Y here if your system has a dual role high speed USB
-- 
1.7.3.1.2.g7fe2b


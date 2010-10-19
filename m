Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab0JSIEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:04:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab0JSIEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kfi5ic0weemd7NG9ecnI0LSs0UeTYxnzSrP0R0EpzFvB4z+4cYdZVnhcauyFAG3fUX
         J2Ww4UClcT+9Tf4BCWmMbGk9jYJGYcK87litGanujjQY67hFCNRWTs+98773Xhgz/8YJ
         CaaW5/HEZKSvSp+Jeiria17gxzKlxUvzjE3sM=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org, linux-main <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 2/3] usb: trivial Kconfig cleanups
Date: Tue, 19 Oct 2010 11:04:25 +0300
Message-Id: <1287475466-8927-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
In-Reply-To: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/core/Kconfig   |    3 ---
 drivers/usb/gadget/Kconfig |    2 +-
 drivers/usb/musb/Kconfig   |   17 ++++-------------
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 9eed5b5..8f57a26 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -110,8 +110,6 @@ config USB_OTG
 	bool
 	depends on USB && EXPERIMENTAL
 	depends on USB_SUSPEND
-	default n
-
 
 config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
@@ -139,4 +137,3 @@ config USB_OTG_BLACKLIST_HUB
 	  external hubs.  OTG hosts are allowed to reduce hardware
 	  and software costs by not supporting external hubs.  So
 	  are "Embedded Hosts" that don't offer OTG support.
-
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 19a6eb6..c530bc6 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -125,7 +125,6 @@ choice
 config USB_GADGET_AT91
 	boolean "Atmel AT91 USB Device Port"
 	depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9 && !ARCH_AT91SAM9G45
-	select USB_GADGET_SELECTED
 	help
 	   Many Atmel AT91 processors (such as the AT91RM2000) have a
 	   full speed USB Device Port with support for five configurable
@@ -139,6 +138,7 @@ config USB_AT91
 	tristate
 	depends on USB_GADGET_AT91
 	default USB_GADGET
+	select USB_GADGET_SELECTED
 
 config USB_GADGET_ATMEL_USBA
 	boolean "Atmel USBA"
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index cfd38ed..20895c4 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -8,12 +8,12 @@ comment "Enable Host or Gadget support to see Inventra options"
 
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
+	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	depends on (USB || USB_GADGET)
 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select USB_OTG_UTILS
-	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	help
 	  Say Y here if your system has a dual role high speed USB
 	  controller based on the Mentor Graphics silicon IP.  Then
@@ -79,8 +79,8 @@ choice
 # use USB_MUSB_HDRC_HCD not USB_MUSB_HOST to #ifdef host side support;
 # OTG needs both roles, not just USB_MUSB_HOST.
 config USB_MUSB_HOST
-	depends on USB
 	bool "USB Host"
+	depends on USB
 	help
 	  Say Y here if your system supports the USB host role.
 	  If it has a USB "A" (rectangular), "Mini-A" (uncommon),
@@ -90,8 +90,8 @@ config USB_MUSB_HOST
 # use USB_GADGET_MUSB_HDRC not USB_MUSB_PERIPHERAL to #ifdef peripheral
 # side support ... OTG needs both roles
 config USB_MUSB_PERIPHERAL
-	depends on USB_GADGET
 	bool "USB Peripheral (gadget stack)"
+	depends on USB_GADGET
 	select USB_GADGET_MUSB_HDRC
 	help
 	  Say Y here if your system supports the USB peripheral role.
@@ -100,8 +100,8 @@ config USB_MUSB_PERIPHERAL
 	  (With a "Mini-AB" connector, you should enable USB OTG.)
 
 config USB_MUSB_OTG
-	depends on USB && USB_GADGET && PM && EXPERIMENTAL
 	bool "Both host and peripheral:  USB OTG (On The Go) Device"
+	depends on USB && USB_GADGET && PM && EXPERIMENTAL
 	select USB_GADGET_MUSB_HDRC
 	select USB_OTG
 	help
@@ -125,14 +125,6 @@ config USB_MUSB_OTG
 
 endchoice
 
-# enable peripheral support (including with OTG)
-config USB_GADGET_MUSB_HDRC
-	bool
-	depends on USB_MUSB_HDRC && (USB_MUSB_PERIPHERAL || USB_MUSB_OTG)
-#	default y
-#	select USB_GADGET_DUALSPEED
-#	select USB_GADGET_SELECTED
-
 # enables host support (including with OTG)
 config USB_MUSB_HDRC_HCD
 	bool
@@ -140,7 +132,6 @@ config USB_MUSB_HDRC_HCD
 	select USB_OTG if USB_GADGET_MUSB_HDRC
 	default y
 
-
 config MUSB_PIO_ONLY
 	bool 'Disable DMA (always use PIO)'
 	depends on USB_MUSB_HDRC
-- 
1.7.3.1.2.g7fe2b


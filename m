Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2FZO5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:57:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54784 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2FZO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:56:59 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: Fix Kconfig dependency for Phy drivers
Date: Tue, 26 Jun 2012 11:56:48 -0300
Message-Id: <1340722608-997-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB phy layer driver are only built if usb host is selected, but they
are used too by USB_GADGET drivers

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/Makefile    |    2 +-
 drivers/usb/phy/Kconfig |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index c691eea..f5ed3d7 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -46,7 +46,7 @@ obj-$(CONFIG_USB_MICROTEK)	+= image/
 obj-$(CONFIG_USB_SERIAL)	+= serial/
 
 obj-$(CONFIG_USB)		+= misc/
-obj-$(CONFIG_USB)		+= phy/
+obj-$(CONFIG_USB_COMMON)	+= phy/
 obj-$(CONFIG_EARLY_PRINTK_DBGP)	+= early/
 
 obj-$(CONFIG_USB_ATM)		+= atm/
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 3cfabcb..e7cf84f 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -2,11 +2,11 @@
 # Physical Layer USB driver configuration
 #
 comment "USB Physical Layer drivers"
-	depends on USB
+	depends on USB || USB_GADGET
 
 config USB_ISP1301
 	tristate "NXP ISP1301 USB transceiver support"
-	depends on USB
+	depends on USB || USB_GADGET
 	depends on I2C
 	help
 	  Say Y here to add support for the NXP ISP1301 USB transceiver driver.
-- 
1.7.10


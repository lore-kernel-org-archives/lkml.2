Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2ICTh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:37:27 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:47205 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756327Ab2ICTh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:37:26 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        stern@rowland.harvard.edu, balbi@ti.com, linux-usb@vger.kernel.org,
        aletes.xgr@gmail.com, gregkh@linuxfoundation.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND] usb: ohci: Fix Kconfig dependency on USB_ISP1301
Date: Mon,  3 Sep 2012 21:37:00 +0200
Message-Id: <1346701020-21619-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With "select USB_ISP1301 ...", it could happen that I2C isn't selected although
USB_ISP1301 depends on it. Fixing with "depends on ..." and emulating the
condition via "|| !()".

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/usb/host/Kconfig
+++ linux-2.6/drivers/usb/host/Kconfig
@@ -292,7 +292,7 @@ config USB_OHCI_HCD
 	depends on USB && USB_ARCH_HAS_OHCI
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
 	select USB_OTG_UTILS if ARCH_OMAP
-	select USB_ISP1301 if ARCH_LPC32XX
+	depends on USB_ISP1301 || !ARCH_LPC32XX
 	---help---
 	  The Open Host Controller Interface (OHCI) is a standard for accessing
 	  USB 1.1 host controller hardware.  It does more in hardware than Intel's

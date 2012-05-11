Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2EKFzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:55:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41746 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2EKFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:55:34 -0400
From: joseph daniel <josephdanielwalter@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: joseph daniel <josephdanielwalter@gmail.com>
Subject: [PATCH] usb/dwc3: Fix the dwc3 dependency
Date: Fri, 11 May 2012 11:25:24 +0530
Message-Id: <1336715724-8441-1-git-send-email-josephdanielwalter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning shown up when ran with randconfig,

warning: (USB_DWC3) selects USB_XHCI_PLATFORM which has unmet direct dependencies (USB_SUPPORT && USB_XHCI_HCD)

Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
---
 drivers/usb/dwc3/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index d8f741f..68271fa 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -1,6 +1,6 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
-	depends on (USB && USB_GADGET)
+	depends on (USB && USB_SUPPORT && USB_XCHI_HCD && USB_GADGET)
 	select USB_OTG_UTILS
 	select USB_GADGET_DUALSPEED
 	select USB_GADGET_SUPERSPEED
-- 
1.7.9.5


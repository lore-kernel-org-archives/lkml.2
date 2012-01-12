Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2ALCdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:33:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2ALCdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:33:02 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 6/6 v2] usb/gadget/pch_udc: Add debug message
Date: Thu, 12 Jan 2012 11:27:10 +0900
Message-Id: <1326335230-32469-6-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
References: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE:
Adding debugging messages.

CAUSE:
The debugging messages are added to make sure of that major interrupt events are occurring.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V2: Divide into 6 patches
---
 drivers/usb/gadget/pch_udc.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 5a8ba41..356bd59 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2516,11 +2516,15 @@ static void pch_udc_svc_cfg_interrupt(struct pch_udc_dev *dev)
 static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
 {
 	/* USB Reset Interrupt */
-	if (dev_intr & UDC_DEVINT_UR)
+	if (dev_intr & UDC_DEVINT_UR) {
 		pch_udc_svc_ur_interrupt(dev);
+		dev_dbg(&dev->pdev->dev, "USB_RESET\n");
+	}
 	/* Enumeration Done Interrupt */
-	if (dev_intr & UDC_DEVINT_ENUM)
+	if (dev_intr & UDC_DEVINT_ENUM) {
 		pch_udc_svc_enum_interrupt(dev);
+		dev_dbg(&dev->pdev->dev, "USB_ENUM\n");
+	}
 	/* Set Interface Interrupt */
 	if (dev_intr & UDC_DEVINT_SI)
 		pch_udc_svc_intf_interrupt(dev);
-- 
1.7.4.4


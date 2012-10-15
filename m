Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2JON2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:28:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43794 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2JON2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:28:44 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <sshtylyov@mvista.com>
Subject: [PATCH v4 4/7] usb: dwc3-omap: Remove explicit writes to SYSCONFIG register
Date: Mon, 15 Oct 2012 18:57:57 +0530
Message-ID: <1350307680-24938-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350307680-24938-1-git-send-email-kishon@ti.com>
References: <1350307680-24938-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The runtime API's takes care of setting the SYSCONFIG register with
appropriate values. Hence explicit writes to SYSCONFIG register is
removed.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 1fdf7e2..edc7292 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -80,23 +80,6 @@
 
 /* SYSCONFIG REGISTER */
 #define USBOTGSS_SYSCONFIG_DMADISABLE		(1 << 16)
-#define USBOTGSS_SYSCONFIG_STANDBYMODE(x)	((x) << 4)
-
-#define USBOTGSS_STANDBYMODE_FORCE_STANDBY	0
-#define USBOTGSS_STANDBYMODE_NO_STANDBY		1
-#define USBOTGSS_STANDBYMODE_SMART_STANDBY	2
-#define USBOTGSS_STANDBYMODE_SMART_WAKEUP	3
-
-#define USBOTGSS_STANDBYMODE_MASK		(0x03 << 4)
-
-#define USBOTGSS_SYSCONFIG_IDLEMODE(x)		((x) << 2)
-
-#define USBOTGSS_IDLEMODE_FORCE_IDLE		0
-#define USBOTGSS_IDLEMODE_NO_IDLE		1
-#define USBOTGSS_IDLEMODE_SMART_IDLE		2
-#define USBOTGSS_IDLEMODE_SMART_WAKEUP		3
-
-#define USBOTGSS_IDLEMODE_MASK			(0x03 << 2)
 
 /* IRQ_EOI REGISTER */
 #define USBOTGSS_IRQ_EOI_LINE_NUMBER		(1 << 0)
@@ -373,15 +356,6 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_SYSCONFIG);
 	omap->dma_status = !!(reg & USBOTGSS_SYSCONFIG_DMADISABLE);
 
-	/* Set No-Idle and No-Standby */
-	reg &= ~(USBOTGSS_STANDBYMODE_MASK
-			| USBOTGSS_IDLEMODE_MASK);
-
-	reg |= (USBOTGSS_SYSCONFIG_STANDBYMODE(USBOTGSS_STANDBYMODE_NO_STANDBY)
-		| USBOTGSS_SYSCONFIG_IDLEMODE(USBOTGSS_IDLEMODE_NO_IDLE));
-
-	dwc3_omap_writel(omap->base, USBOTGSS_SYSCONFIG, reg);
-
 	ret = devm_request_irq(dev, omap->irq, dwc3_omap_interrupt, 0,
 			"dwc3-omap", omap);
 	if (ret) {
-- 
1.7.9.5


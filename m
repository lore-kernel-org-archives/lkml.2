Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2LWL0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:26:22 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35196 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2LWL0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:26:19 -0500
From: Matt Sealey <matt@genesi-usa.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Alan Stern <stern@rowland.harvard.edu>,
        Sascha Hauer <kernel@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>
Subject: [PATCH] ehci-mxc: remove Efika MX-specific CHRGVBUS hack
Date: Sun, 23 Dec 2012 05:18:21 -0600
Message-Id: <1356261501-8465-1-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Efika MX platform support (pre-devicetree) was removed from the tree
this code no longer has any possibility of running and clutters up the
driver which is being replaced by the chipidea host in the future anyway.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
Tested-by: Steev Klimazewski <steev@genesi-usa.com>
CC: Sascha Hauer <kernel@pengutronix.de>
CC: Alan Stern <stern@rowland.harvard.edu>

---
 drivers/usb/host/ehci-mxc.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index 8e58a5f..b62c3a8 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -102,7 +102,6 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	struct resource *res;
 	int irq, ret;
-	unsigned int flags;
 	struct ehci_mxc_priv *priv;
 	struct device *dev = &pdev->dev;
 	struct ehci_hcd *ehci;
@@ -213,25 +212,6 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_add;
 
-	if (pdata->otg) {
-		/*
-		 * efikamx and efikasb have some hardware bug which is
-		 * preventing usb to work unless CHRGVBUS is set.
-		 * It's in violation of USB specs
-		 */
-		if (machine_is_mx51_efikamx() || machine_is_mx51_efikasb()) {
-			flags = usb_phy_io_read(pdata->otg,
-							ULPI_OTG_CTRL);
-			flags |= ULPI_OTG_CTRL_CHRGVBUS;
-			ret = usb_phy_io_write(pdata->otg, flags,
-							ULPI_OTG_CTRL);
-			if (ret) {
-				dev_err(dev, "unable to set CHRVBUS\n");
-				goto err_add;
-			}
-		}
-	}
-
 	return 0;
 
 err_add:
-- 
1.7.10.4


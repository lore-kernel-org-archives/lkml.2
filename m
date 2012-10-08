Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2JHNQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:16:23 -0400
Received: from zmc.proxad.net ([212.27.53.206]:33276 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab2JHNOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:14:51 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/32 v2] USB: EHCI: make ehci-platform use dev_err() instead of pr_err()
Date: Mon,  8 Oct 2012 15:11:41 +0200
Message-Id: <1349701906-16481-28-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349701906-16481-1-git-send-email-florian@openwrt.org>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the ehci-platform driver to make use of the dev_err()
functions instead of pr_err().

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes in v2:
- rebased against greg's latest usb-next

 drivers/usb/host/ehci-platform.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 607adf9..6516717 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -98,12 +98,12 @@ static int __devinit ehci_platform_probe(struct platform_device *dev)
 
 	irq = platform_get_irq(dev, 0);
 	if (irq < 0) {
-		pr_err("no irq provided");
+		dev_err(&dev->dev, "no irq provided");
 		return irq;
 	}
 	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res_mem) {
-		pr_err("no memory recourse provided");
+		dev_err(&dev->dev, "no memory recourse provided");
 		return -ENXIO;
 	}
 
@@ -124,7 +124,7 @@ static int __devinit ehci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_len = resource_size(res_mem);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_err("controller already in use");
+		dev_err(&dev->dev, "controller already in use");
 		err = -EBUSY;
 		goto err_put_hcd;
 	}
-- 
1.7.9.5


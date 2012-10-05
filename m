Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab2JEQYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:24:45 -0400
Received: from zmc.proxad.net ([212.27.53.206]:56536 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913Ab2JEQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:23:46 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/32] USB: OHCI: make ohci-platform use dev_err() instead of pr_err()
Date: Fri,  5 Oct 2012 18:21:00 +0200
Message-Id: <1349454064-11606-29-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349454064-11606-1-git-send-email-florian@openwrt.org>
References: <1349454064-11606-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the ohci-platform driver to use dev_err() functions
instead of pr_err().

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ohci-platform.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index 99d1755..8a606f4 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -101,13 +101,13 @@ static int __devinit ohci_platform_probe(struct platform_device *dev)
 
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
 
@@ -128,7 +128,7 @@ static int __devinit ohci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_len = resource_size(res_mem);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_err("controller already in use");
+		dev_err(&dev->dev, "controller already in use");
 		err = -EBUSY;
 		goto err_put_hcd;
 	}
-- 
1.7.9.5


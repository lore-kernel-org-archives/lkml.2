Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2LZSoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 13:44:20 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62935 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2LZSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 13:44:16 -0500
From: Dongjin Kim <tobetter@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: Dongjin Kim <tobetter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] USB: ehci-s5p: Add to get interrupt from DT
Date: Thu, 27 Dec 2012 03:42:21 +0900
Message-Id: <1356547341-23620-3-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356547341-23620-1-git-send-email-tobetter@gmail.com>
References: <1356547341-23620-1-git-send-email-tobetter@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support to get interrupt resource from device tree as well as
platform device if ehci node is defined in device tree and it's irq is
described.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/usb/host/ehci-s5p.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 319dcfa..0fc5e5e 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
 #include <plat/usb-phy.h>
 
@@ -156,7 +157,12 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	irq = platform_get_irq(pdev, 0);
+	if (pdev->dev.of_node)
+		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	else {
+		irq = platform_get_irq(pdev, 0);
+	}
+
 	if (!irq) {
 		dev_err(&pdev->dev, "Failed to get IRQ\n");
 		err = -ENODEV;
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1EPM2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:28:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38870 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab1EPM2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:28:18 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <axel.lin@gmail.com>
Subject: [PATCH v1] mfd: Fix omap_usbhs_alloc_children error handling
Date: Mon, 16 May 2011 17:54:07 +0530
Message-ID: <1305548647-19849-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

rebased on top of hwmod and runtime pm patch series of usbhs

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Tested-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 drivers/mfd/omap-usb-host.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index e1bc3b5..32d19e2 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -282,6 +282,7 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
 
 	if (!ehci) {
 		dev_err(dev, "omap_usbhs_alloc_child failed\n");
+		ret = -ENOMEM;
 		goto err_end;
 	}
 
@@ -305,13 +306,14 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
 		sizeof(*ohci_data), dev);
 	if (!ohci) {
 		dev_err(dev, "omap_usbhs_alloc_child failed\n");
+		ret = -ENOMEM;
 		goto err_ehci;
 	}
 
 	return 0;
 
 err_ehci:
-	platform_device_put(ehci);
+	platform_device_unregister(ehci);
 
 err_end:
 	return ret;
-- 
1.6.0.4


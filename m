Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030486Ab2CUG7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:59:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965205Ab2CUG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:59:42 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH v2] MFD: OMAP: USB: Make the runtime functions depend on CONFIG_PM_RUNTIME
Date: Wed, 21 Mar 2012 12:29:34 +0530
Message-ID: <1332313174-5374-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the runtime functions are compiled regardless
of CONFIG_PM_RUNTIME flag. This patch intends to fix the same by
using SET_RUNTIME_PM_OPS.

Reviewed-by: Kevin Hilman <khilman@ti.com>
Cc : Keshava Munegowda <keshava_mgowda@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/mfd/omap-usb-host.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 68ac2c5..f8fdd5f 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -422,6 +422,7 @@ static void usbhs_omap_tll_init(struct device *dev, u8 tll_channel_count)
 	}
 }
 
+#ifdef CONFIG_PM_RUNTIME
 static int usbhs_runtime_resume(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
@@ -489,6 +490,7 @@ static int usbhs_runtime_suspend(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static void omap_usbhs_init(struct device *dev)
 {
@@ -881,8 +883,8 @@ static int __devexit usbhs_omap_remove(struct platform_device *pdev)
 }
 
 static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
-	.runtime_suspend	= usbhs_runtime_suspend,
-	.runtime_resume		= usbhs_runtime_resume,
+	SET_RUNTIME_PM_OPS(usbhs_runtime_suspend,
+				usbhs_runtime_resume, NULL)
 };
 
 static struct platform_driver usbhs_omap_driver = {
-- 
1.7.1


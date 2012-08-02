Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2HBKAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:00:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54311 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab2HBKAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:00:19 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH] drivers: usb: musb: cleanup while removing musb omap glue driver
Date: Thu, 2 Aug 2012 15:30:07 +0530
Message-ID: <1343901607-28400-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Just replaced the call to platform_device_del and
platform_device_put with platform_device_unregister.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 5fdb9da..392fc7a 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -509,8 +509,7 @@ static int __devexit omap2430_remove(struct platform_device *pdev)
 	struct omap2430_glue		*glue = platform_get_drvdata(pdev);
 
 	cancel_work_sync(&glue->omap_musb_mailbox_work);
-	platform_device_del(glue->musb);
-	platform_device_put(glue->musb);
+	platform_device_unregister(glue->musb);
 
 	return 0;
 }
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab1LOXFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:05:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48414 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759748Ab1LOXFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:05:30 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 2/3] usb: musb: trivial cleanup
Date: Fri, 16 Dec 2011 01:05:09 +0200
Message-Id: <1323990310-11905-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1323990310-11905-1-git-send-email-felipe.contreras@gmail.com>
References: <1323990310-11905-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enabled && driver || !enabled can be simplified to !enabled || driver.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/musb/omap2430.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 4edfb91..a615538 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -236,13 +236,7 @@ static int musb_otg_notifications(struct notifier_block *nb,
 	case USB_EVENT_ID:
 		dev_dbg(musb->controller, "ID GND\n");
 
-		if (is_otg_enabled(musb)) {
-			if (musb->gadget_driver) {
-				pm_runtime_get_sync(musb->controller);
-				otg_init(musb->xceiv);
-				omap2430_musb_set_vbus(musb, 1);
-			}
-		} else {
+		if (!is_otg_enabled(musb) || musb->gadget_driver) {
 			pm_runtime_get_sync(musb->controller);
 			otg_init(musb->xceiv);
 			omap2430_musb_set_vbus(musb, 1);
-- 
1.7.8.rc1.14.g248db


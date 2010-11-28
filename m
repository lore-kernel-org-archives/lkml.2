Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0K1VA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:00:28 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37404 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0K1VAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:18 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 12/13] w35und: Remove unused fields from struct wb_usb
Date: Sun, 28 Nov 2010 23:00:07 +0200
Message-Id: <1290978008-29095-12-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes two unused fields from struct wb_usb:

  - DetectCount which is always zero

  - IsUsb20 which is a write-only struct member

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/wb35reg_s.h |    1 -
 drivers/staging/winbond/wbusb.c     |    8 ++------
 drivers/staging/winbond/wbusb_s.h   |    2 --
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg_s.h b/drivers/staging/winbond/wb35reg_s.h
index 9b782ed..eb274ff 100644
--- a/drivers/staging/winbond/wb35reg_s.h
+++ b/drivers/staging/winbond/wb35reg_s.h
@@ -234,7 +234,6 @@ u32 hal_get_bss_pk_cnt(struct hw_data *hw_data);
 
 /* return 100ms count */
 #define hal_get_time_count(_P)		(_P->time_count / 10)
-#define hal_detect_error(_P)		(_P->WbUsb.DetectCount)
 
 #define hal_ibss_disconnect(_A)		(hal_stop_sync_bss(_A))
 
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 4f959c2..3f5baa7 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -337,10 +337,8 @@ static void hal_stop(struct hw_data *pHwData)
 static unsigned char hal_idle(struct hw_data *pHwData)
 {
 	struct wb35_reg *reg = &pHwData->reg;
-	struct wb_usb *pWbUsb = &pHwData->WbUsb;
 
-	if (!pHwData->SurpriseRemove
-	    && (pWbUsb->DetectCount || reg->EP0vm_state != VM_STOP))
+	if (!pHwData->SurpriseRemove && reg->EP0vm_state != VM_STOP)
 		return false;
 
 	return true;
@@ -786,10 +784,8 @@ static int wb35_probe(struct usb_interface *intf,
 	interface = intf->cur_altsetting;
 	endpoint = &interface->endpoint[0].desc;
 
-	if (endpoint[2].wMaxPacketSize == 512) {
+	if (endpoint[2].wMaxPacketSize == 512)
 		printk("[w35und] Working on USB 2.0\n");
-		pWbUsb->IsUsb20 = 1;
-	}
 
 	err = wb35_hw_init(dev);
 	if (err)
diff --git a/drivers/staging/winbond/wbusb_s.h b/drivers/staging/winbond/wbusb_s.h
index 8961ae5..f626391 100644
--- a/drivers/staging/winbond/wbusb_s.h
+++ b/drivers/staging/winbond/wbusb_s.h
@@ -11,8 +11,6 @@
 #include <linux/types.h>
 
 struct wb_usb {
-	u32	IsUsb20;
 	struct	usb_device *udev;
-	u32	DetectCount;
 };
 #endif
-- 
1.7.0.4


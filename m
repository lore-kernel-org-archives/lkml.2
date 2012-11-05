Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab2KEJsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:48:03 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61307 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2KEJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:48:01 -0500
From: "harvey.yang" <harvey.huawei.yang@gmail.com>
To: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, harvey.huawei.yang@gmail.com
Subject: [PATCH V2 1/1] staging: usbip: remove an unnecessary lock in usbip_event_happened.
Date: Mon,  5 Nov 2012 17:51:11 +0800
Message-Id: <1352109071-10696-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey.Yang <harvey.huawei.yang@gmail.com>


Signed-off-by: Harvey.Yang <harvey.huawei.yang@gmail.com>
---
 drivers/staging/usbip/usbip_common.h |    2 +-
 drivers/staging/usbip/usbip_event.c  |   11 ++---------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 5d89c0f..b6d7add 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -330,7 +330,7 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb);
 int usbip_start_eh(struct usbip_device *ud);
 void usbip_stop_eh(struct usbip_device *ud);
 void usbip_event_add(struct usbip_device *ud, unsigned long event);
-int usbip_event_happened(struct usbip_device *ud);
+inline int usbip_event_happened(struct usbip_device *ud);
 
 static inline int interface_to_busnum(struct usb_interface *interface)
 {
diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index d332a34..15871f0 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -112,15 +112,8 @@ void usbip_event_add(struct usbip_device *ud, unsigned long event)
 }
 EXPORT_SYMBOL_GPL(usbip_event_add);
 
-int usbip_event_happened(struct usbip_device *ud)
+inline int usbip_event_happened(struct usbip_device *ud)
 {
-	int happened = 0;
-
-	spin_lock(&ud->lock);
-	if (ud->event != 0)
-		happened = 1;
-	spin_unlock(&ud->lock);
-
-	return happened;
+	return ud->event ? 1 : 0;
 }
 EXPORT_SYMBOL_GPL(usbip_event_happened);
-- 
1.7.1


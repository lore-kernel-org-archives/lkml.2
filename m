Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1KAJ0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:26:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1KAJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:26:47 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: jkosina@suse.cz, oneukum@suse.de, bleung@chromium.org
Cc: stern@rowland.harvard.edu, olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 1/3] HID: usbhid: remove LED_ON
Date: Tue,  1 Nov 2011 17:25:45 +0800
Message-Id: <1320139547-7921-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320139547-7921-1-git-send-email-djkurtz@chromium.org>
References: <1320139547-7921-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED_ON was defined in the original version of the hid-core autosuspend patch.
However, during review, the setting and clearing of it was redone
using ledcount.  The test was left in accidentally.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/hid/usbhid/hid-core.c |   10 ----------
 drivers/hid/usbhid/usbhid.h   |    1 -
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 77e705c..1101961 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1367,16 +1367,6 @@ static int hid_suspend(struct usb_interface *intf, pm_message_t message)
 			return -EIO;
 	}
 
-	if (!ignoreled && (message.event & PM_EVENT_AUTO)) {
-		spin_lock_irq(&usbhid->lock);
-		if (test_bit(HID_LED_ON, &usbhid->iofl)) {
-			spin_unlock_irq(&usbhid->lock);
-			usbhid_mark_busy(usbhid);
-			return -EBUSY;
-		}
-		spin_unlock_irq(&usbhid->lock);
-	}
-
 	hid_cancel_delayed_stuff(usbhid);
 	hid_cease_io(usbhid);
 
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index 1673cac..2d8957c 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -55,7 +55,6 @@ struct usb_interface *usbhid_find_interface(int minor);
 #define HID_STARTED		8
 #define HID_REPORTED_IDLE	9
 #define HID_KEYS_PRESSED	10
-#define HID_LED_ON		11
 
 /*
  * USB-specific HID struct, to be pointed to
-- 
1.7.3.1


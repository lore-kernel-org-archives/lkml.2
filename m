Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2E3Snz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:43:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60652 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2E3Sny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:43:54 -0400
From: Koen Beel <koen.beel@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, mina86@mina86.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Beel <koen.beel.barco@gmail.com>, Koen Beel <koen.beel@barco.com>
Subject: [PATCH] FunctionFS: add HID descriptor support.
Date: Wed, 30 May 2012 20:43:37 +0200
Message-Id: <1338403417-28156-1-git-send-email-koen.beel.barco@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing the descriptors to the ep0 file of functionfs, the HID descriptors where not recognized which caused the initialization from user space to fail.

Signed-off-by: Koen Beel <koen.beel@barco.com>
---
 drivers/usb/gadget/f_fs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index dcd1c7f..8adc79d 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/pagemap.h>
 #include <linux/export.h>
+#include <linux/hid.h>
 #include <asm/unaligned.h>
 
 #include <linux/usb/composite.h>
@@ -1671,6 +1672,12 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 	}
 		break;
 
+	case HID_DT_HID:
+		pr_vdebug("hid descriptor\n");
+		if (length != sizeof(struct hid_descriptor))
+			goto inv_length;
+		break;
+
 	case USB_DT_OTG:
 		if (length != sizeof(struct usb_otg_descriptor))
 			goto inv_length;
-- 
1.7.9.5


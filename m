Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1KSLcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:32:05 -0500
Received: from www17.your-server.de ([213.133.104.17]:41063 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1KSL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:29:37 -0500
Subject: [PATCH] HID: roccat: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.281.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
--- a/drivers/hid/hid-roccat-common.c 2011-11-07 19:39:05.364461084 +0100
+++ b/drivers/hid/hid-roccat-common.c 2011-11-08 10:45:42.781966362 +0100
@@ -49,12 +49,10 @@ int roccat_common_send(struct usb_device
 	char *buf;
 	int len;
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = kmemdup(data, size, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
-	memcpy(buf, data, size);
-
 	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
 			HID_REQ_SET_REPORT,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
diff -u -p a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
--- a/drivers/hid/hid-roccat-kone.c 2011-11-07 19:37:44.826571091 +0100
+++ b/drivers/hid/hid-roccat-kone.c 2011-11-08 10:45:45.085330572 +0100
@@ -78,12 +78,10 @@ static int kone_send(struct usb_device *
 	char *buf;
 	int len;
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = kmemdup(data, size, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
-	memcpy(buf, data, size);
-
 	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
 			HID_REQ_SET_REPORT,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,

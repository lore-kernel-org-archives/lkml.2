Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2HKKeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 06:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2HKKeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 06:34:00 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/4] radio-shark*: Remove work-around for dangling pointer in usb intfdata
Date: Sat, 11 Aug 2012 12:34:52 +0200
Message-Id: <1344681295-2485-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
References: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent kernels properly clear the usb intfdata pointer when another
driver fails to bind (in the radio-shark* case the usbhid driver would try
to bind first.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-shark.c  | 9 ---------
 drivers/media/radio/radio-shark2.c | 9 ---------
 2 files changed, 18 deletions(-)

diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index c2ead23..6117132 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -286,15 +286,6 @@ static int usb_shark_probe(struct usb_interface *intf,
 	if (!shark->transfer_buffer)
 		goto err_alloc_buffer;
 
-	/*
-	 * Work around a bug in usbhid/hid-core.c, where it leaves a dangling
-	 * pointer in intfdata causing v4l2-device.c to not set it. Which
-	 * results in usb_shark_disconnect() referencing the dangling pointer
-	 *
-	 * REMOVE (as soon as the above bug is fixed, patch submitted)
-	 */
-	usb_set_intfdata(intf, NULL);
-
 	shark->v4l2_dev.release = usb_shark_release;
 	v4l2_device_set_name(&shark->v4l2_dev, DRV_NAME, &shark_instance);
 	retval = v4l2_device_register(&intf->dev, &shark->v4l2_dev);
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index b9575de..fc0289d 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -258,15 +258,6 @@ static int usb_shark_probe(struct usb_interface *intf,
 	if (!shark->transfer_buffer)
 		goto err_alloc_buffer;
 
-	/*
-	 * Work around a bug in usbhid/hid-core.c, where it leaves a dangling
-	 * pointer in intfdata causing v4l2-device.c to not set it. Which
-	 * results in usb_shark_disconnect() referencing the dangling pointer
-	 *
-	 * REMOVE (as soon as the above bug is fixed, patch submitted)
-	 */
-	usb_set_intfdata(intf, NULL);
-
 	shark->v4l2_dev.release = usb_shark_release;
 	v4l2_device_set_name(&shark->v4l2_dev, DRV_NAME, &shark_instance);
 	retval = v4l2_device_register(&intf->dev, &shark->v4l2_dev);
-- 
1.7.11.4


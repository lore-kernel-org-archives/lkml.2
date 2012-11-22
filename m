Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2KVUIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:08:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2KVTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:22 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 22/46] staging: line6: drop finish sysfs attr
Date: Thu, 22 Nov 2012 20:49:01 +0100
Message-Id: <1353613765-18690-23-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 052db4a..797f6e0 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -371,24 +371,6 @@ static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
 }
 
 /*
-	"write" request on "finish" special file.
-*/
-static ssize_t pod_set_finish(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int size = 0;
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_FINISH, size);
-	if (!sysex)
-		return 0;
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	kfree(sysex);
-	return count;
-}
-
-/*
 	"read" request on "midi_postprocess" special file.
 */
 static ssize_t pod_get_midi_postprocess(struct device *dev,
@@ -526,7 +508,6 @@ static void pod_startup5(struct work_struct *work)
 
 /* POD special files: */
 static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
-static DEVICE_ATTR(finish, S_IWUSR, line6_nop_read, pod_set_finish);
 static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
 static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
@@ -612,7 +593,6 @@ static int pod_create_files2(struct device *dev)
 	int err;
 
 	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
@@ -727,7 +707,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 					       properties->device_bit, dev);
 
 			device_remove_file(dev, &dev_attr_device_id);
-			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
 			device_remove_file(dev, &dev_attr_serial_number);
-- 
1.8.0


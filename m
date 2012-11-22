Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2KVUQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:16:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59757 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab2KVTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:54 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 06/46] staging: line6: drop dump_buf sysfs attr
Date: Thu, 22 Nov 2012 20:48:45 +0100
Message-Id: <1353613765-18690-7-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 56eab0a..c1eb145 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -610,42 +610,6 @@ static ssize_t pod_set_system_param_string(struct usb_line6_pod *pod,
 }
 
 /*
-	"read" request on "dump_buf" special file.
-*/
-static ssize_t pod_get_dump_buf(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
-	if (retval < 0)
-		return retval;
-	memcpy(buf, &pod->prog_data_buf, sizeof(pod->prog_data_buf));
-	return sizeof(pod->prog_data_buf);
-}
-
-/*
-	"write" request on "dump_buf" special file.
-*/
-static ssize_t pod_set_dump_buf(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-
-	if (count != sizeof(pod->prog_data)) {
-		dev_err(pod->line6.ifcdev,
-			"data block must be exactly %d bytes\n",
-			(int)sizeof(pod->prog_data));
-		return -EINVAL;
-	}
-
-	memcpy(&pod->prog_data_buf, buf, sizeof(pod->prog_data));
-	return sizeof(pod->prog_data);
-}
-
-/*
 	"write" request on "finish" special file.
 */
 static ssize_t pod_set_finish(struct device *dev,
@@ -892,8 +856,6 @@ POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
 
 /* POD special files: */
 static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
-static DEVICE_ATTR(dump_buf, S_IWUSR | S_IRUGO, pod_get_dump_buf,
-		   pod_set_dump_buf);
 static DEVICE_ATTR(finish, S_IWUSR, line6_nop_read, pod_set_finish);
 static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
@@ -1004,7 +966,6 @@ static int pod_create_files2(struct device *dev)
 	int err;
 
 	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dump_buf));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
@@ -1142,7 +1103,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 					       properties->device_bit, dev);
 
 			device_remove_file(dev, &dev_attr_device_id);
-			device_remove_file(dev, &dev_attr_dump_buf);
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
-- 
1.8.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218Ab2KVTv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2KVTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:24 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 23/46] staging: line6: drop midi_postprocess sysfs attr
Date: Thu, 22 Nov 2012 20:49:02 +0100
Message-Id: <1353613765-18690-24-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 797f6e0..37b20d7 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -371,38 +371,6 @@ static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
 }
 
 /*
-	"read" request on "midi_postprocess" special file.
-*/
-static ssize_t pod_get_midi_postprocess(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", pod->midi_postprocess);
-}
-
-/*
-	"write" request on "midi_postprocess" special file.
-*/
-static ssize_t pod_set_midi_postprocess(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	pod->midi_postprocess = value ? 1 : 0;
-	return count;
-}
-
-/*
 	"read" request on "serial_number" special file.
 */
 static ssize_t pod_get_serial_number(struct device *dev,
@@ -510,8 +478,6 @@ static void pod_startup5(struct work_struct *work)
 static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
 static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
-static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
-		   pod_get_midi_postprocess, pod_set_midi_postprocess);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
 
@@ -594,7 +560,6 @@ static int pod_create_files2(struct device *dev)
 
 	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
 
 #ifdef CONFIG_LINE6_USB_RAW
@@ -708,7 +673,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 
 			device_remove_file(dev, &dev_attr_device_id);
 			device_remove_file(dev, &dev_attr_firmware_version);
-			device_remove_file(dev, &dev_attr_midi_postprocess);
 			device_remove_file(dev, &dev_attr_serial_number);
 
 #ifdef CONFIG_LINE6_USB_RAW
-- 
1.8.0


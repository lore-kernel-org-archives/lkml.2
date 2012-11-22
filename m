Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab2KVTuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:50:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59757 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab2KVTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:59 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 09/46] staging: line6: drop name sysfs attr
Date: Thu, 22 Nov 2012 20:48:48 +0100
Message-Id: <1353613765-18690-10-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 165c7ad..76525c5 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -476,18 +476,6 @@ static ssize_t get_name_generic(struct usb_line6_pod *pod, const char *str,
 /*
 	"read" request on "name" special file.
 */
-static ssize_t pod_get_name(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return get_name_generic(pod, pod->prog_data.header + POD_NAME_OFFSET,
-				buf);
-}
-
-/*
-	"read" request on "name" special file.
-*/
 static ssize_t pod_get_name_buf(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -862,7 +850,6 @@ static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
 static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(name, S_IRUGO, pod_get_name, line6_nop_write);
 static DEVICE_ATTR(name_buf, S_IRUGO, pod_get_name_buf, line6_nop_write);
 static DEVICE_ATTR(retrieve_amp_setup, S_IWUSR, line6_nop_read,
 		   pod_set_retrieve_amp_setup);
@@ -968,7 +955,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_name_buf));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_amp_setup));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_channel));
@@ -1103,7 +1089,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
-			device_remove_file(dev, &dev_attr_name);
 			device_remove_file(dev, &dev_attr_name_buf);
 			device_remove_file(dev, &dev_attr_retrieve_amp_setup);
 			device_remove_file(dev, &dev_attr_retrieve_channel);
-- 
1.8.0


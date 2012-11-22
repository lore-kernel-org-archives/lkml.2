Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2KVTuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:50:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54328 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab2KVTuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:01 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 10/46] staging: line6: drop name_buf sysfs attr
Date: Thu, 22 Nov 2012 20:48:49 +0100
Message-Id: <1353613765-18690-11-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 76525c5..dbf821e 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -447,46 +447,6 @@ static ssize_t pod_send_retrieve_command(struct device *dev, const char *buf,
 }
 
 /*
-	Generic get name function.
-*/
-static ssize_t get_name_generic(struct usb_line6_pod *pod, const char *str,
-				char *buf)
-{
-	int length = 0;
-	const char *p1;
-	char *p2;
-	char *last_non_space = buf;
-
-	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
-	if (retval < 0)
-		return retval;
-
-	for (p1 = str, p2 = buf; *p1; ++p1, ++p2) {
-		*p2 = *p1;
-		if (*p2 != ' ')
-			last_non_space = p2;
-		if (++length == POD_NAME_LENGTH)
-			break;
-	}
-
-	*(last_non_space + 1) = '\n';
-	return last_non_space - buf + 2;
-}
-
-/*
-	"read" request on "name" special file.
-*/
-static ssize_t pod_get_name_buf(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return get_name_generic(pod,
-				pod->prog_data_buf.header + POD_NAME_OFFSET,
-				buf);
-}
-
-/*
 	Identify system parameters related to the tuner.
 */
 static bool pod_is_tuner(int code)
@@ -850,7 +810,6 @@ static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
 static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(name_buf, S_IRUGO, pod_get_name_buf, line6_nop_write);
 static DEVICE_ATTR(retrieve_amp_setup, S_IWUSR, line6_nop_read,
 		   pod_set_retrieve_amp_setup);
 static DEVICE_ATTR(retrieve_channel, S_IWUSR, line6_nop_read,
@@ -955,7 +914,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_name_buf));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_amp_setup));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_channel));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_effects_setup));
@@ -1089,7 +1047,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
-			device_remove_file(dev, &dev_attr_name_buf);
 			device_remove_file(dev, &dev_attr_retrieve_amp_setup);
 			device_remove_file(dev, &dev_attr_retrieve_channel);
 			device_remove_file(dev,
-- 
1.8.0


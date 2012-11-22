Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2KVUOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:14:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab2KVTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:07 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 14/46] staging: line6: drop store_amp_setup sysfs attr
Date: Thu, 22 Nov 2012 20:48:53 +0100
Message-Id: <1353613765-18690-15-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 95769c5..deafee9 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -565,16 +565,6 @@ static ssize_t pod_set_store_effects_setup(struct device *dev,
 }
 
 /*
-	"write" request on "store_amp_setup" special file.
-*/
-static ssize_t pod_set_store_amp_setup(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t count)
-{
-	return pod_send_store_command(dev, buf, count, 0x0040, 0x0100);
-}
-
-/*
 	"read" request on "midi_postprocess" special file.
 */
 static ssize_t pod_get_midi_postprocess(struct device *dev,
@@ -751,8 +741,6 @@ static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing,
 		   pod_set_routing);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
-static DEVICE_ATTR(store_amp_setup, S_IWUSR, line6_nop_read,
-		   pod_set_store_amp_setup);
 static DEVICE_ATTR(store_channel, S_IWUSR, line6_nop_read,
 		   pod_set_store_channel);
 static DEVICE_ATTR(store_effects_setup, S_IWUSR, line6_nop_read,
@@ -847,7 +835,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_routing));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_store_amp_setup));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_store_channel));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_store_effects_setup));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_freq));
@@ -977,7 +964,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_midi_postprocess);
 			device_remove_file(dev, &dev_attr_routing);
 			device_remove_file(dev, &dev_attr_serial_number);
-			device_remove_file(dev, &dev_attr_store_amp_setup);
 			device_remove_file(dev, &dev_attr_store_channel);
 			device_remove_file(dev, &dev_attr_store_effects_setup);
 			device_remove_file(dev, &dev_attr_tuner_freq);
-- 
1.8.0


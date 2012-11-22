Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2KVUOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:14:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59757 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab2KVTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:04 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 12/46] staging: line6: drop retrieve_channel sysfs attr
Date: Thu, 22 Nov 2012 20:48:51 +0100
Message-Id: <1353613765-18690-13-git-send-email-stefanha@gmail.com>
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
index 6d6cd5a..bc65fc7 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -608,16 +608,6 @@ static ssize_t pod_set_store_amp_setup(struct device *dev,
 }
 
 /*
-	"write" request on "retrieve_channel" special file.
-*/
-static ssize_t pod_set_retrieve_channel(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	return pod_send_retrieve_command(dev, buf, count, 0x0000, 0x00c0);
-}
-
-/*
 	"write" request on "retrieve_effects_setup" special file.
 */
 static ssize_t pod_set_retrieve_effects_setup(struct device *dev,
@@ -800,8 +790,6 @@ static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
 static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(retrieve_channel, S_IWUSR, line6_nop_read,
-		   pod_set_retrieve_channel);
 static DEVICE_ATTR(retrieve_effects_setup, S_IWUSR, line6_nop_read,
 		   pod_set_retrieve_effects_setup);
 static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing,
@@ -902,7 +890,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_channel));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_effects_setup));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_routing));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
@@ -1034,7 +1021,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
-			device_remove_file(dev, &dev_attr_retrieve_channel);
 			device_remove_file(dev,
 					   &dev_attr_retrieve_effects_setup);
 			device_remove_file(dev, &dev_attr_routing);
-- 
1.8.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197Ab2KVTuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:50:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2KVTuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:12 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 17/46] staging: line6: drop routing sysfs attr
Date: Thu, 22 Nov 2012 20:48:56 +0100
Message-Id: <1353613765-18690-18-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 8 --------
 drivers/staging/line6/pod.h | 9 ---------
 2 files changed, 17 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 949b8f7..f84a4ea 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -40,7 +40,6 @@ enum {
 
 enum {
 	POD_monitor_level  = 0x04,
-	POD_routing        = 0x05,
 	POD_tuner_mute     = 0x13,
 	POD_tuner_freq     = 0x15,
 	POD_tuner_note     = 0x16,
@@ -248,7 +247,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 						pod->monitor_level = value;
 						break;
 
-						PROCESS_SYSTEM_PARAM(routing);
 						PROCESS_SYSTEM_PARAM
 						    (tuner_mute);
 						PROCESS_SYSTEM_PARAM
@@ -647,7 +645,6 @@ static ssize_t pod_set_ ## code(struct device *dev, \
 	return pod_set_system_param_string(pod, buf, count, POD_ ## code, mask); \
 }
 
-POD_GET_SET_SYSTEM_PARAM(routing, 0x0003, 0);
 POD_GET_SET_SYSTEM_PARAM(tuner_mute, 0x0001, 0);
 POD_GET_SET_SYSTEM_PARAM(tuner_freq, 0xffff, 0);
 POD_GET_SYSTEM_PARAM(tuner_note, 1);
@@ -663,8 +660,6 @@ static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
 static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing,
-		   pod_set_routing);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
 static DEVICE_ATTR(tuner_freq, S_IWUSR | S_IRUGO, pod_get_tuner_freq,
@@ -755,7 +750,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_routing));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_freq));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_mute));
@@ -785,7 +779,6 @@ static int pod_try_init(struct usb_interface *interface,
 		return -ENODEV;
 
 	/* initialize wait queues: */
-	init_waitqueue_head(&pod->routing.wait);
 	init_waitqueue_head(&pod->tuner_mute.wait);
 	init_waitqueue_head(&pod->tuner_freq.wait);
 	init_waitqueue_head(&pod->tuner_note.wait);
@@ -882,7 +875,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
-			device_remove_file(dev, &dev_attr_routing);
 			device_remove_file(dev, &dev_attr_serial_number);
 			device_remove_file(dev, &dev_attr_tuner_freq);
 			device_remove_file(dev, &dev_attr_tuner_mute);
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index d5bbd2f..732311a 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -124,15 +124,6 @@ struct usb_line6_pod {
 	int monitor_level;
 
 	/**
-		Audio routing mode.
-		0: send processed guitar
-		1: send clean guitar
-		2: send clean guitar re-amp playback
-		3: send re-amp playback
-	*/
-	struct ValueWait routing;
-
-	/**
 		Timer for device initializaton.
 	*/
 	struct timer_list startup_timer;
-- 
1.8.0


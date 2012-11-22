Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2KVTvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2KVTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:18 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 19/46] staging: line6: drop tuner_note sysfs attr
Date: Thu, 22 Nov 2012 20:48:58 +0100
Message-Id: <1353613765-18690-20-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 7 -------
 drivers/staging/line6/pod.h | 5 -----
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 3184570..57fbe27 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -250,8 +250,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 						PROCESS_SYSTEM_PARAM
 						    (tuner_mute);
 						PROCESS_SYSTEM_PARAM
-						    (tuner_note);
-						PROCESS_SYSTEM_PARAM
 						    (tuner_pitch);
 
 #undef PROCESS_SYSTEM_PARAM
@@ -644,7 +642,6 @@ static ssize_t pod_set_ ## code(struct device *dev, \
 }
 
 POD_GET_SET_SYSTEM_PARAM(tuner_mute, 0x0001, 0);
-POD_GET_SYSTEM_PARAM(tuner_note, 1);
 POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
 
 #undef GET_SET_SYSTEM_PARAM
@@ -661,7 +658,6 @@ static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
 static DEVICE_ATTR(tuner_mute, S_IWUSR | S_IRUGO, pod_get_tuner_mute,
 		   pod_set_tuner_mute);
-static DEVICE_ATTR(tuner_note, S_IRUGO, pod_get_tuner_note, line6_nop_write);
 static DEVICE_ATTR(tuner_pitch, S_IRUGO, pod_get_tuner_pitch, line6_nop_write);
 
 #ifdef CONFIG_LINE6_USB_RAW
@@ -747,7 +743,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_mute));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_note));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_pitch));
 
 #ifdef CONFIG_LINE6_USB_RAW
@@ -774,7 +769,6 @@ static int pod_try_init(struct usb_interface *interface,
 
 	/* initialize wait queues: */
 	init_waitqueue_head(&pod->tuner_mute.wait);
-	init_waitqueue_head(&pod->tuner_note.wait);
 	init_waitqueue_head(&pod->tuner_pitch.wait);
 
 	/* initialize USB buffers: */
@@ -870,7 +864,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_midi_postprocess);
 			device_remove_file(dev, &dev_attr_serial_number);
 			device_remove_file(dev, &dev_attr_tuner_mute);
-			device_remove_file(dev, &dev_attr_tuner_note);
 			device_remove_file(dev, &dev_attr_tuner_pitch);
 
 #ifdef CONFIG_LINE6_USB_RAW
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 91f2661..1659120 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -104,11 +104,6 @@ struct usb_line6_pod {
 	struct ValueWait tuner_mute;
 
 	/**
-		Note received from tuner.
-	*/
-	struct ValueWait tuner_note;
-
-	/**
 		Pitch value received from tuner.
 	*/
 	struct ValueWait tuner_pitch;
-- 
1.8.0


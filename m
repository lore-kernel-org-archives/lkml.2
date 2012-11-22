Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2KVULx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:11:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59757 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab2KVTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:14 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 18/46] staging: line6: drop tuner_freq sysfs attr
Date: Thu, 22 Nov 2012 20:48:57 +0100
Message-Id: <1353613765-18690-19-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 8 --------
 drivers/staging/line6/pod.h | 5 -----
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index f84a4ea..3184570 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -250,8 +250,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 						PROCESS_SYSTEM_PARAM
 						    (tuner_mute);
 						PROCESS_SYSTEM_PARAM
-						    (tuner_freq);
-						PROCESS_SYSTEM_PARAM
 						    (tuner_note);
 						PROCESS_SYSTEM_PARAM
 						    (tuner_pitch);
@@ -646,7 +644,6 @@ static ssize_t pod_set_ ## code(struct device *dev, \
 }
 
 POD_GET_SET_SYSTEM_PARAM(tuner_mute, 0x0001, 0);
-POD_GET_SET_SYSTEM_PARAM(tuner_freq, 0xffff, 0);
 POD_GET_SYSTEM_PARAM(tuner_note, 1);
 POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
 
@@ -662,8 +659,6 @@ static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
-static DEVICE_ATTR(tuner_freq, S_IWUSR | S_IRUGO, pod_get_tuner_freq,
-		   pod_set_tuner_freq);
 static DEVICE_ATTR(tuner_mute, S_IWUSR | S_IRUGO, pod_get_tuner_mute,
 		   pod_set_tuner_mute);
 static DEVICE_ATTR(tuner_note, S_IRUGO, pod_get_tuner_note, line6_nop_write);
@@ -751,7 +746,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_freq));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_mute));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_note));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_pitch));
@@ -780,7 +774,6 @@ static int pod_try_init(struct usb_interface *interface,
 
 	/* initialize wait queues: */
 	init_waitqueue_head(&pod->tuner_mute.wait);
-	init_waitqueue_head(&pod->tuner_freq.wait);
 	init_waitqueue_head(&pod->tuner_note.wait);
 	init_waitqueue_head(&pod->tuner_pitch.wait);
 
@@ -876,7 +869,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
 			device_remove_file(dev, &dev_attr_serial_number);
-			device_remove_file(dev, &dev_attr_tuner_freq);
 			device_remove_file(dev, &dev_attr_tuner_mute);
 			device_remove_file(dev, &dev_attr_tuner_note);
 			device_remove_file(dev, &dev_attr_tuner_pitch);
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 732311a..91f2661 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -104,11 +104,6 @@ struct usb_line6_pod {
 	struct ValueWait tuner_mute;
 
 	/**
-		Tuner base frequency (typically 440Hz).
-	*/
-	struct ValueWait tuner_freq;
-
-	/**
 		Note received from tuner.
 	*/
 	struct ValueWait tuner_note;
-- 
1.8.0


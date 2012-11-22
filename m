Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242Ab2KVTvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030226Ab2KVTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:31 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 27/46] staging: line6: drop pod.c raw sysfs attr
Date: Thu, 22 Nov 2012 20:49:06 +0100
Message-Id: <1353613765-18690-28-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw sysfs attr transmits MIDI messages with less filtering.  This
was a useful debugging tool while the staging driver still had a lot of
state and filtering.  It is not useful anymore since the filtering is
being dropped.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index ddd0e54..db9c905 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -447,10 +447,6 @@ static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
 
-#ifdef CONFIG_LINE6_USB_RAW
-static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
-#endif
-
 /* control info callback */
 static int snd_pod_control_monitor_info(struct snd_kcontrol *kcontrol,
 					struct snd_ctl_elem_info *uinfo)
@@ -527,11 +523,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
-
-#ifdef CONFIG_LINE6_USB_RAW
-	CHECK_RETURN(device_create_file(dev, &dev_attr_raw));
-#endif
-
 	return 0;
 }
 
@@ -640,10 +631,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_device_id);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_serial_number);
-
-#ifdef CONFIG_LINE6_USB_RAW
-			device_remove_file(dev, &dev_attr_raw);
-#endif
 		}
 	}
 
-- 
1.8.0


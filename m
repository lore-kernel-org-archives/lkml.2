Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab1IMLR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:17:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61128 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1IMLRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:17:15 -0400
From: Arvydas Sidorenko <asido4@gmail.com>
To: mchehab@infradead.org
Cc: asido4@gmail.com, hverkuil@xs4all.nl, arnd@arndb.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/media/video/stk-webcam.c: coding style issue
Date: Tue, 13 Sep 2011 13:18:11 +0200
Message-Id: <1315912691-11227-2-git-send-email-asido4@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315912691-11227-1-git-send-email-asido4@gmail.com>
References: <1315912691-11227-1-git-send-email-asido4@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl gave some coding style errors, so on the way to the first
patch I added the fix to them.

Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/video/stk-webcam.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 859e78f..5fc6bbc 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -518,7 +518,7 @@ static int stk_prepare_sio_buffers(struct stk_camera *dev, unsigned n_sbufs)
 			return -ENOMEM;
 		for (i = 0; i < n_sbufs; i++) {
 			if (stk_setup_siobuf(dev, i))
-				return (dev->n_sbufs > 1)? 0 : -ENOMEM;
+				return (dev->n_sbufs > 1 ? 0 : -ENOMEM);
 			dev->n_sbufs = i+1;
 		}
 	}
@@ -558,9 +558,8 @@ static int v4l_stk_open(struct file *fp)
 	vdev = video_devdata(fp);
 	dev = vdev_to_camera(vdev);
 
-	if (dev == NULL || !is_present(dev)) {
+	if (dev == NULL || !is_present(dev))
 		return -ENXIO;
-	}
 	fp->private_data = dev;
 	usb_autopm_get_interface(dev->interface);
 
@@ -579,7 +578,7 @@ static int v4l_stk_release(struct file *fp)
 		dev->owner = NULL;
 	}
 
-	if(is_present(dev))
+	if (is_present(dev))
 		usb_autopm_put_interface(dev->interface);
 
 	return 0;
@@ -656,7 +655,7 @@ static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 		return POLLERR;
 
 	if (!list_empty(&dev->sio_full))
-		return (POLLIN | POLLRDNORM);
+		return POLLIN | POLLRDNORM;
 
 	return 0;
 }
@@ -893,9 +892,9 @@ static int stk_vidioc_g_fmt_vid_cap(struct file *filp,
 	struct stk_camera *dev = priv;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(stk_sizes)
-			&& stk_sizes[i].m != dev->vsettings.mode;
-		i++);
+	for (i = 0; i < ARRAY_SIZE(stk_sizes) &&
+			stk_sizes[i].m != dev->vsettings.mode; i++)
+		;
 	if (i == ARRAY_SIZE(stk_sizes)) {
 		STK_ERROR("ERROR: mode invalid\n");
 		return -EINVAL;
@@ -1307,9 +1306,8 @@ static int stk_camera_probe(struct usb_interface *interface,
 	usb_set_intfdata(interface, dev);
 
 	err = stk_register_video_device(dev);
-	if (err) {
+	if (err)
 		goto error;
-	}
 
 	return 0;
 
-- 
1.7.4.4


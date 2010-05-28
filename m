Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab0E1EJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:09:28 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:34936 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0E1EJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FgQaVRakpnyLPL2WLyiy7wgPskgdATL7NvImngHEt5bnScUOyNvd02vzTy6+H5Qyek
         42bHsRym7ehM0cUnpVp4ZQBThXBMAr1jNTmtXaIaa5YR12e/juCmL1P00eiHv/mHMRtb
         mDVd8eiXSffJvW+eO7AyIUyznXAvx4fEpdIKc=
From: Scott Kidder <scott.kidder11@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
       palash.bandyopahdyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Scott Kidder <scott.kidder11@gmail.com>
Subject: [PATCH] Staging: cx25821: added KERN_ facility levels
Date: Fri, 28 May 2010 00:21:51 -0500
Message-Id: <1275024111-10322-1-git-send-email-scott.kidder11@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed issues found by checkpatch.pl including adding KERN_
facility levels to printk() calls and C99 comments.

Signed-off-by: Scott Kidder <scott.kidder11@gmail.com>
---
 drivers/staging/cx25821/cx25821-audups11.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audups11.c b/drivers/staging/cx25821/cx25821-audups11.c
index e49ead9..8debde1 100644
--- a/drivers/staging/cx25821/cx25821-audups11.c
+++ b/drivers/staging/cx25821/cx25821-audups11.c
@@ -82,9 +82,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 		}
 	}
 
-	if (list_empty(&q->active)) {
+	if (list_empty(&q->active))
 		dprintk(2, "active queue empty!\n");
-	}
 }
 
 static struct videobuf_queue_ops cx25821_video_qops = {
@@ -101,7 +100,7 @@ static int video_open(struct file *file)
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+	printk(KERN_INFO "open dev=%s type=%s\n", video_device_node_name(vdev),
 		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
@@ -139,7 +138,7 @@ static int video_open(struct file *file)
 }
 
 static ssize_t video_read(struct file *file, char __user * data, size_t count,
-			  loff_t * ppos)
+			  loff_t *ppos)
 {
 	struct cx25821_fh *fh = file->private_data;
 
@@ -187,8 +186,8 @@ static int video_release(struct file *file)
 	struct cx25821_fh *fh = file->private_data;
 	struct cx25821_dev *dev = fh->dev;
 
-	//stop the risc engine and fifo
-	//cx_write(channel11->dma_ctl, 0);
+	/* stop the risc engine and fifo */
+	/* cx_write(channel11->dma_ctl, 0); */
 
 	/* stop video capture */
 	if (cx25821_res_check(fh, RESOURCE_VIDEO11)) {
@@ -216,17 +215,14 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev = fh->dev;
 
-	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
+	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
 		return -EINVAL;
-	}
 
-	if (unlikely(i != fh->type)) {
+	if (unlikely(i != fh->type))
 		return -EINVAL;
-	}
 
-	if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO11)))) {
+	if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO11))))
 		return -EBUSY;
-	}
 
 	return videobuf_streamon(get_queue(fh));
 }
@@ -297,9 +293,8 @@ static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 
 	command = data_from_user->command;
 
-	if (command != UPSTREAM_START_AUDIO && command != UPSTREAM_STOP_AUDIO) {
+	if (command != UPSTREAM_START_AUDIO && command != UPSTREAM_STOP_AUDIO)
 		return 0;
-	}
 
 	dev->input_filename = data_from_user->input_filename;
 	dev->input_audiofilename = data_from_user->input_filename;
@@ -357,7 +352,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	return 0;
 }
 
-// exported stuff
+/* exported stuff */
 static const struct v4l2_file_operations video_fops = {
 	.owner = THIS_MODULE,
 	.open = video_open,
-- 
1.7.1


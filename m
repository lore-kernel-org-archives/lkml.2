Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab1FBCWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 22:22:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42186 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab1FBCV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 22:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VP1MijvFaRDkF5U3RiSAdV8Bb3yDsbIuu/JcOT3Z0BY7JvNnjDd88zrxW3Ch4ISDCN
         YaRBpMjlWOkBGaVvJ7In6gdFOK9W7rCCoa+2EEyR8Xyj9AnS2mj8xoI9uCxabMCd+/wI
         mmKrhTK7Opqy/3/KN537cjSHeL0k2Ci7vnGao=
From: Curtis McEnroe <programble@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, stefan.ringel@arcor.de,
        d.belimov@gmail.com, hverkuil@xs4all.nl
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Curtis McEnroe <programble@gmail.com>
Subject: [PATCH] [media] tm6000: cleaned up code in tm6000-video.c according to coding style
Date: Wed,  1 Jun 2011 22:21:56 -0400
Message-Id: <1306981316-15244-1-git-send-email-programble@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all errors reported by the checker in tm6000-video.c mostly relating
to whitespace.

P.S. First ever patch to the kernel. Had some free time and wanted to help.

Signed-off-by: Curtis McEnroe <programble@gmail.com>
---
 drivers/staging/tm6000/tm6000-video.c |   39 +++++++++++++++++----------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4264064..5789624 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -777,7 +777,8 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	}
 
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		if (0 != (rc = videobuf_iolock(vq, &buf->vb, NULL)))
+		rc = videobuf_iolock(vq, &buf->vb, NULL);
+		if (rc != 0)
 			goto fail;
 		urb_init = 1;
 	}
@@ -1048,12 +1049,12 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 
 	if (!res_get(dev, fh, false))
 		return -EBUSY;
-	return (videobuf_streamon(&fh->vb_vidq));
+	return videobuf_streamon(&fh->vb_vidq);
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 	struct tm6000_core *dev    = fh->dev;
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1062,15 +1063,15 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 		return -EINVAL;
 
 	videobuf_streamoff(&fh->vb_vidq);
-	res_free(dev,fh);
+	res_free(dev, fh);
 
-	return (0);
+	return 0;
 }
 
-static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	int rc=0;
-	struct tm6000_fh   *fh=priv;
+	int rc = 0;
+	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 
 	dev->norm = *norm;
@@ -1079,7 +1080,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	fh->width  = dev->width;
 	fh->height = dev->height;
 
-	if (rc<0)
+	if (rc < 0)
 		return rc;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
@@ -1087,7 +1088,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	return 0;
 }
 
-static const char *iname [] = {
+static const char *iname[] = {
 	[TM6000_INPUT_TV] = "Television",
 	[TM6000_INPUT_COMPOSITE1] = "Composite 1",
 	[TM6000_INPUT_COMPOSITE2] = "Composite 2",
@@ -1394,10 +1395,10 @@ static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
 	struct tm6000_fh *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	if (dev->input !=5)
+	if (dev->input != 5)
 		return -EINVAL;
 
-	*i = dev->input -5;
+	*i = dev->input - 5;
 
 	return 0;
 }
@@ -1508,18 +1509,18 @@ static int tm6000_open(struct file *file)
 
 	fh->fmt      = format_by_fourcc(dev->fourcc);
 
-	tm6000_get_std_res (dev);
+	tm6000_get_std_res(dev);
 
 	fh->width    = dev->width;
 	fh->height   = dev->height;
 
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=0x%08lx, dev=0x%08lx, "
 						"dev->vidq=0x%08lx\n",
-		(unsigned long)fh,(unsigned long)dev,(unsigned long)&dev->vidq);
+		(unsigned long)fh, (unsigned long)dev, (unsigned long)&dev->vidq);
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"queued=%d\n",list_empty(&dev->vidq.queued));
+				"queued=%d\n", list_empty(&dev->vidq.queued));
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"active=%d\n",list_empty(&dev->vidq.active));
+				"active=%d\n", list_empty(&dev->vidq.active));
 
 	/* initialize hardware on analog mode */
 	rc = tm6000_init_analog_mode(dev);
@@ -1557,7 +1558,7 @@ tm6000_read(struct file *file, char __user *data, size_t count, loff_t *pos)
 {
 	struct tm6000_fh        *fh = file->private_data;
 
-	if (fh->type==V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (!res_get(fh->dev, fh, true))
 			return -EBUSY;
 
@@ -1583,7 +1584,7 @@ tm6000_poll(struct file *file, struct poll_table_struct *wait)
 		/* streaming capture */
 		if (list_empty(&fh->vb_vidq.stream))
 			return POLLERR;
-		buf = list_entry(fh->vb_vidq.stream.next,struct tm6000_buffer,vb.stream);
+		buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
 	} else {
 		/* read() capture */
 		return videobuf_poll_stream(file, &fh->vb_vidq,
@@ -1699,7 +1700,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 struct video_device tm6000_radio_template = {
 	.name			= "tm6000",
 	.fops			= &radio_fops,
-	.ioctl_ops 		= &radio_ioctl_ops,
+	.ioctl_ops		= &radio_ioctl_ops,
 };
 
 /* -----------------------------------------------------------------
-- 
1.7.5.2


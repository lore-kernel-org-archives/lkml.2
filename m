Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1IPGQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:16:45 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:54926 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1IPGQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:16:41 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 02/44] Staging: cx25821: Fix function signatures
Date: Fri, 16 Sep 2011 14:14:35 +0800
Message-Id: <1316153717-7272-3-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long function signatures (over 80 characters) and indent them
properly.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   49 ++++++++++++++++++++-----------
 1 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 8bdd1e8..4a365bb 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -110,7 +110,8 @@ struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
 	return NULL;
 }
 
-void cx25821_dump_video_queue(struct cx25821_dev *dev, struct cx25821_dmaqueue *q)
+void cx25821_dump_video_queue(struct cx25821_dev *dev,
+			      struct cx25821_dmaqueue *q)
 {
 	struct cx25821_buffer *buf;
 	struct list_head *item;
@@ -220,7 +221,8 @@ static int cx25821_ctrl_query(struct v4l2_queryctrl *qctrl)
 */
 
 /* resource management */
-int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh, unsigned int bit)
+int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
+		    unsigned int bit)
 {
 	dprintk(1, "%s()\n", __func__);
 	if (fh->resources & bit)
@@ -252,7 +254,8 @@ int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit)
        return fh->dev->channels[fh->channel_id].resources & bit;
 }
 
-void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh, unsigned int bits)
+void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
+		      unsigned int bits)
 {
 	BUG_ON((fh->resources & bits) != bits);
 	dprintk(1, "%s()\n", __func__);
@@ -684,7 +687,8 @@ fail:
 	return rc;
 }
 
-void cx25821_buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+void cx25821_buffer_release(struct videobuf_queue *q,
+			    struct videobuf_buffer *vb)
 {
 	struct cx25821_buffer *buf =
 	    container_of(vb, struct cx25821_buffer, vb);
@@ -992,7 +996,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 }
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-			       struct v4l2_format *f)
+				struct v4l2_format *f)
 {
        struct cx25821_fh *fh = priv;
        struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
@@ -1101,8 +1105,9 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
        return cx25821_set_control(dev, ctl, fh->channel_id);
 }
 
-/* VIDEO IOCTLS                                                       */
-int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f)
+/* VIDEO IOCTLS */
+int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				 struct v4l2_format *f)
 {
 	struct cx25821_fh *fh = priv;
 
@@ -1116,7 +1121,8 @@ int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv, struct v4l2_form
 	return 0;
 }
 
-int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f)
+int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_format *f)
 {
 	struct cx25821_fmt *fmt;
 	enum v4l2_field field;
@@ -1162,7 +1168,8 @@ int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_fo
 	return 0;
 }
 
-int cx25821_vidioc_querycap(struct file *file, void *priv, struct v4l2_capability *cap)
+int cx25821_vidioc_querycap(struct file *file, void *priv,
+			    struct v4l2_capability *cap)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 
@@ -1189,13 +1196,15 @@ int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-int cx25821_vidioc_reqbufs(struct file *file, void *priv, struct v4l2_requestbuffers *p)
+int cx25821_vidioc_reqbufs(struct file *file, void *priv,
+			   struct v4l2_requestbuffers *p)
 {
 	struct cx25821_fh *fh = priv;
 	return videobuf_reqbufs(get_queue(fh), p);
 }
 
-int cx25821_vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+int cx25821_vidioc_querybuf(struct file *file, void *priv,
+			    struct v4l2_buffer *p)
 {
 	struct cx25821_fh *fh = priv;
 	return videobuf_querybuf(get_queue(fh), p);
@@ -1217,7 +1226,8 @@ int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
 	return 0;
 }
 
-int cx25821_vidioc_s_priority(struct file *file, void *f, enum v4l2_priority prio)
+int cx25821_vidioc_s_priority(struct file *file, void *f,
+			      enum v4l2_priority prio)
 {
 	struct cx25821_fh *fh = f;
 	struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;
@@ -1280,7 +1290,8 @@ int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i)
 	return 0;
 }
 
-int cx25821_vidioc_enum_input(struct file *file, void *priv, struct v4l2_input *i)
+int cx25821_vidioc_enum_input(struct file *file, void *priv,
+			      struct v4l2_input *i)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	dprintk(1, "%s()\n", __func__);
@@ -1323,7 +1334,8 @@ int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 }
 
 #ifdef TUNER_FLAG
-int cx25821_vidioc_g_frequency(struct file *file, void *priv, struct v4l2_frequency *f)
+int cx25821_vidioc_g_frequency(struct file *file, void *priv,
+			       struct v4l2_frequency *f)
 {
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev = fh->dev;
@@ -1350,7 +1362,8 @@ int cx25821_set_freq(struct cx25821_dev *dev, struct v4l2_frequency *f)
 	return 0;
 }
 
-int cx25821_vidioc_s_frequency(struct file *file, void *priv, struct v4l2_frequency *f)
+int cx25821_vidioc_s_frequency(struct file *file, void *priv,
+			       struct v4l2_frequency *f)
 {
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev;
@@ -1522,7 +1535,8 @@ static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
 	return NULL;
 }
 
-int cx25821_vidioc_g_ctrl(struct file *file, void *priv, struct v4l2_control *ctl)
+int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
+			  struct v4l2_control *ctl)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
        struct cx25821_fh *fh = priv;
@@ -1612,7 +1626,8 @@ static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num)
 	}
 }
 
-int cx25821_vidioc_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cropcap)
+int cx25821_vidioc_cropcap(struct file *file, void *priv,
+			   struct v4l2_cropcap *cropcap)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 
-- 
1.7.0.4


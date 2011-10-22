Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1JVFt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:49:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1JVFtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:49:55 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 34/36] Staging: cx25821: cx25821-video.c: Fix indent
Date: Sat, 22 Oct 2011 13:43:54 +0800
Message-Id: <1319262236-6498-35-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indent of statements to improve readability.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   79 +++++++++++++++----------------
 1 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 1f9309b..bc6af41 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -118,12 +118,12 @@ void cx25821_dump_video_queue(struct cx25821_dev *dev,
 
 	if (!list_empty(&q->active)) {
 		list_for_each(item, &q->active)
-		    buf = list_entry(item, struct cx25821_buffer, vb.queue);
+			buf = list_entry(item, struct cx25821_buffer, vb.queue);
 	}
 
 	if (!list_empty(&q->queued)) {
 		list_for_each(item, &q->queued)
-		    buf = list_entry(item, struct cx25821_buffer, vb.queue);
+			buf = list_entry(item, struct cx25821_buffer, vb.queue);
 	}
 
 }
@@ -484,8 +484,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		cx25821_init_controls(dev, i);
 
 		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
-				dev->channels[i].sram_channels->dma_ctl,
-				0x11, 0);
+			dev->channels[i].sram_channels->dma_ctl, 0x11, 0);
 
 		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
 		dev->channels[i].video_dev = NULL;
@@ -557,7 +556,7 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	struct cx25821_fh *fh = q->priv_data;
 	struct cx25821_dev *dev = fh->dev;
 	struct cx25821_buffer *buf =
-	    container_of(vb, struct cx25821_buffer, vb);
+		container_of(vb, struct cx25821_buffer, vb);
 	int rc, init_buffer = 0;
 	u32 line0_offset, line1_offset;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
@@ -684,7 +683,7 @@ void cx25821_buffer_release(struct videobuf_queue *q,
 			    struct videobuf_buffer *vb)
 {
 	struct cx25821_buffer *buf =
-	    container_of(vb, struct cx25821_buffer, vb);
+		container_of(vb, struct cx25821_buffer, vb);
 
 	cx25821_free_buffer(q, buf);
 }
@@ -722,7 +721,7 @@ int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
 static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
 	struct cx25821_buffer *buf =
-	   container_of(vb, struct cx25821_buffer, vb);
+		container_of(vb, struct cx25821_buffer, vb);
 	struct cx25821_buffer *prev;
 	struct cx25821_fh *fh = vq->priv_data;
 	struct cx25821_dev *dev = fh->dev;
@@ -813,7 +812,7 @@ static int video_open(struct file *file)
 
 		for (i = 0; i < MAX_VID_CHANNEL_NUM; i++) {
 			if (h->channels[i].video_dev &&
-			   h->channels[i].video_dev->minor == minor) {
+			    h->channels[i].video_dev->minor == minor) {
 				dev = h;
 				ch_id = i;
 				type  = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1453,38 +1452,38 @@ static const struct v4l2_queryctrl no_ctl = {
 static struct v4l2_queryctrl cx25821_ctls[] = {
 	/* --- video --- */
 	{
-	 .id = V4L2_CID_BRIGHTNESS,
-	 .name = "Brightness",
-	 .minimum = 0,
-	 .maximum = 10000,
-	 .step = 1,
-	 .default_value = 6200,
-	 .type = V4L2_CTRL_TYPE_INTEGER,
-	 }, {
-	     .id = V4L2_CID_CONTRAST,
-	     .name = "Contrast",
-	     .minimum = 0,
-	     .maximum = 10000,
-	     .step = 1,
-	     .default_value = 5000,
-	     .type = V4L2_CTRL_TYPE_INTEGER,
-	     }, {
-		 .id = V4L2_CID_SATURATION,
-		 .name = "Saturation",
-		 .minimum = 0,
-		 .maximum = 10000,
-		 .step = 1,
-		 .default_value = 5000,
-		 .type = V4L2_CTRL_TYPE_INTEGER,
-		 }, {
-		     .id = V4L2_CID_HUE,
-		     .name = "Hue",
-		     .minimum = 0,
-		     .maximum = 10000,
-		     .step = 1,
-		     .default_value = 5000,
-		     .type = V4L2_CTRL_TYPE_INTEGER,
-		     }
+		.id = V4L2_CID_BRIGHTNESS,
+		.name = "Brightness",
+		.minimum = 0,
+		.maximum = 10000,
+		.step = 1,
+		.default_value = 6200,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+	}, {
+		.id = V4L2_CID_CONTRAST,
+		.name = "Contrast",
+		.minimum = 0,
+		.maximum = 10000,
+		.step = 1,
+		.default_value = 5000,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+	}, {
+		.id = V4L2_CID_SATURATION,
+		.name = "Saturation",
+		.minimum = 0,
+		.maximum = 10000,
+		.step = 1,
+		.default_value = 5000,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+	}, {
+		.id = V4L2_CID_HUE,
+		.name = "Hue",
+		.minimum = 0,
+		.maximum = 10000,
+		.step = 1,
+		.default_value = 5000,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+	}
 };
 static const int CX25821_CTLS = ARRAY_SIZE(cx25821_ctls);
 
-- 
1.7.0.4


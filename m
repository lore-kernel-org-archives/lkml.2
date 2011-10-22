Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1JVFuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:50:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1JVFuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:50:04 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 35/36] Staging: cx25821: cx25821-video.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:55 +0800
Message-Id: <1319262236-6498-36-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   47 ++++++++++++++----------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index bc6af41..e9dd999 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -140,8 +140,8 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 			break;
 		}
 
-		buf =
-		    list_entry(q->active.next, struct cx25821_buffer, vb.queue);
+		buf = list_entry(q->active.next, struct cx25821_buffer,
+				vb.queue);
 
 		/* count comes from the hw and it is 16bit wide --
 		 * this trick handles wrap-arounds correctly for
@@ -318,8 +318,8 @@ int cx25821_restart_video_queue(struct cx25821_dev *dev,
 	struct list_head *item;
 
 	if (!list_empty(&q->active)) {
-		buf =
-		    list_entry(q->active.next, struct cx25821_buffer, vb.queue);
+		buf = list_entry(q->active.next, struct cx25821_buffer,
+				vb.queue);
 
 		cx25821_start_video_dma(dev, q, buf, channel);
 
@@ -337,8 +337,8 @@ int cx25821_restart_video_queue(struct cx25821_dev *dev,
 		if (list_empty(&q->queued))
 			return 0;
 
-		buf =
-		    list_entry(q->queued.next, struct cx25821_buffer, vb.queue);
+		buf = list_entry(q->queued.next, struct cx25821_buffer,
+				vb.queue);
 
 		if (NULL == prev) {
 			list_move_tail(&buf->vb.queue, &q->active);
@@ -375,8 +375,8 @@ void cx25821_vid_timeout(unsigned long data)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	while (!list_empty(&q->active)) {
-		buf =
-		    list_entry(q->active.next, struct cx25821_buffer, vb.queue);
+		buf = list_entry(q->active.next, struct cx25821_buffer,
+				vb.queue);
 		list_del(&buf->vb.queue);
 
 		buf->vb.state = VIDEOBUF_ERROR;
@@ -498,15 +498,14 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		dev->channels[i].timeout_data.dev = dev;
 		dev->channels[i].timeout_data.channel =
 			&cx25821_sram_channels[i];
-		dev->channels[i].vidq.timeout.function =
-			cx25821_vid_timeout;
+		dev->channels[i].vidq.timeout.function = cx25821_vid_timeout;
 		dev->channels[i].vidq.timeout.data =
 			(unsigned long)&dev->channels[i].timeout_data;
 		init_timer(&dev->channels[i].vidq.timeout);
 
 		/* register v4l devices */
-		dev->channels[i].video_dev = cx25821_vdev_init(dev,
-				dev->pci, &cx25821_video_device, "video");
+		dev->channels[i].video_dev = cx25821_vdev_init(dev, dev->pci,
+				&cx25821_video_device, "video");
 
 		err = video_register_device(dev->channels[i].video_dev,
 				VFL_TYPE_GRABBER, video_nr[dev->nr]);
@@ -619,10 +618,9 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 					    dev->tvnorm & V4L2_STD_PAL_DK)
 						bpl_local = 352 << 1;
 					else
-						bpl_local =
-						 dev->channels[channel_opened].
-						 cif_width <<
-						 1;
+						bpl_local = dev->channels[
+							channel_opened].
+							cif_width << 1;
 				}
 			}
 		}
@@ -846,11 +844,10 @@ static int video_open(struct file *file)
 
 	v4l2_prio_open(&dev->channels[ch_id].prio, &fh->prio);
 
-	videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-			      &dev->pci->dev, &dev->slock,
-			      V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			      V4L2_FIELD_INTERLACED,
-			      sizeof(struct cx25821_buffer), fh, NULL);
+	videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops, &dev->pci->dev,
+			&dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			V4L2_FIELD_INTERLACED, sizeof(struct cx25821_buffer),
+			fh, NULL);
 
 	dprintk(1, "post videobuf_queue_init()\n");
 	mutex_unlock(&cx25821_devlist_mutex);
@@ -1166,8 +1163,8 @@ int cx25821_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	cap->version = CX25821_VERSION_CODE;
-	cap->capabilities =
-	    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+		V4L2_CAP_STREAMING;
 	if (UNSET != dev->tuner_type)
 		cap->capabilities |= V4L2_CAP_TUNER;
 	return 0;
@@ -1897,8 +1894,8 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 		}
 
 		if (selected_channel <= 7 && selected_channel >= 0) {
-			dev->channels[selected_channel].
-				use_cif_resolution = cif_enable;
+			dev->channels[selected_channel].use_cif_resolution =
+				cif_enable;
 			dev->channels[selected_channel].cif_width = width;
 		} else {
 			for (i = 0; i < VID_CHANNEL_NUM; i++) {
-- 
1.7.0.4


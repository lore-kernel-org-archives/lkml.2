Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1IPGRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:20 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:54926 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1IPGRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:16 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 11/44] Staging: cx25821: Change indent with spaces to tabs 7
Date: Fri, 16 Sep 2011 14:14:44 +0800
Message-Id: <1316153717-7272-12-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   65 +++++++++++++++----------------
 1 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index d422d45..e424389 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -726,40 +726,37 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
 	struct cx25821_buffer *buf =
 	   container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->channels[fh->channel_id].vidq;
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-	       list_add_tail(&buf->vb.queue, &q->queued);
-	       buf->vb.state = VIDEOBUF_QUEUED;
-	       dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-		       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-	       list_add_tail(&buf->vb.queue, &q->active);
-	       cx25821_start_video_dma(dev, q, buf,
-				       dev->channels[fh->channel_id].
-				       sram_channels);
-	       buf->vb.state = VIDEOBUF_ACTIVE;
-	       buf->count = q->count++;
-	       mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-	       dprintk(2,
-		       "[%p/%d] buffer_queue - first active, buf cnt = %d, \
-		       q->count = %d\n",
-		       buf, buf->vb.i, buf->count, q->count);
-       } else {
-	       prev =
-		   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-	       if (prev->vb.width == buf->vb.width
+	struct cx25821_buffer *prev;
+	struct cx25821_fh *fh = vq->priv_data;
+	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_dmaqueue *q = &dev->channels[fh->channel_id].vidq;
+
+	/* add jump to stopper */
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
+	buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
+	buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
+
+	dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
+
+	if (!list_empty(&q->queued)) {
+		list_add_tail(&buf->vb.queue, &q->queued);
+		buf->vb.state = VIDEOBUF_QUEUED;
+		dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
+				buf->vb.i);
+
+	} else if (list_empty(&q->active)) {
+		list_add_tail(&buf->vb.queue, &q->active);
+		cx25821_start_video_dma(dev, q, buf,
+				dev->channels[fh->channel_id].sram_channels);
+		buf->vb.state = VIDEOBUF_ACTIVE;
+		buf->count = q->count++;
+		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
+		dprintk(2, "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
+				buf, buf->vb.i, buf->count, q->count);
+	} else {
+		prev = list_entry(q->active.prev, struct cx25821_buffer,
+				vb.queue);
+		if (prev->vb.width == buf->vb.width
 		   && prev->vb.height == buf->vb.height
 		   && prev->fmt == buf->fmt) {
 		       list_add_tail(&buf->vb.queue, &q->active);
-- 
1.7.0.4


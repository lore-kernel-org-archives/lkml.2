Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1IPGQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:16:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50274 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1IPGQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:16:52 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 05/44] Staging: cx25821: Change indent with spaces to tabs 1
Date: Fri, 16 Sep 2011 14:14:38 +0800
Message-Id: <1316153717-7272-6-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed indent with spaces to use tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 116727a..a952ca1 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -230,14 +230,14 @@ int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
 
 	/* is it free? */
 	mutex_lock(&dev->lock);
-       if (dev->channels[fh->channel_id].resources & bit) {
+	if (dev->channels[fh->channel_id].resources & bit) {
 		/* no, someone else uses it */
 		mutex_unlock(&dev->lock);
 		return 0;
 	}
 	/* it's free, grab it */
 	fh->resources |= bit;
-       dev->channels[fh->channel_id].resources |= bit;
+	dev->channels[fh->channel_id].resources |= bit;
 	dprintk(1, "res: get %d\n", bit);
 	mutex_unlock(&dev->lock);
 	return 1;
@@ -250,7 +250,7 @@ int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit)
 
 int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit)
 {
-       return fh->dev->channels[fh->channel_id].resources & bit;
+	return fh->dev->channels[fh->channel_id].resources & bit;
 }
 
 void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
@@ -261,7 +261,7 @@ void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
 
 	mutex_lock(&dev->lock);
 	fh->resources &= ~bits;
-       dev->channels[fh->channel_id].resources &= ~bits;
+	dev->channels[fh->channel_id].resources &= ~bits;
 	dprintk(1, "res: put %d\n", bits);
 	mutex_unlock(&dev->lock);
 }
@@ -355,7 +355,7 @@ int cx25821_restart_video_queue(struct cx25821_dev *dev,
 			buf->vb.state = VIDEOBUF_ACTIVE;
 			buf->count = q->count++;
 			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-			prev->risc.jmp[2] = cpu_to_le32(0);	/* Bits 63 - 32 */
+			prev->risc.jmp[2] = cpu_to_le32(0); /* Bits 63 - 32 */
 		} else {
 			return 0;
 		}
@@ -368,11 +368,11 @@ void cx25821_vid_timeout(unsigned long data)
 	struct cx25821_data *timeout_data = (struct cx25821_data *)data;
 	struct cx25821_dev *dev = timeout_data->dev;
 	struct sram_channel *channel = timeout_data->channel;
-       struct cx25821_dmaqueue *q = &dev->channels[channel->i].vidq;
+	struct cx25821_dmaqueue *q = &dev->channels[channel->i].vidq;
 	struct cx25821_buffer *buf;
 	unsigned long flags;
 
-       /* cx25821_sram_channel_dump(dev, channel); */
+	/* cx25821_sram_channel_dump(dev, channel); */
 	cx_clear(channel->dma_ctl, 0x11);
 
 	spin_lock_irqsave(&dev->slock, flags);
@@ -394,7 +394,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	u32 count = 0;
 	int handled = 0;
 	u32 mask;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 
 	mask = cx_read(channel->int_msk);
 	if (0 == (status & mask))
@@ -414,8 +414,8 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	if (status & FLD_VID_DST_RISC1) {
 		spin_lock(&dev->slock);
 		count = cx_read(channel->gpcnt);
-	       cx25821_video_wakeup(dev,
-		       &dev->channels[channel->i].vidq, count);
+		cx25821_video_wakeup(dev, &dev->channels[channel->i].vidq,
+				count);
 		spin_unlock(&dev->slock);
 		handled++;
 	}
-- 
1.7.0.4


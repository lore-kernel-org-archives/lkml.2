Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab0JQWH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 18:07:28 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:45298 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab0JQWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 18:07:27 -0400
Date: Mon, 18 Oct 2010 00:05:31 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/cx25821: fix messages that line wrap within quotes
Message-ID: <20101018000531.6ba2b333@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix messages that line wrap within quotes.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/staging/cx25821/cx25821-core.c           |    4 +-
 drivers/staging/cx25821/cx25821-video-upstream.c |   36 +++++++++++-----------
 drivers/staging/cx25821/cx25821-video.c          |    8 ++--
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 08eb620..44ad9e5 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -1018,8 +1018,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	    (dev->ioctl_dev, VFL_TYPE_GRABBER, VIDEO_IOCTL_CH) < 0) {
 		cx25821_videoioctl_unregister(dev);
 		printk(KERN_ERR
-		   "%s() Failed to register video adapter for IOCTL, so \
-		   unregistering videoioctl device.\n", __func__);
+		   "%s() Failed to register video adapter for IOCTL, so"
+		   " unregistering videoioctl device.\n", __func__);
 	}
 
 	cx25821_dev_checkrevision(dev);
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 756a820..2b82e05 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -389,8 +389,8 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 			if (vfs_read_retval < line_size) {
 				printk(KERN_INFO
-				      "Done: exit %s() since no more bytes to \
-				      read from Video file.\n",
+				      "Done: exit %s() since no more bytes to"
+				      " read from Video file.\n",
 				       __func__);
 				break;
 			}
@@ -457,8 +457,8 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 		if (!myfile->f_op->read) {
 		       printk(KERN_ERR
-			   "%s: File has no READ operations registered!  \
-			   Returning.",
+			   "%s: File has no READ operations registered!"
+			   " Returning.",
 			     __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -488,8 +488,8 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 				if (vfs_read_retval < line_size) {
 					printk(KERN_INFO
-					    "Done: exit %s() since no more \
-					    bytes to read from Video file.\n",
+					    "Done: exit %s() since no more"
+					    " bytes to read from Video file.\n",
 					       __func__);
 					break;
 				}
@@ -535,8 +535,8 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 
 	if (!dev->_dma_virt_addr) {
 		printk
-		   (KERN_ERR "cx25821: FAILED to allocate memory for Risc \
-		   buffer! Returning.\n");
+		   (KERN_ERR "cx25821: FAILED to allocate memory for Risc"
+		   " buffer! Returning.\n");
 		return -ENOMEM;
 	}
 
@@ -557,8 +557,8 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 
 	if (!dev->_data_buf_virt_addr) {
 		printk
-		   (KERN_ERR "cx25821: FAILED to allocate memory for data \
-		   buffer! Returning.\n");
+		   (KERN_ERR "cx25821: FAILED to allocate memory for data"
+		   " buffer! Returning.\n");
 		return -ENOMEM;
 	}
 
@@ -653,16 +653,16 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 	} else {
 		if (status & FLD_VID_SRC_UF)
 			printk
-			   (KERN_ERR "%s: Video Received Underflow Error \
-			   Interrupt!\n", __func__);
+			   (KERN_ERR "%s: Video Received Underflow Error"
+			   " Interrupt!\n", __func__);
 
 		if (status & FLD_VID_SRC_SYNC)
-		       printk(KERN_ERR "%s: Video Received Sync Error \
-		       Interrupt!\n", __func__);
+			printk(KERN_ERR "%s: Video Received Sync Error"
+			" Interrupt!\n", __func__);
 
 		if (status & FLD_VID_SRC_OPC_ERR)
-		       printk(KERN_ERR "%s: Video Received OpCode Error \
-		       Interrupt!\n", __func__);
+			printk(KERN_ERR "%s: Video Received OpCode Error"
+			" Interrupt!\n", __func__);
 	}
 
 	if (dev->_file_status == END_OF_FILE) {
@@ -818,8 +818,8 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 
 	if (!dev->_irq_queues) {
 		printk
-		   (KERN_ERR "cx25821: create_singlethread_workqueue() for \
-		   Video FAILED!\n");
+		   (KERN_ERR "cx25821: create_singlethread_workqueue() for"
+		   " Video FAILED!\n");
 		return -ENOMEM;
 	}
 	/* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index e7f1d57..523a445 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -751,8 +751,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	       buf->count = q->count++;
 	       mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
 	       dprintk(2,
-		       "[%p/%d] buffer_queue - first active, buf cnt = %d, \
-		       q->count = %d\n",
+		       "[%p/%d] buffer_queue - first active, buf cnt = %d,"
+		       " q->count = %d\n",
 		       buf, buf->vb.i, buf->count, q->count);
        } else {
 	       prev =
@@ -768,8 +768,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 		       /* 64 bit bits 63-32 */
 		       prev->risc.jmp[2] = cpu_to_le32(0);
 		       dprintk(2,
-			       "[%p/%d] buffer_queue - append to active, \
-			       buf->count=%d\n",
+			       "[%p/%d] buffer_queue - append to active,"
+			       " buf->count=%d\n",
 			       buf, buf->vb.i, buf->count);
 
 	       } else {
-- 
1.7.2.2

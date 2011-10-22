Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1JVFq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:46:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1JVFqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:46:23 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/36] Staging: cx25821: cx25821-audio-upstream.c: Fix indent
Date: Sat, 22 Oct 2011 13:43:25 +0800
Message-Id: <1319262236-6498-6-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change wrong indent (with spaces and less than 7 columns) of statements
to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   42 +++++++++++-----------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 50e56a6..d7d3a2f 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -107,7 +107,7 @@ static __le32 *cx25821_risc_field_upstream_audio(struct cx25821_dev *dev,
 {
 	unsigned int line;
 	struct sram_channel *sram_ch =
-	   dev->channels[dev->_audio_upstream_channel].sram_channels;
+		dev->channels[dev->_audio_upstream_channel].sram_channels;
 	int offset = 0;
 
 	/* scan lines */
@@ -193,7 +193,7 @@ int cx25821_risc_buffer_upstream_audio(struct cx25821_dev *dev,
 
 		/* Recalculate virtual address based on frame index */
 		rp = dev->_risc_virt_addr + RISC_SYNC_INSTRUCTION_SIZE / 4 +
-		    (AUDIO_RISC_DMA_BUF_SIZE * (frame + 1) / 4);
+			(AUDIO_RISC_DMA_BUF_SIZE * (frame + 1) / 4);
 	}
 
 	return 0;
@@ -218,7 +218,7 @@ void cx25821_free_memory_audio(struct cx25821_dev *dev)
 void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 {
 	struct sram_channel *sram_ch =
-	   dev->channels[AUDIO_UPSTREAM_SRAM_CHANNEL_B].sram_channels;
+		dev->channels[AUDIO_UPSTREAM_SRAM_CHANNEL_B].sram_channels;
 	u32 tmp = 0;
 
 	if (!dev->_audio_is_running) {
@@ -286,14 +286,14 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 	} else {
 		if (!(myfile->f_op)) {
 			pr_err("%s(): File has no file operations registered!\n",
-			       __func__);
+				__func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
 			pr_err("%s(): File has no READ operations registered!\n",
-			       __func__);
+				__func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
@@ -312,7 +312,7 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 			    && dev->_audiodata_buf_virt_addr != NULL) {
 				memcpy((void *)(dev->_audiodata_buf_virt_addr +
 						frame_offset / 4), mybuf,
-				       vfs_read_retval);
+					vfs_read_retval);
 			}
 
 			file_offset += vfs_read_retval;
@@ -345,7 +345,7 @@ static void cx25821_audioups_handler(struct work_struct *work)
 
 	if (!dev) {
 		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
-		       __func__);
+			__func__);
 		return;
 	}
 
@@ -370,19 +370,19 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
 		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
-		       __func__, dev->_audiofilename, open_errno);
+			__func__, dev->_audiofilename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
 			pr_err("%s(): File has no file operations registered!\n",
-			       __func__);
+				__func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
 			pr_err("%s(): File has no READ operations registered!\n",
-			       __func__);
+				__func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
@@ -454,7 +454,7 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 
 	if (!dev->_risc_virt_addr) {
 		printk(KERN_DEBUG
-		       pr_fmt("ERROR: pci_alloc_consistent() FAILED to allocate memory for RISC program! Returning\n"));
+			pr_fmt("ERROR: pci_alloc_consistent() FAILED to allocate memory for RISC program! Returning\n"));
 		return -ENOMEM;
 	}
 	/* Clear out memory at address */
@@ -469,7 +469,7 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 
 	if (!dev->_audiodata_buf_virt_addr) {
 		printk(KERN_DEBUG
-		       pr_fmt("ERROR: pci_alloc_consistent() FAILED to allocate memory for data buffer! Returning\n"));
+			pr_fmt("ERROR: pci_alloc_consistent() FAILED to allocate memory for data buffer! Returning\n"));
 		return -ENOMEM;
 	}
 	/* Clear out memory at address */
@@ -485,7 +485,7 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 					       dev->_audio_lines_count);
 	if (ret < 0) {
 		printk(KERN_DEBUG
-		       pr_fmt("ERROR creating audio upstream RISC programs!\n"));
+			pr_fmt("ERROR creating audio upstream RISC programs!\n"));
 		goto error;
 	}
 
@@ -533,9 +533,9 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 
 			if (dev->_risc_virt_start_addr != NULL) {
 				risc_phys_jump_addr =
-				    dev->_risc_phys_start_addr +
-				    RISC_SYNC_INSTRUCTION_SIZE +
-				    AUDIO_RISC_DMA_BUF_SIZE;
+					dev->_risc_phys_start_addr +
+					RISC_SYNC_INSTRUCTION_SIZE +
+					AUDIO_RISC_DMA_BUF_SIZE;
 
 				rp = cx25821_risc_field_upstream_audio(dev,
 						dev->_risc_virt_start_addr + 1,
@@ -632,7 +632,7 @@ static void cx25821_wait_fifo_enable(struct cx25821_dev *dev,
 		/* 10 millisecond timeout */
 		if (count++ > 1000) {
 			pr_err("ERROR: %s() fifo is NOT turned on. Timeout!\n",
-			       __func__);
+				__func__);
 			return;
 		}
 
@@ -726,7 +726,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 
 	if (!dev->_irq_audio_queues) {
 		printk(KERN_DEBUG
-		       pr_fmt("ERROR: create_singlethread_workqueue() for Audio FAILED!\n"));
+			pr_fmt("ERROR: create_singlethread_workqueue() for Audio FAILED!\n"));
 		return -ENOMEM;
 	}
 
@@ -764,8 +764,8 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 							_line_size, 0);
 
 	dev->audio_upstream_riscbuf_size =
-	    AUDIO_RISC_DMA_BUF_SIZE * NUM_AUDIO_PROGS +
-	    RISC_SYNC_INSTRUCTION_SIZE;
+		AUDIO_RISC_DMA_BUF_SIZE * NUM_AUDIO_PROGS +
+		RISC_SYNC_INSTRUCTION_SIZE;
 	dev->audio_upstream_databuf_size = AUDIO_DATA_BUF_SZ * NUM_AUDIO_PROGS;
 
 	/* Allocating buffers and prepare RISC program */
@@ -773,7 +773,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 							_line_size);
 	if (retval < 0) {
 		pr_err("%s: Failed to set up Audio upstream buffers!\n",
-		       dev->name);
+			dev->name);
 		goto error;
 	}
 	/* Start RISC engine */
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0CZWPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:15:50 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:54107 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752560Ab0CZWPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:15:49 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: [PATCH 6/6] Staging: cx25821: fix coding style issues in
 cx25821-video-upstream.c
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, palash.bandyopadhyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sat, 27 Mar 2010 00:15:36 +0200
Message-ID: <1269641736.7005.2.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 69fbde2030f2a35c5289467a40f9828bf22fdc35 Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sat, 27 Mar 2010 00:05:31 +0200
Subject: [PATCH 6/6] Staging: cx25821: fix coding style issues in cx25821-video-upstream.c
 This is a patch to cx25821-video-upstream.c file that fixes up warnings and errors found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/cx25821/cx25821-video-upstream.c |  121 +++++++++++----------
 1 files changed, 63 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 3d7dd3f..ce7d051 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -31,7 +31,7 @@
 #include <linux/syscalls.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
@@ -59,9 +59,8 @@ int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 	cdt = ch->cdt;
 	lines = ch->fifo_size / bpl;
 
-	if (lines > 4) {
+	if (lines > 4)
 		lines = 4;
-	}
 
 	BUG_ON(lines < 2);
 
@@ -96,7 +95,7 @@ int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 }
 
 static __le32 *cx25821_update_riscprogram(struct cx25821_dev *dev,
-					  __le32 * rp, unsigned int offset,
+					  __le32 *rp, unsigned int offset,
 					  unsigned int bpl, u32 sync_line,
 					  unsigned int lines, int fifo_enable,
 					  int field_type)
@@ -107,9 +106,8 @@ static __le32 *cx25821_update_riscprogram(struct cx25821_dev *dev,
 	*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
 
 	if (USE_RISC_NOOP_VIDEO) {
-		for (i = 0; i < NUM_NO_OPS; i++) {
+		for (i = 0; i < NUM_NO_OPS; i++)
 			*(rp++) = cpu_to_le32(RISC_NOOP);
-		}
 	}
 
 	/* scan lines */
@@ -139,14 +137,12 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 	int dist_betwn_starts = bpl * 2;
 
 	/* sync instruction */
-	if (sync_line != NO_SYNC_LINE) {
+	if (sync_line != NO_SYNC_LINE)
 		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
-	}
 
 	if (USE_RISC_NOOP_VIDEO) {
-		for (i = 0; i < NUM_NO_OPS; i++) {
+		for (i = 0; i < NUM_NO_OPS; i++)
 			*(rp++) = cpu_to_le32(RISC_NOOP);
-		}
 	}
 
 	/* scan lines */
@@ -156,12 +152,13 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 
 		if ((lines <= NTSC_FIELD_HEIGHT)
-		    || (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC)) {
-			offset += dist_betwn_starts;	//to skip the other field line
-		}
+		    || (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC))
+			/* to skip the other field line */
+			offset += dist_betwn_starts;
 
-		// check if we need to enable the FIFO after the first 4 lines
-		// For the upstream video channel, the risc engine will enable the FIFO.
+		/* check if we need to enable the FIFO after the first 4 lines
+		 * For the upstream video channel, the risc engine will enable
+		 * the FIFO. */
 		if (fifo_enable && line == 3) {
 			*(rp++) = RISC_WRITECR;
 			*(rp++) = sram_ch->dma_ctl;
@@ -180,7 +177,8 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 {
 	__le32 *rp;
 	int fifo_enable = 0;
-	int singlefield_lines = lines >> 1;	//get line count for single field
+	/* get line count for single field */
+	int singlefield_lines = lines >> 1;
 	int odd_num_lines = singlefield_lines;
 	int frame = 0;
 	int frame_size = 0;
@@ -224,7 +222,7 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 
 		fifo_enable = FIFO_DISABLE;
 
-		//Even Field
+		/* Even Field */
 		rp = cx25821_risc_field_upstream(dev, rp,
 						 dev->_data_buf_phys_addr +
 						 databuf_offset, bottom_offset,
@@ -240,7 +238,9 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 			risc_flag = RISC_CNT_INC;
 		}
 
-		// Loop to 2ndFrameRISC or to Start of Risc program & generate IRQ
+		/* Loop to 2ndFrameRISC or to Start of Risc
+		 * program & generate IRQ
+		 */
 		*(rp++) = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | risc_flag);
 		*(rp++) = cpu_to_le32(risc_phys_jump_addr);
 		*(rp++) = cpu_to_le32(0);
@@ -257,18 +257,18 @@ void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 
 	if (!dev->_is_running) {
 		printk
-		    ("cx25821: No video file is currently running so return!\n");
+		   ("cx25821: No video file is currently running so return!\n");
 		return;
 	}
-	//Disable RISC interrupts
+	/* Disable RISC interrupts */
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp & ~_intr_msk);
 
-	//Turn OFF risc and fifo enable
+	/* Turn OFF risc and fifo enable */
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_write(sram_ch->dma_ctl, tmp & ~(FLD_VID_FIFO_EN | FLD_VID_RISC_EN));
 
-	//Clear data buffer memory
+	/* Clear data buffer memory */
 	if (dev->_data_buf_virt_addr)
 		memset(dev->_data_buf_virt_addr, 0, dev->_data_buf_size);
 
@@ -291,9 +291,8 @@ void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 
 void cx25821_free_mem_upstream_ch1(struct cx25821_dev *dev)
 {
-	if (dev->_is_running) {
+	if (dev->_is_running)
 		cx25821_stop_upstream_video_ch1(dev);
-	}
 
 	if (dev->_dma_virt_addr) {
 		pci_free_consistent(dev->pci, dev->_risc_size,
@@ -346,7 +345,7 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d! \n",
+		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
@@ -411,7 +410,7 @@ static void cx25821_vidups_handler(struct work_struct *work)
 	    container_of(work, struct cx25821_dev, _irq_work_entry);
 
 	if (!dev) {
-		printk("ERROR %s(): since container_of(work_struct) FAILED! \n",
+		printk("ERROR %s(): since container_of(work_struct) FAILED!\n",
 		       __func__);
 		return;
 	}
@@ -437,7 +436,7 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d! \n",
+		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
@@ -489,9 +488,8 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 			if (i > 0)
 				dev->_frame_count++;
 
-			if (vfs_read_retval < line_size) {
+			if (vfs_read_retval < line_size)
 				break;
-			}
 		}
 
 		dev->_file_status =
@@ -531,7 +529,7 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 		return -ENOMEM;
 	}
 
-	//Clear memory at address
+	/* Clear memory at address */
 	memset(dev->_dma_virt_addr, 0, dev->_risc_size);
 
 	if (dev->_data_buf_virt_addr != NULL) {
@@ -539,7 +537,7 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 				    dev->_data_buf_virt_addr,
 				    dev->_data_buf_phys_addr);
 	}
-	//For Video Data buffer allocation
+	/* For Video Data buffer allocation */
 	dev->_data_buf_virt_addr =
 	    pci_alloc_consistent(dev->pci, dev->upstream_databuf_size,
 				 &data_dma_addr);
@@ -552,26 +550,26 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 		return -ENOMEM;
 	}
 
-	//Clear memory at address
+	/* Clear memory at address */
 	memset(dev->_data_buf_virt_addr, 0, dev->_data_buf_size);
 
 	ret = cx25821_openfile(dev, sram_ch);
 	if (ret < 0)
 		return ret;
 
-	//Create RISC programs
+	/* Create RISC programs */
 	ret =
 	    cx25821_risc_buffer_upstream(dev, dev->pci, 0, bpl,
 					 dev->_lines_count);
 	if (ret < 0) {
 		printk(KERN_INFO
-		       "cx25821: Failed creating Video Upstream Risc programs! \n");
+		    "cx25821: Failed creating Video Upstream Risc programs!\n");
 		goto error;
 	}
 
 	return 0;
 
-      error:
+error:
 	return ret;
 }
 
@@ -587,10 +585,11 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 	__le32 *rp;
 
 	if (status & FLD_VID_SRC_RISC1) {
-		// We should only process one program per call
+		/* We should only process one program per call */
 		u32 prog_cnt = cx_read(channel->gpcnt);
 
-		//Since we've identified our IRQ, clear our bits from the interrupt mask and interrupt status registers
+		/* Since we've identified our IRQ, clear our bits from the
+		 * interrupt mask and interrupt status registers */
 		int_msk_tmp = cx_read(channel->int_msk);
 		cx_write(channel->int_msk, int_msk_tmp & ~_intr_msk);
 		cx_write(channel->int_stat, _intr_msk);
@@ -631,7 +630,7 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 								FIFO_DISABLE,
 								ODD_FIELD);
 
-				// Jump to Even Risc program of 1st Frame
+				/* Jump to Even Risc program of 1st Frame */
 				*(rp++) = cpu_to_le32(RISC_JUMP);
 				*(rp++) = cpu_to_le32(risc_phys_jump_addr);
 				*(rp++) = cpu_to_le32(0);
@@ -659,7 +658,7 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 		       dev->_frame_count);
 		return -1;
 	}
-	//ElSE, set the interrupt mask register, re-enable irq.
+	/* ElSE, set the interrupt mask register, re-enable irq. */
 	int_msk_tmp = cx_read(channel->int_msk);
 	cx_write(channel->int_msk, int_msk_tmp |= _intr_msk);
 
@@ -684,17 +683,16 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 	msk_stat = cx_read(sram_ch->int_mstat);
 	vid_status = cx_read(sram_ch->int_stat);
 
-	// Only deal with our interrupt
+	/* Only deal with our interrupt */
 	if (vid_status) {
 		handled =
 		    cx25821_video_upstream_irq(dev, channel_num, vid_status);
 	}
 
-	if (handled < 0) {
+	if (handled < 0)
 		cx25821_stop_upstream_video_ch1(dev);
-	} else {
+	else
 		handled += handled;
-	}
 
 	return IRQ_RETVAL(handled);
 }
@@ -713,19 +711,19 @@ void cx25821_set_pixelengine(struct cx25821_dev *dev, struct sram_channel *ch,
 	value |= dev->_isNTSC ? 0 : 0x10;
 	cx_write(ch->vid_fmt_ctl, value);
 
-	// set number of active pixels in each line. Default is 720 pixels in both NTSC and PAL format
+	/* set number of active pixels in each line.
+	 * Default is 720 pixels in both NTSC and PAL format */
 	cx_write(ch->vid_active_ctl1, width);
 
 	num_lines = (height / 2) & 0x3FF;
 	odd_num_lines = num_lines;
 
-	if (dev->_isNTSC) {
+	if (dev->_isNTSC)
 		odd_num_lines += 1;
-	}
 
 	value = (num_lines << 16) | odd_num_lines;
 
-	// set number of active lines in field 0 (top) and field 1 (bottom)
+	/* set number of active lines in field 0 (top) and field 1 (bottom) */
 	cx_write(ch->vid_active_ctl2, value);
 
 	cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
@@ -737,21 +735,26 @@ int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 	u32 tmp = 0;
 	int err = 0;
 
-	// 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for channel A-C
+	/* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for
+	 * channel A-C
+	 */
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);
 
-	// Set the physical start address of the RISC program in the initial program counter(IPC) member of the cmds.
+	/* Set the physical start address of the RISC program in the initial
+	 * program counter(IPC) member of the cmds.
+	 */
 	cx_write(sram_ch->cmds_start + 0, dev->_dma_phys_addr);
-	cx_write(sram_ch->cmds_start + 4, 0);	/* Risc IPC High 64 bits 63-32 */
+	/* Risc IPC High 64 bits 63-32 */
+	cx_write(sram_ch->cmds_start + 4, 0);
 
 	/* reset counter */
 	cx_write(sram_ch->gpcnt_ctl, 3);
 
-	// Clear our bits from the interrupt status register.
+	/* Clear our bits from the interrupt status register. */
 	cx_write(sram_ch->int_stat, _intr_msk);
 
-	//Set the interrupt mask register, enable irq.
+	/* Set the interrupt mask register, enable irq. */
 	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | (1 << sram_ch->irq_bit));
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
@@ -765,7 +768,7 @@ int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 		goto fail_irq;
 	}
 
-	// Start the DMA  engine
+	/* Start the DMA  engine */
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_set(sram_ch->dma_ctl, tmp | FLD_VID_RISC_EN);
 
@@ -774,7 +777,7 @@ int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 
 	return 0;
 
-      fail_irq:
+fail_irq:
 	cx25821_dev_unregister(dev);
 	return err;
 }
@@ -806,7 +809,9 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 		    ("cx25821: create_singlethread_workqueue() for Video FAILED!\n");
 		return -ENOMEM;
 	}
-	// 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for channel A-C
+	/* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for
+	 * channel A-C
+	 */
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);
 
@@ -840,7 +845,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 		memcpy(dev->_filename, dev->_defaultname, str_length + 1);
 	}
 
-	//Default if filename is empty string
+	/* Default if filename is empty string */
 	if (strcmp(dev->input_filename, "") == 0) {
 		if (dev->_isNTSC) {
 			dev->_filename =
@@ -874,7 +879,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	dev->upstream_riscbuf_size = risc_buffer_size * 2;
 	dev->upstream_databuf_size = data_frame_size * 2;
 
-	//Allocating buffers and prepare RISC program
+	/* Allocating buffers and prepare RISC program */
 	retval = cx25821_upstream_buffer_prepare(dev, sram_ch, dev->_line_size);
 	if (retval < 0) {
 		printk(KERN_ERR
@@ -887,7 +892,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 
 	return 0;
 
-      error:
+error:
 	cx25821_dev_unregister(dev);
 
 	return err;
-- 
1.7.0




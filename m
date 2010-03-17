Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0CQGLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:11:25 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:34494 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753216Ab0CQGLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:11:24 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: 0001-Staging-cx25821-cx25821-audio-upstream.c-Fixed-some-.patch
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, palash.bandyopadhyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 17 Mar 2010 08:11:03 +0200
Message-ID: <1268806263.6501.2.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c254873ba8ef1e91ce678417ba1c15b5320e234d Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Wed, 17 Mar 2010 07:59:29 +0200
Subject: [PATCH] Staging: cx25821: cx25821-audio-upstream.c: Fixed some checkpatch.pl warnings/errors

This patch fixes up some warnings&errors found by the checkpatch.pl script

Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |  146 +++++++++++-----------
 1 files changed, 74 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index ddddf65..81b22d2 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -32,7 +32,7 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/delay.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
@@ -61,9 +61,8 @@ int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
 	cdt = ch->cdt;
 	lines = ch->fifo_size / bpl;
 
-	if (lines > 3) {
+	if (lines > 3)
 		lines = 3;
-	}
 
 	BUG_ON(lines < 2);
 
@@ -83,7 +82,7 @@ int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
 	cx_write(ch->cmds_start + 12, AUDIO_CDT_SIZE_QW);
 	cx_write(ch->cmds_start + 16, ch->ctrl_start);
 
-	//IQ size
+	/* IQ size */
 	cx_write(ch->cmds_start + 20, AUDIO_IQ_SIZE_DW);
 
 	for (i = 24; i < 80; i += 4)
@@ -99,7 +98,7 @@ int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
 }
 
 static __le32 *cx25821_risc_field_upstream_audio(struct cx25821_dev *dev,
-						 __le32 * rp,
+						 __le32 *rp,
 						 dma_addr_t databuf_phys_addr,
 						 unsigned int bpl,
 						 int fifo_enable)
@@ -115,8 +114,10 @@ static __le32 *cx25821_risc_field_upstream_audio(struct cx25821_dev *dev,
 		*(rp++) = cpu_to_le32(databuf_phys_addr + offset);
 		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 
-		// Check if we need to enable the FIFO after the first 3 lines
-		// For the upstream audio channel, the risc engine will enable the FIFO.
+		/* Check if we need to enable the FIFO
+		 * after the first 3 lines.
+		 * For the upstream audio channel,
+		 * the risc engine will enable the FIFO */
 		if (fifo_enable && line == 2) {
 			*(rp++) = RISC_WRITECR;
 			*(rp++) = sram_ch->dma_ctl;
@@ -159,7 +160,7 @@ int cx25821_risc_buffer_upstream_audio(struct cx25821_dev *dev,
 			risc_flag = RISC_CNT_INC;
 		}
 
-		//Calculate physical jump address
+		/* Calculate physical jump address */
 		if ((frame + 1) == NUM_AUDIO_FRAMES) {
 			risc_phys_jump_addr =
 			    dev->_risc_phys_start_addr +
@@ -178,17 +179,17 @@ int cx25821_risc_buffer_upstream_audio(struct cx25821_dev *dev,
 						       fifo_enable);
 
 		if (USE_RISC_NOOP_AUDIO) {
-			for (i = 0; i < NUM_NO_OPS; i++) {
+			for (i = 0; i < NUM_NO_OPS; i++)
 				*(rp++) = cpu_to_le32(RISC_NOOP);
-			}
 		}
 
-		// Loop to (Nth)FrameRISC or to Start of Risc program & generate IRQ
+		/* Loop to (Nth)FrameRISC or to Start of Risc program &
+		 * generate IRQ */
 		*(rp++) = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | risc_flag);
 		*(rp++) = cpu_to_le32(risc_phys_jump_addr);
 		*(rp++) = cpu_to_le32(0);
 
-		//Recalculate virtual address based on frame index
+		/* Recalculate virtual address based on frame index */
 		rp = dev->_risc_virt_addr + RISC_SYNC_INSTRUCTION_SIZE / 4 +
 		    (AUDIO_RISC_DMA_BUF_SIZE * (frame + 1) / 4);
 	}
@@ -219,19 +220,19 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 	u32 tmp = 0;
 
 	if (!dev->_audio_is_running) {
-		printk
-		    ("cx25821: No audio file is currently running so return!\n");
+		printk(KERN_DEBUG
+		    "cx25821: No audio file is currently running so return!\n");
 		return;
 	}
-	//Disable RISC interrupts
+	/* Disable RISC interrupts */
 	cx_write(sram_ch->int_msk, 0);
 
-	//Turn OFF risc and fifo enable in AUD_DMA_CNTRL
+	/* Turn OFF risc and fifo enable in AUD_DMA_CNTRL */
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_write(sram_ch->dma_ctl,
 		 tmp & ~(sram_ch->fld_aud_fifo_en | sram_ch->fld_aud_risc_en));
 
-	//Clear data buffer memory
+	/* Clear data buffer memory */
 	if (dev->_audiodata_buf_virt_addr)
 		memset(dev->_audiodata_buf_virt_addr, 0,
 		       dev->_audiodata_buf_size);
@@ -252,9 +253,8 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 
 void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev)
 {
-	if (dev->_audio_is_running) {
+	if (dev->_audio_is_running)
 		cx25821_stop_upstream_audio(dev);
-	}
 
 	cx25821_free_memory_audio(dev);
 }
@@ -281,7 +281,7 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d! \n",
+		printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_audiofilename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
@@ -293,7 +293,7 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 		}
 
 		if (!myfile->f_op->read) {
-			printk("%s: File has no READ operations registered! \n",
+			printk("%s: File has no READ operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -346,7 +346,7 @@ static void cx25821_audioups_handler(struct work_struct *work)
 	    container_of(work, struct cx25821_dev, _audio_work_entry);
 
 	if (!dev) {
-		printk("ERROR %s(): since container_of(work_struct) FAILED! \n",
+		printk(KERN_ERR "ERROR %s(): since container_of(work_struct) FAILED!\n",
 		       __func__);
 		return;
 	}
@@ -372,19 +372,19 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d! \n",
+		printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_audiofilename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk("%s: File has no file operations registered! \n",
+			printk("%s: File has no file operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk("%s: File has no READ operations registered! \n",
+			printk("%s: File has no READ operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -420,13 +420,11 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 				}
 			}
 
-			if (i > 0) {
+			if (i > 0)
 				dev->_audioframe_count++;
-			}
 
-			if (vfs_read_retval < line_size) {
+			if (vfs_read_retval < line_size)
 				break;
-			}
 		}
 
 		dev->_audiofile_status =
@@ -459,14 +457,14 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 	dev->_audiorisc_size = dev->audio_upstream_riscbuf_size;
 
 	if (!dev->_risc_virt_addr) {
-		printk
-		    ("cx25821 ERROR: pci_alloc_consistent() FAILED to allocate memory for RISC program! Returning.\n");
+		printk(KERN_DEBUG
+			"cx25821 ERROR: pci_alloc_consistent() FAILED to allocate memory for RISC program! Returning.\n");
 		return -ENOMEM;
 	}
-	//Clear out memory at address
+	/* Clear out memory at address */
 	memset(dev->_risc_virt_addr, 0, dev->_audiorisc_size);
 
-	//For Audio Data buffer allocation
+	/* For Audio Data buffer allocation */
 	dev->_audiodata_buf_virt_addr =
 	    pci_alloc_consistent(dev->pci, dev->audio_upstream_databuf_size,
 				 &data_dma_addr);
@@ -474,30 +472,30 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 	dev->_audiodata_buf_size = dev->audio_upstream_databuf_size;
 
 	if (!dev->_audiodata_buf_virt_addr) {
-		printk
-		    ("cx25821 ERROR: pci_alloc_consistent() FAILED to allocate memory for data buffer! Returning. \n");
+		printk(KERN_DEBUG
+			"cx25821 ERROR: pci_alloc_consistent() FAILED to allocate memory for data buffer! Returning.\n");
 		return -ENOMEM;
 	}
-	//Clear out memory at address
+	/* Clear out memory at address */
 	memset(dev->_audiodata_buf_virt_addr, 0, dev->_audiodata_buf_size);
 
 	ret = cx25821_openfile_audio(dev, sram_ch);
 	if (ret < 0)
 		return ret;
 
-	//Creating RISC programs
+	/* Creating RISC programs */
 	ret =
 	    cx25821_risc_buffer_upstream_audio(dev, dev->pci, bpl,
 					       dev->_audio_lines_count);
 	if (ret < 0) {
 		printk(KERN_DEBUG
-		       "cx25821 ERROR creating audio upstream RISC programs! \n");
+		      "cx25821 ERROR creating audio upstream RISC programs!\n");
 		goto error;
 	}
 
 	return 0;
 
-      error:
+error:
 	return ret;
 }
 
@@ -511,22 +509,22 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 	__le32 *rp;
 
 	if (status & FLD_AUD_SRC_RISCI1) {
-		//Get interrupt_index of the program that interrupted
+		/* Get interrupt_index of the program that interrupted */
 		u32 prog_cnt = cx_read(channel->gpcnt);
 
-		//Since we've identified our IRQ, clear our bits from the interrupt mask and interrupt status registers
+		/* Since we've identified our IRQ, clear our bits from the
+		 * interrupt mask and interrupt status registers */
 		cx_write(channel->int_msk, 0);
 		cx_write(channel->int_stat, cx_read(channel->int_stat));
 
 		spin_lock(&dev->slock);
 
 		while (prog_cnt != dev->_last_index_irq) {
-			//Update _last_index_irq
-			if (dev->_last_index_irq < (NUMBER_OF_PROGRAMS - 1)) {
+			/* Update _last_index_irq */
+			if (dev->_last_index_irq < (NUMBER_OF_PROGRAMS - 1))
 				dev->_last_index_irq++;
-			} else {
+			else
 				dev->_last_index_irq = 0;
-			}
 
 			dev->_audioframe_index = dev->_last_index_irq;
 
@@ -558,7 +556,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 						    cpu_to_le32(RISC_NOOP);
 					}
 				}
-				// Jump to 2nd Audio Frame
+				/* Jump to 2nd Audio Frame */
 				*(rp++) =
 				    cpu_to_le32(RISC_JUMP | RISC_IRQ1 |
 						RISC_CNT_RESET);
@@ -581,7 +579,8 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 			printk("%s: Audio Received OpCode Error Interrupt!\n",
 			       __func__);
 
-		// Read and write back the interrupt status register to clear our bits
+		/* Read and write back the interrupt status register to clear
+		 * our bits */
 		cx_write(channel->int_stat, cx_read(channel->int_stat));
 	}
 
@@ -590,7 +589,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 		       dev->_audioframe_count);
 		return -1;
 	}
-	//ElSE, set the interrupt mask register, re-enable irq.
+	/* ElSE, set the interrupt mask register, re-enable irq. */
 	int_msk_tmp = cx_read(channel->int_msk);
 	cx_write(channel->int_msk, int_msk_tmp |= _intr_msk);
 
@@ -612,7 +611,7 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 	msk_stat = cx_read(sram_ch->int_mstat);
 	audio_status = cx_read(sram_ch->int_stat);
 
-	// Only deal with our interrupt
+	/* Only deal with our interrupt */
 	if (audio_status) {
 		handled =
 		    cx25821_audio_upstream_irq(dev,
@@ -621,11 +620,10 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 					       audio_status);
 	}
 
-	if (handled < 0) {
+	if (handled < 0)
 		cx25821_stop_upstream_audio(dev);
-	} else {
+	else
 		handled += handled;
-	}
 
 	return IRQ_RETVAL(handled);
 }
@@ -637,13 +635,14 @@ static void cx25821_wait_fifo_enable(struct cx25821_dev *dev,
 	u32 tmp;
 
 	do {
-		//Wait 10 microsecond before checking to see if the FIFO is turned ON.
+		/* Wait 10 microsecond before checking to see if the FIFO is
+		 * turned ON. */
 		udelay(10);
 
 		tmp = cx_read(sram_ch->dma_ctl);
 
-		if (count++ > 1000)	//10 millisecond timeout
-		{
+		/* 10 millisecond timeout */
+		if (count++ > 1000) {
 			printk
 			    ("cx25821 ERROR: %s() fifo is NOT turned on. Timeout!\n",
 			     __func__);
@@ -660,31 +659,34 @@ int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
 	u32 tmp = 0;
 	int err = 0;
 
-	// Set the physical start address of the RISC program in the initial program counter(IPC) member of the CMDS.
+	/* Set the physical start address of the RISC program in the initial
+	 * program counter(IPC) member of the CMDS. */
 	cx_write(sram_ch->cmds_start + 0, dev->_risc_phys_addr);
-	cx_write(sram_ch->cmds_start + 4, 0);	/* Risc IPC High 64 bits 63-32 */
+	/* Risc IPC High 64 bits 63-32 */
+	cx_write(sram_ch->cmds_start + 4, 0);
 
 	/* reset counter */
 	cx_write(sram_ch->gpcnt_ctl, 3);
 
-	//Set the line length       (It looks like we do not need to set the line length)
+	/* Set the line length       (It looks like we do not need to set the
+	 * line length) */
 	cx_write(sram_ch->aud_length, AUDIO_LINE_SIZE & FLD_AUD_DST_LN_LNGTH);
 
-	//Set the input mode to 16-bit
+	/* Set the input mode to 16-bit */
 	tmp = cx_read(sram_ch->aud_cfg);
 	tmp |=
 	    FLD_AUD_SRC_ENABLE | FLD_AUD_DST_PK_MODE | FLD_AUD_CLK_ENABLE |
 	    FLD_AUD_MASTER_MODE | FLD_AUD_CLK_SELECT_PLL_D | FLD_AUD_SONY_MODE;
 	cx_write(sram_ch->aud_cfg, tmp);
 
-	// Read and write back the interrupt status register to clear it
+	/* Read and write back the interrupt status register to clear it */
 	tmp = cx_read(sram_ch->int_stat);
 	cx_write(sram_ch->int_stat, tmp);
 
-	// Clear our bits from the interrupt status register.
+	/* Clear our bits from the interrupt status register. */
 	cx_write(sram_ch->int_stat, _intr_msk);
 
-	//Set the interrupt mask register, enable irq.
+	/* Set the interrupt mask register, enable irq. */
 	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | (1 << sram_ch->irq_bit));
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
@@ -698,19 +700,19 @@ int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
 		goto fail_irq;
 	}
 
-	// Start the DMA  engine
+	/* Start the DMA  engine */
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_set(sram_ch->dma_ctl, tmp | sram_ch->fld_aud_risc_en);
 
 	dev->_audio_is_running = 1;
 	dev->_is_first_audio_frame = 1;
 
-	// The fifo_en bit turns on by the first Risc program
+	/* The fifo_en bit turns on by the first Risc program */
 	cx25821_wait_fifo_enable(dev, sram_ch);
 
 	return 0;
 
-      fail_irq:
+fail_irq:
 	cx25821_dev_unregister(dev);
 	return err;
 }
@@ -730,14 +732,14 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	dev->_audio_upstream_channel_select = channel_select;
 	sram_ch = &dev->sram_channels[channel_select];
 
-	//Work queue
+	/* Work queue */
 	INIT_WORK(&dev->_audio_work_entry, cx25821_audioups_handler);
 	dev->_irq_audio_queues =
 	    create_singlethread_workqueue("cx25821_audioworkqueue");
 
 	if (!dev->_irq_audio_queues) {
-		printk
-		    ("cx25821 ERROR: create_singlethread_workqueue() for Audio FAILED!\n");
+		printk(KERN_DEBUG
+			"cx25821 ERROR: create_singlethread_workqueue() for Audio FAILED!\n");
 		return -ENOMEM;
 	}
 
@@ -759,7 +761,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		memcpy(dev->_audiofilename, dev->input_audiofilename,
 		       str_length + 1);
 
-		//Default if filename is empty string
+		/* Default if filename is empty string */
 		if (strcmp(dev->input_audiofilename, "") == 0) {
 			dev->_audiofilename = "/root/audioGOOD.wav";
 		}
@@ -783,7 +785,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	    RISC_SYNC_INSTRUCTION_SIZE;
 	dev->audio_upstream_databuf_size = AUDIO_DATA_BUF_SZ * NUM_AUDIO_PROGS;
 
-	//Allocating buffers and prepare RISC program
+	/* Allocating buffers and prepare RISC program */
 	retval =
 	    cx25821_audio_upstream_buffer_prepare(dev, sram_ch, _line_size);
 	if (retval < 0) {
@@ -792,12 +794,12 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		       dev->name);
 		goto error;
 	}
-	//Start RISC engine
+	/* Start RISC engine */
 	cx25821_start_audio_dma_upstream(dev, sram_ch);
 
 	return 0;
 
-      error:
+error:
 	cx25821_dev_unregister(dev);
 
 	return err;
-- 
1.7.0




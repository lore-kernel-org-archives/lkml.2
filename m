Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1HNLnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 07:43:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42948 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1HNLnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 07:43:11 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 2/3] Staging: cx25821: fix style issues in cx25821-video-upstream-ch2
Date: Sun, 14 Aug 2011 19:42:23 +0800
Message-Id: <1313322144-9309-3-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313322144-9309-1-git-send-email-leonidsbox@gmail.com>
References: <1313322144-9309-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in files cx25821-video-upstream-ch2.{c,h}
Change obscure line endings to less obscure ones.
Delete whitespace characters before labels.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   75 ++++++++------------
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |   70 ++++++++++++------
 2 files changed, 76 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 655357d..b578e46 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -40,8 +40,8 @@ MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
-static int _intr_msk =
-	FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
+static int _intr_msk = FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC |
+			FLD_VID_SRC_OPC_ERR;
 
 static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
 					      __le32 *rp, unsigned int offset,
@@ -151,9 +151,8 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 		    FRAME_SIZE_NTSC_Y422;
 	} else {
 		risc_program_size = PAL_VID_PROG_SIZE;
-		frame_size =
-		    (bpl ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
+		frame_size = (bpl == Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 :
+						FRAME_SIZE_PAL_Y422;
 	}
 
 	/* Virtual address of Risc buffer program */
@@ -165,30 +164,23 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 		if (UNSET != top_offset) {
 			fifo_enable = (frame == 0) ? FIFO_ENABLE : FIFO_DISABLE;
 			rp = cx25821_risc_field_upstream_ch2(dev, rp,
-							     dev->
-							     _data_buf_phys_addr_ch2
-							     + databuf_offset,
-							     top_offset, 0, bpl,
-							     odd_num_lines,
-							     fifo_enable,
-							     ODD_FIELD);
+				dev->_data_buf_phys_addr_ch2 + databuf_offset,
+				top_offset, 0, bpl, odd_num_lines, fifo_enable,
+				ODD_FIELD);
 		}
 
 		fifo_enable = FIFO_DISABLE;
 
-	       /* Even field */
+		/* Even field */
 		rp = cx25821_risc_field_upstream_ch2(dev, rp,
-						     dev->
-						     _data_buf_phys_addr_ch2 +
-						     databuf_offset,
-						     bottom_offset, 0x200, bpl,
-						     singlefield_lines,
-						     fifo_enable, EVEN_FIELD);
+				dev->_data_buf_phys_addr_ch2 + databuf_offset,
+				bottom_offset, 0x200, bpl, singlefield_lines,
+				fifo_enable, EVEN_FIELD);
 
 		if (frame == 0) {
 			risc_flag = RISC_CNT_RESET;
-			risc_phys_jump_addr =
-			    dev->_dma_phys_start_addr_ch2 + risc_program_size;
+			risc_phys_jump_addr = dev->_dma_phys_start_addr_ch2 +
+					risc_program_size;
 		} else {
 			risc_flag = RISC_CNT_INC;
 			risc_phys_jump_addr = dev->_dma_phys_start_addr_ch2;
@@ -510,9 +502,8 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 		return ret;
 
 	/* Creating RISC programs */
-	ret =
-	    cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
-					     dev->_lines_count_ch2);
+	ret = cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
+						dev->_lines_count_ch2);
 	if (ret < 0) {
 		pr_info("Failed creating Video Upstream Risc programs!\n");
 		goto error;
@@ -520,7 +511,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 
 	return 0;
 
-	error:
+error:
 	return ret;
 }
 
@@ -565,23 +556,18 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 			}
 
 			if (dev->_dma_virt_start_addr_ch2 != NULL) {
-				line_size_in_bytes =
-				    (dev->_pixel_format_ch2 ==
-				     PIXEL_FRMT_411) ? Y411_LINE_SZ :
-				    Y422_LINE_SZ;
+				line_size_in_bytes = (dev->_pixel_format_ch2 ==
+						PIXEL_FRMT_411) ? Y411_LINE_SZ :
+						Y422_LINE_SZ;
 				risc_phys_jump_addr =
-				    dev->_dma_phys_start_addr_ch2 +
-				    odd_risc_prog_size;
+					dev->_dma_phys_start_addr_ch2 +
+					odd_risc_prog_size;
 
 				rp = cx25821_update_riscprogram_ch2(dev,
-								    dev->
-								    _dma_virt_start_addr_ch2,
-								    TOP_OFFSET,
-								    line_size_in_bytes,
-								    0x0,
-								    singlefield_lines,
-								    FIFO_DISABLE,
-								    ODD_FIELD);
+						dev->_dma_virt_start_addr_ch2,
+						TOP_OFFSET, line_size_in_bytes,
+						0x0, singlefield_lines,
+						FIFO_DISABLE, ODD_FIELD);
 
 			       /* Jump to Even Risc program of 1st Frame */
 				*(rp++) = cpu_to_le32(RISC_JUMP);
@@ -719,7 +705,7 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
 
 	return 0;
 
-	fail_irq:
+fail_irq:
 	cx25821_dev_unregister(dev);
 	return err;
 }
@@ -805,8 +791,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 		}
 	}
 
-	retval =
-	    cx25821_sram_channel_setup_upstream(dev, sram_ch,
+	retval = cx25821_sram_channel_setup_upstream(dev, sram_ch,
 						dev->_line_size_ch2, 0);
 
 	/* setup fifo + format */
@@ -816,8 +801,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	dev->upstream_databuf_size_ch2 = data_frame_size * 2;
 
 	/* Allocating buffers and prepare RISC program */
-	retval =
-	    cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
+	retval = cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
 						dev->_line_size_ch2);
 	if (retval < 0) {
 		pr_err("%s: Failed to set up Video upstream buffers!\n",
@@ -829,8 +813,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 
 	return 0;
 
-	error:
+error:
 	cx25821_dev_unregister(dev);
-
 	return err;
 }
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
index 029e830..076561d 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
@@ -65,37 +65,61 @@
 #define USE_RISC_NOOP_VIDEO   1
 
 #ifdef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +   \
-				    RISC_SYNC_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
+	NUM_NO_OPS*DWORD_SIZE)
 
 #define PAL_RISC_BUF_SIZE         (2 * PAL_US_VID_PROG_SIZE)
 
-#define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)
+#define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + \
+	2*RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)
 
-#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + \
+	RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	NUM_NO_OPS*DWORD_SIZE)
 
-#define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
-				    JUMP_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + \
+	NUM_NO_OPS*DWORD_SIZE)
 
-#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
+#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + \
+					NTSC_US_VID_PROG_SIZE))
 
-#define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)
-#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * \
+	3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + \
+	2*NUM_NO_OPS*DWORD_SIZE)
+#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + \
+	RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	NUM_NO_OPS*DWORD_SIZE)
 #endif
 
 #ifndef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-#define PAL_RISC_BUF_SIZE         (2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE))
-#define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-#define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
-#define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE + \
+					RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define PAL_RISC_BUF_SIZE         (2 * (RISC_SYNC_INSTRUCTION_SIZE + \
+					PAL_US_VID_PROG_SIZE))
+
+#define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + \
+	2*RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	JUMP_INSTRUCTION_SIZE)
+
+#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + \
+	RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + \
+	RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+
+#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + \
+				NTSC_US_VID_PROG_SIZE))
+
+#define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * \
+	3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+
 #endif
-- 
1.7.0.4


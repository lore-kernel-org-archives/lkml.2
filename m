Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1JVFsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JVFsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:47 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/36] Staging: cx25821: cx25821-video-upstream-ch2.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:45 +0800
Message-Id: <1319262236-6498-26-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   82 ++++++++-----------
 1 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index aeae2b4..8e2ca07 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -260,9 +260,8 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 	struct file *myfile;
 	int frame_index_temp = dev->_frame_index_ch2;
 	int i = 0;
-	int line_size =
-	    (dev->_pixel_format_ch2 ==
-	     PIXEL_FRMT_411) ? Y411_LINE_SZ : Y422_LINE_SZ;
+	int line_size = (dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
+		Y411_LINE_SZ : Y422_LINE_SZ;
 	int frame_size = 0;
 	int frame_offset = 0;
 	ssize_t vfs_read_retval = 0;
@@ -275,14 +274,11 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		return 0;
 
 	if (dev->_isNTSC_ch2) {
-		frame_size =
-		    (line_size ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_NTSC_Y411 :
-		    FRAME_SIZE_NTSC_Y422;
+		frame_size = (line_size == Y411_LINE_SZ) ?
+			FRAME_SIZE_NTSC_Y411 : FRAME_SIZE_NTSC_Y422;
 	} else {
-		frame_size =
-		    (line_size ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
+		frame_size = (line_size == Y411_LINE_SZ) ?
+			FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
 	}
 
 	frame_offset = (frame_index_temp > 0) ? frame_size : 0;
@@ -316,8 +312,8 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		for (i = 0; i < dev->_lines_count_ch2; i++) {
 			pos = file_offset;
 
-			vfs_read_retval =
-			    vfs_read(myfile, mybuf, line_size, &pos);
+			vfs_read_retval = vfs_read(myfile, mybuf, line_size,
+					&pos);
 
 			if (vfs_read_retval > 0 && vfs_read_retval == line_size
 			    && dev->_data_buf_virt_addr_ch2 != NULL) {
@@ -339,8 +335,8 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		if (i > 0)
 			dev->_frame_count_ch2++;
 
-		dev->_file_status_ch2 =
-		    (vfs_read_retval == line_size) ? IN_PROGRESS : END_OF_FILE;
+		dev->_file_status_ch2 = (vfs_read_retval == line_size) ?
+			IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
 		filp_close(myfile, NULL);
@@ -351,8 +347,8 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 static void cx25821_vidups_handler_ch2(struct work_struct *work)
 {
-	struct cx25821_dev *dev =
-	    container_of(work, struct cx25821_dev, _irq_work_entry_ch2);
+	struct cx25821_dev *dev = container_of(work, struct cx25821_dev,
+			_irq_work_entry_ch2);
 
 	if (!dev) {
 		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
@@ -360,18 +356,16 @@ static void cx25821_vidups_handler_ch2(struct work_struct *work)
 		return;
 	}
 
-	cx25821_get_frame_ch2(dev,
-			     dev->channels[dev->
-			       _channel2_upstream_select].sram_channels);
+	cx25821_get_frame_ch2(dev, dev->channels[dev->
+			_channel2_upstream_select].sram_channels);
 }
 
 int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int i = 0, j = 0;
-	int line_size =
-	    (dev->_pixel_format_ch2 ==
-	     PIXEL_FRMT_411) ? Y411_LINE_SZ : Y422_LINE_SZ;
+	int line_size = (dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
+		Y411_LINE_SZ : Y422_LINE_SZ;
 	ssize_t vfs_read_retval = 0;
 	char mybuf[line_size];
 	loff_t pos;
@@ -408,8 +402,8 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 			for (i = 0; i < dev->_lines_count_ch2; i++) {
 				pos = offset;
 
-				vfs_read_retval =
-				    vfs_read(myfile, mybuf, line_size, &pos);
+				vfs_read_retval = vfs_read(myfile, mybuf,
+						line_size, &pos);
 
 				if (vfs_read_retval > 0 &&
 				    vfs_read_retval == line_size &&
@@ -436,8 +430,8 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 				break;
 		}
 
-		dev->_file_status_ch2 =
-		    (vfs_read_retval == line_size) ? IN_PROGRESS : END_OF_FILE;
+		dev->_file_status_ch2 = (vfs_read_retval == line_size) ?
+			IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
 		myfile->f_pos = 0;
@@ -461,9 +455,8 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 				    dev->_dma_phys_addr_ch2);
 	}
 
-	dev->_dma_virt_addr_ch2 =
-	    pci_alloc_consistent(dev->pci, dev->upstream_riscbuf_size_ch2,
-				 &dma_addr);
+	dev->_dma_virt_addr_ch2 = pci_alloc_consistent(dev->pci,
+			dev->upstream_riscbuf_size_ch2, &dma_addr);
 	dev->_dma_virt_start_addr_ch2 = dev->_dma_virt_addr_ch2;
 	dev->_dma_phys_start_addr_ch2 = dma_addr;
 	dev->_dma_phys_addr_ch2 = dma_addr;
@@ -483,9 +476,8 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 				    dev->_data_buf_phys_addr_ch2);
 	}
 	/* For Video Data buffer allocation */
-	dev->_data_buf_virt_addr_ch2 =
-	    pci_alloc_consistent(dev->pci, dev->upstream_databuf_size_ch2,
-				 &data_dma_addr);
+	dev->_data_buf_virt_addr_ch2 = pci_alloc_consistent(dev->pci,
+			dev->upstream_databuf_size_ch2, &data_dma_addr);
 	dev->_data_buf_phys_addr_ch2 = data_dma_addr;
 	dev->_data_buf_size_ch2 = dev->upstream_databuf_size_ch2;
 
@@ -687,8 +679,7 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
 
-	err =
-	    request_irq(dev->pci->irq, cx25821_upstream_irq_ch2,
+	err = request_irq(dev->pci->irq, cx25821_upstream_irq_ch2,
 			IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
 		pr_err("%s: can't get upstream IRQ %d\n",
@@ -748,12 +739,11 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	dev->_file_status_ch2 = RESET_STATUS;
 	dev->_lines_count_ch2 = dev->_isNTSC_ch2 ? 480 : 576;
 	dev->_pixel_format_ch2 = pixel_format;
-	dev->_line_size_ch2 =
-	    (dev->_pixel_format_ch2 ==
-	     PIXEL_FRMT_422) ? (WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
+	dev->_line_size_ch2 = (dev->_pixel_format_ch2 == PIXEL_FRMT_422) ?
+		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
 	data_frame_size = dev->_isNTSC_ch2 ? NTSC_DATA_BUF_SZ : PAL_DATA_BUF_SZ;
-	risc_buffer_size =
-	    dev->_isNTSC_ch2 ? NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
+	risc_buffer_size = dev->_isNTSC_ch2 ?
+		NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
 	if (dev->input_filename_ch2) {
 		str_length = strlen(dev->input_filename_ch2);
@@ -778,15 +768,13 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	/* Default if filename is empty string */
 	if (strcmp(dev->input_filename_ch2, "") == 0) {
 		if (dev->_isNTSC_ch2) {
-			dev->_filename_ch2 =
-			    (dev->_pixel_format_ch2 ==
-			     PIXEL_FRMT_411) ? "/root/vid411.yuv" :
-			    "/root/vidtest.yuv";
+			dev->_filename_ch2 = (dev->_pixel_format_ch2 ==
+				PIXEL_FRMT_411) ? "/root/vid411.yuv" :
+				"/root/vidtest.yuv";
 		} else {
-			dev->_filename_ch2 =
-			    (dev->_pixel_format_ch2 ==
-			     PIXEL_FRMT_411) ? "/root/pal411.yuv" :
-			    "/root/pal422.yuv";
+			dev->_filename_ch2 = (dev->_pixel_format_ch2 ==
+				PIXEL_FRMT_411) ? "/root/pal411.yuv" :
+				"/root/pal422.yuv";
 		}
 	}
 
-- 
1.7.0.4


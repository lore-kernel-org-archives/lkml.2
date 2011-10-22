Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1JVFtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:49:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1JVFtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:49:11 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 28/36] Staging: cx25821: cx25821-video-upstream.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:48 +0800
Message-Id: <1319262236-6498-29-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video-upstream.c |   87 +++++++++------------
 1 files changed, 37 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 0cf2179..b65dabe 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -194,15 +194,12 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 	if (dev->_isNTSC) {
 		odd_num_lines = singlefield_lines + 1;
 		risc_program_size = FRAME1_VID_PROG_SIZE;
-		frame_size =
-		    (bpl ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_NTSC_Y411 :
-		    FRAME_SIZE_NTSC_Y422;
+		frame_size = (bpl == Y411_LINE_SZ) ?
+			FRAME_SIZE_NTSC_Y411 : FRAME_SIZE_NTSC_Y422;
 	} else {
 		risc_program_size = PAL_VID_PROG_SIZE;
-		frame_size =
-		    (bpl ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
+		frame_size = (bpl == Y411_LINE_SZ) ?
+			FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
 	}
 
 	/* Virtual address of Risc buffer program */
@@ -230,8 +227,8 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 
 		if (frame == 0) {
 			risc_flag = RISC_CNT_RESET;
-			risc_phys_jump_addr =
-			    dev->_dma_phys_start_addr + risc_program_size;
+			risc_phys_jump_addr = dev->_dma_phys_start_addr +
+				risc_program_size;
 		} else {
 			risc_phys_jump_addr = dev->_dma_phys_start_addr;
 			risc_flag = RISC_CNT_INC;
@@ -308,9 +305,8 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 	struct file *myfile;
 	int frame_index_temp = dev->_frame_index;
 	int i = 0;
-	int line_size =
-	    (dev->_pixel_format ==
-	     PIXEL_FRMT_411) ? Y411_LINE_SZ : Y422_LINE_SZ;
+	int line_size = (dev->_pixel_format == PIXEL_FRMT_411) ?
+		Y411_LINE_SZ : Y422_LINE_SZ;
 	int frame_size = 0;
 	int frame_offset = 0;
 	ssize_t vfs_read_retval = 0;
@@ -361,8 +357,8 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		for (i = 0; i < dev->_lines_count; i++) {
 			pos = file_offset;
 
-			vfs_read_retval =
-			    vfs_read(myfile, mybuf, line_size, &pos);
+			vfs_read_retval = vfs_read(myfile, mybuf, line_size,
+					&pos);
 
 			if (vfs_read_retval > 0 && vfs_read_retval == line_size
 			    && dev->_data_buf_virt_addr != NULL) {
@@ -384,8 +380,8 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		if (i > 0)
 			dev->_frame_count++;
 
-		dev->_file_status =
-		    (vfs_read_retval == line_size) ? IN_PROGRESS : END_OF_FILE;
+		dev->_file_status = (vfs_read_retval == line_size) ?
+			IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
 		filp_close(myfile, NULL);
@@ -396,8 +392,8 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 static void cx25821_vidups_handler(struct work_struct *work)
 {
-	struct cx25821_dev *dev =
-	    container_of(work, struct cx25821_dev, _irq_work_entry);
+	struct cx25821_dev *dev = container_of(work, struct cx25821_dev,
+			_irq_work_entry);
 
 	if (!dev) {
 		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
@@ -405,18 +401,16 @@ static void cx25821_vidups_handler(struct work_struct *work)
 		return;
 	}
 
-	cx25821_get_frame(dev,
-			 dev->channels[dev->_channel_upstream_select].
-					       sram_channels);
+	cx25821_get_frame(dev, dev->channels[dev->_channel_upstream_select].
+			sram_channels);
 }
 
 int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int i = 0, j = 0;
-	int line_size =
-	    (dev->_pixel_format ==
-	     PIXEL_FRMT_411) ? Y411_LINE_SZ : Y422_LINE_SZ;
+	int line_size = (dev->_pixel_format == PIXEL_FRMT_411) ?
+		Y411_LINE_SZ : Y422_LINE_SZ;
 	ssize_t vfs_read_retval = 0;
 	char mybuf[line_size];
 	loff_t pos;
@@ -453,8 +447,8 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 			for (i = 0; i < dev->_lines_count; i++) {
 				pos = offset;
 
-				vfs_read_retval =
-				    vfs_read(myfile, mybuf, line_size, &pos);
+				vfs_read_retval = vfs_read(myfile, mybuf,
+						line_size, &pos);
 
 				if (vfs_read_retval > 0
 				    && vfs_read_retval == line_size
@@ -481,8 +475,8 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 				break;
 		}
 
-		dev->_file_status =
-		    (vfs_read_retval == line_size) ? IN_PROGRESS : END_OF_FILE;
+		dev->_file_status = (vfs_read_retval == line_size) ?
+			IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
 		myfile->f_pos = 0;
@@ -503,9 +497,8 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 		pci_free_consistent(dev->pci, dev->upstream_riscbuf_size,
 				dev->_dma_virt_addr, dev->_dma_phys_addr);
 
-	dev->_dma_virt_addr =
-	    pci_alloc_consistent(dev->pci, dev->upstream_riscbuf_size,
-				 &dma_addr);
+	dev->_dma_virt_addr = pci_alloc_consistent(dev->pci,
+			dev->upstream_riscbuf_size, &dma_addr);
 	dev->_dma_virt_start_addr = dev->_dma_virt_addr;
 	dev->_dma_phys_start_addr = dma_addr;
 	dev->_dma_phys_addr = dma_addr;
@@ -524,9 +517,8 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 				dev->_data_buf_virt_addr,
 				dev->_data_buf_phys_addr);
 	/* For Video Data buffer allocation */
-	dev->_data_buf_virt_addr =
-	    pci_alloc_consistent(dev->pci, dev->upstream_databuf_size,
-				 &data_dma_addr);
+	dev->_data_buf_virt_addr = pci_alloc_consistent(dev->pci,
+			dev->upstream_databuf_size, &data_dma_addr);
 	dev->_data_buf_phys_addr = data_dma_addr;
 	dev->_data_buf_size = dev->upstream_databuf_size;
 
@@ -543,9 +535,8 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 		return ret;
 
 	/* Create RISC programs */
-	ret =
-	    cx25821_risc_buffer_upstream(dev, dev->pci, 0, bpl,
-					 dev->_lines_count);
+	ret = cx25821_risc_buffer_upstream(dev, dev->pci, 0, bpl,
+			dev->_lines_count);
 	if (ret < 0) {
 		pr_info("Failed creating Video Upstream Risc programs!\n");
 		goto error;
@@ -736,8 +727,7 @@ int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
 
-	err =
-	    request_irq(dev->pci->irq, cx25821_upstream_irq,
+	err = request_irq(dev->pci->irq, cx25821_upstream_irq,
 			IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
 		pr_err("%s: can't get upstream IRQ %d\n",
@@ -796,12 +786,11 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	dev->_file_status = RESET_STATUS;
 	dev->_lines_count = dev->_isNTSC ? 480 : 576;
 	dev->_pixel_format = pixel_format;
-	dev->_line_size =
-	    (dev->_pixel_format ==
-	     PIXEL_FRMT_422) ? (WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
+	dev->_line_size = (dev->_pixel_format == PIXEL_FRMT_422) ?
+		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
 	data_frame_size = dev->_isNTSC ? NTSC_DATA_BUF_SZ : PAL_DATA_BUF_SZ;
-	risc_buffer_size =
-	    dev->_isNTSC ? NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
+	risc_buffer_size = dev->_isNTSC ?
+		NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
 	if (dev->input_filename) {
 		str_length = strlen(dev->input_filename);
@@ -839,13 +828,11 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	dev->_file_status = RESET_STATUS;
 	dev->_lines_count = dev->_isNTSC ? 480 : 576;
 	dev->_pixel_format = pixel_format;
-	dev->_line_size =
-	    (dev->_pixel_format ==
-	     PIXEL_FRMT_422) ? (WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
+	dev->_line_size = (dev->_pixel_format == PIXEL_FRMT_422) ?
+		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
 
-	retval =
-	    cx25821_sram_channel_setup_upstream(dev, sram_ch, dev->_line_size,
-						0);
+	retval = cx25821_sram_channel_setup_upstream(dev, sram_ch,
+			dev->_line_size, 0);
 
 	/* setup fifo + format */
 	cx25821_set_pixelengine(dev, sram_ch, dev->_pixel_format);
-- 
1.7.0.4


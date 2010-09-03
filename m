Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab0ICS1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:27:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57926 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab0ICS1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LlcfmzTA8g4YFHzBQAcNOa7gvC70VV3caKpktAY3FXOIOUkr/1DUnLJARXsVewE4QJ
         PN8pukKlyjt9kTqIBlY/jdzOccKuEbGBa0it8FqewTRtRN/omo8vt0hzywxYZNnAjEak
         N+dBjirUOGV2aITn7/rufid5UkzmUFxW9qBJw=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, palash.bandyopadhyay@conexant.com,
        olimpiu.pascariu@gmail.com, laurent.pinchart@ideasonboard.com,
        peterhuewe@gmx.de, tsg321@gmail.com, error27@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 3/3] Staging: cx25821: fix coding style issue in cx25821-audio-upstream.h, cx25821-core.c, cx25821-i2c.c, cx25821-medusa-reg.h, cx25821-medusa-video.c
Date: Sat,  4 Sep 2010 00:26:24 +0600
Message-Id: <1283538384-12227-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cx25821-audio-upstream.h, cx25821-core.c, cx25821-i2c.c,
cx25821-medusa-reg.h, cx25821-medusa-video.c fixed up warnings found by
checkpatch.pl tool.

Signed-off-by: Ilya Gorskin<revent82@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.h |    4 +-
 drivers/staging/cx25821/cx25821-core.c           |   51 +++++++++++-----------
 drivers/staging/cx25821/cx25821-i2c.c            |    2 +-
 drivers/staging/cx25821/cx25821-medusa-reg.h     |   12 +++---
 drivers/staging/cx25821/cx25821-medusa-video.c   |   15 +++---
 5 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.h b/drivers/staging/cx25821/cx25821-audio-upstream.h
index ca987ad..aeb871e 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.h
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.h
@@ -46,11 +46,11 @@
 #define USE_RISC_NOOP_AUDIO   1
 
 #ifdef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    ( LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 #ifndef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    ( LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 static int _line_size;
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index c487c19..282762d 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -781,14 +781,14 @@ static void cx25821_shutdown(struct cx25821_dev *dev)
 
 	/* Disable Video A/B activity */
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
-	       cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
-	       cx_write(dev->channels[i].sram_channels->int_msk, 0);
+		cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+		cx_write(dev->channels[i].sram_channels->int_msk, 0);
 	}
 
 	for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
 	     i++) {
-	       cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
-	       cx_write(dev->channels[i].sram_channels->int_msk, 0);
+		cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+		cx_write(dev->channels[i].sram_channels->int_msk, 0);
 	}
 
 	/* Disable Audio activity */
@@ -806,9 +806,9 @@ void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel_select,
 			      u32 format)
 {
 	if (channel_select <= 7 && channel_select >= 0) {
-	       cx_write(dev->channels[channel_select].
-			       sram_channels->pix_frmt, format);
-	       dev->channels[channel_select].pixel_formats = format;
+		cx_write(dev->channels[channel_select].
+			sram_channels->pix_frmt, format);
+		dev->channels[channel_select].pixel_formats = format;
 	}
 }
 
@@ -829,7 +829,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	cx_write(PCI_INT_STAT, 0xffffffff);
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++)
-	       cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
+		cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
 
 	cx_write(AUD_A_INT_STAT, 0xffffffff);
 	cx_write(AUD_B_INT_STAT, 0xffffffff);
@@ -843,20 +843,20 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	mdelay(100);
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
-	       cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
-	       cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
-					       1440, 0);
-	       dev->channels[i].pixel_formats = PIXEL_FRMT_422;
-	       dev->channels[i].use_cif_resolution = FALSE;
+		cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
+		cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
+						1440, 0);
+		dev->channels[i].pixel_formats = PIXEL_FRMT_422;
+		dev->channels[i].use_cif_resolution = FALSE;
 	}
 
 	/* Probably only affect Downstream */
 	for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
 	     i++) {
-	       cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
+		cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
 	}
 
-       cx25821_sram_channel_setup_audio(dev,
+	cx25821_sram_channel_setup_audio(dev,
 			       dev->channels[SRAM_CH08].sram_channels,
 			       128, 0);
 
@@ -931,8 +931,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	/* Apply a sensible clock frequency for the PCIe bridge */
 	dev->clk_freq = 28000000;
-       for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
-	       dev->channels[i].sram_channels = &cx25821_sram_channels[i];
+	for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
+		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
 
 	if (dev->nr > 1)
 		CX25821_INFO("dev->nr > 1!");
@@ -977,8 +977,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	dev->lmmio = ioremap(dev->base_io_addr, pci_resource_len(dev->pci, 0));
 
 	if (!dev->lmmio) {
-		CX25821_ERR
-		    ("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
+		CX25821_ERR("ioremap failed,
+			    maybe increasing __VMALLOC_RESERVE in page.h\n");
 		cx25821_iounmap(dev);
 		return -ENOMEM;
 	}
@@ -1003,16 +1003,15 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	cx25821_card_setup(dev);
 
-       if (medusa_video_init(dev) < 0)
-	       CX25821_ERR("%s() Failed to initialize medusa!\n"
-	       , __func__);
+	if (medusa_video_init(dev) < 0)
+		CX25821_ERR("%s() Failed to initialize medusa!\n", __func__);
 
-       cx25821_video_register(dev);
+	cx25821_video_register(dev);
 
 	/* register IOCTL device */
 	dev->ioctl_dev =
 	   cx25821_vdev_init(dev, dev->pci, &cx25821_videoioctl_template,
-			      "video");
+								"video");
 
 	if (video_register_device
 	    (dev->ioctl_dev, VFL_TYPE_GRABBER, VIDEO_IOCTL_CH) < 0) {
@@ -1342,8 +1341,8 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
 		if (pci_status & mask[i]) {
-		       vid_status = cx_read(dev->channels[i].
-			       sram_channels->int_stat);
+			vid_status = cx_read(dev->channels[i].
+				sram_channels->int_stat);
 
 			if (vid_status)
 				handled +=
diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index e43572e..2b14bcc 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -283,7 +283,7 @@ static struct i2c_algorithm cx25821_i2c_algo_template = {
 	.master_xfer = i2c_xfer,
 	.functionality = cx25821_functionality,
 #ifdef NEED_ALGO_CONTROL
-       .algo_control = dummy_algo_control,
+	.algo_control = dummy_algo_control,
 #endif
 };
 
diff --git a/drivers/staging/cx25821/cx25821-medusa-reg.h b/drivers/staging/cx25821/cx25821-medusa-reg.h
index f7f33b3..cbb05d5 100644
--- a/drivers/staging/cx25821/cx25821-medusa-reg.h
+++ b/drivers/staging/cx25821/cx25821-medusa-reg.h
@@ -442,14 +442,14 @@
 
 /*****************************************************************************/
 /* LUMA_CTRL register fields */
-#define VDEC_A_BRITE_CTRL				0x1014
-#define VDEC_A_CNTRST_CTRL       		0x1015
-#define VDEC_A_PEAK_SEL          		0x1016
+#define VDEC_A_BRITE_CTRL			0x1014
+#define VDEC_A_CNTRST_CTRL			0x1015
+#define VDEC_A_PEAK_SEL				0x1016
 
 /*****************************************************************************/
 /* CHROMA_CTRL register fields */
-#define VDEC_A_USAT_CTRL         		0x1018
-#define VDEC_A_VSAT_CTRL         		0x1019
-#define VDEC_A_HUE_CTRL          		0x101A
+#define VDEC_A_USAT_CTRL			0x1018
+#define VDEC_A_VSAT_CTRL			0x1019
+#define VDEC_A_HUE_CTRL				0x101A
 
 #endif
diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index ef9f2b8..ab2a6d6 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -500,8 +500,8 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 	/* validate the width - cannot be negative */
 	if (width > MAX_WIDTH) {
 		printk
-		    ("cx25821 %s() : width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH\n",
-		     __func__, width, MAX_WIDTH);
+		    ("cx25821 %s() : width %d > MAX_WIDTH %d !
+		    resetting to MAX_WIDTH\n", __func__, width, MAX_WIDTH);
 		width = MAX_WIDTH;
 	}
 
@@ -778,9 +778,9 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 
 int medusa_video_init(struct cx25821_dev *dev)
 {
-       u32 value = 0, tmp = 0;
-       int ret_val = 0;
-       int i = 0;
+	u32 value = 0, tmp = 0;
+	int ret_val = 0;
+	int i = 0;
 
 	mutex_lock(&dev->lock);
 
@@ -829,9 +829,8 @@ int medusa_video_init(struct cx25821_dev *dev)
 	/* select AFE clock to output mode */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
 	value &= 0x83FFFFFF;
-       ret_val =
-	   cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
-			     value | 0x10000000);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
+				value | 0x10000000);
 
 	if (ret_val < 0)
 		goto error;
-- 
1.7.2.2


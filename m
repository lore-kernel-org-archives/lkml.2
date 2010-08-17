Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab0HQTQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:16:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58496 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HQTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DXemRzTtLKLybWdu0G8PZBGwtgMmJyUZNzL6gBjZXYnSeV9/UFPcb07DyFCLm+XDpu
         q1+7xAzQBJD50F5wq0yJDWHWhh706qNO1FtDrizuCyuCm1FMpYQivBF8+w0JVcOpyxL9
         vmzVyaghYDBU6eUm+DGK8fu3e+Y0tRa4XA4ZY=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, Palash.Bandyopadhyay@conexant.com,
        olimpiu.pascariu@gmail.com, julia@diku.dk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gorskin Ilya <revent82@gmail.com>, Ilya Gorskin <Revent82@gmail.com>
Subject: [PATCH 2/2] Staging: cx25821: clenup warnings found by checkpatch.pl tool in cx25821-audio-upstream.c and cx25821-audio.h.
Date: Wed, 18 Aug 2010 01:15:52 +0600
Message-Id: <1282072552-16105-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cx25821-audio-upstream.c and cx25821-audio.h
that fixes up a warnings found by checkpatch.pl tool.

Signed-off-by: Ilya Gorskin <Revent82@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   15 +++++++--------
 drivers/staging/cx25821/cx25821-audio.h          |   16 ++++++++++------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index cdff49f..27087db 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -40,8 +40,7 @@ MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
 static int _intr_msk =
-    FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF | FLD_AUD_SRC_SYNC |
-    FLD_AUD_SRC_OPC_ERR;
+FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF | FLD_AUD_SRC_SYNC | FLD_AUD_SRC_OPC_ERR;
 
 int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
 					      struct sram_channel *ch,
@@ -506,7 +505,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 {
 	int i = 0;
 	u32 int_msk_tmp;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 	dma_addr_t risc_phys_jump_addr;
 	__le32 *rp;
 
@@ -608,8 +607,8 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 	if (!dev)
 		return -1;
 
-       sram_ch = dev->channels[dev->_audio_upstream_channel_select].
-				       sram_channels;
+	sram_ch = dev->channels[dev->_audio_upstream_channel_select].
+					sram_channels;
 
 	msk_stat = cx_read(sram_ch->int_mstat);
 	audio_status = cx_read(sram_ch->int_stat);
@@ -733,7 +732,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	}
 
 	dev->_audio_upstream_channel_select = channel_select;
-       sram_ch = dev->channels[channel_select].sram_channels;
+	sram_ch = dev->channels[channel_select].sram_channels;
 
 	/* Work queue */
 	INIT_WORK(&dev->_audio_work_entry, cx25821_audioups_handler);
@@ -764,9 +763,9 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		       str_length + 1);
 
 		/* Default if filename is empty string */
-		if (strcmp(dev->input_audiofilename, "") == 0) {
+		if (strcmp(dev->input_audiofilename, "") == 0)
 			dev->_audiofilename = "/root/audioGOOD.wav";
-		}
+
 	} else {
 		str_length = strlen(_defaultAudioName);
 		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 434b2a3..aa5725b 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -31,18 +31,21 @@
 #define NUMBER_OF_PROGRAMS  8
 
 /*
-  Max size of the RISC program for a buffer. - worst case is 2 writes per line
-  Space is also added for the 4 no-op instructions added on the end.
+* Max size of the RISC program for a buffer. - worst case is 2 writes per line
+* Space is also added for the 4 no-op instructions added on the end.
 */
 #ifndef USE_RISC_NOOP
-#define MAX_BUFFER_PROGRAM_SIZE     \
-    (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
+#define MAX_BUFFER_PROGRAM_SIZE		\
+(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE +	\
+			RISC_WRITECR_INSTRUCTION_SIZE*4)
+
 #endif
 
 /* MAE 12 July 2005 Try to use NOOP RISC instruction instead */
 #ifdef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-    (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
+(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4l)
+
 #endif
 
 /* Sizes of various instructions in bytes.  Used when adding instructions. */
@@ -53,6 +56,7 @@
 #define RISC_WRITECR_INSTRUCTION_SIZE  16
 #define RISC_NOOP_INSTRUCTION_SIZE 4
 
-#define MAX_AUDIO_DMA_BUFFER_SIZE (MAX_BUFFER_PROGRAM_SIZE * NUMBER_OF_PROGRAMS + RISC_SYNC_INSTRUCTION_SIZE)
+#define MAX_AUDIO_DMA_BUFFER_SIZE	\
+(MAX_BUFFER_PROGRAM_SIZE * NUMBER_OF_PROGRAMS + RISC_SYNC_INSTRUCTION_SIZE)
 
 #endif
-- 
1.7.2.1


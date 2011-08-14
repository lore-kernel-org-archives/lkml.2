Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1HNLnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 07:43:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42948 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1HNLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 07:43:03 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 1/3] Staging: cx25821: fix style issues in cx25821-audio-upstream
Date: Sun, 14 Aug 2011 19:42:22 +0800
Message-Id: <1313322144-9309-2-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313322144-9309-1-git-send-email-leonidsbox@gmail.com>
References: <1313322144-9309-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-audio-upstream.c and cx25821-audio-upstream.h
Change obscure line endings to less obscure ones.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   33 ++++++++-------------
 drivers/staging/cx25821/cx25821-audio-upstream.h |    9 ++++-
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 0f9ca77..ca1369f 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -540,13 +540,9 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 				    AUDIO_RISC_DMA_BUF_SIZE;
 
 				rp = cx25821_risc_field_upstream_audio(dev,
-								       dev->
-								       _risc_virt_start_addr
-								       + 1,
-								       dev->
-								       _audiodata_buf_phys_addr,
-								       AUDIO_LINE_SIZE,
-								       FIFO_DISABLE);
+						dev->_risc_virt_start_addr + 1,
+						dev->_audiodata_buf_phys_addr,
+						AUDIO_LINE_SIZE, FIFO_DISABLE);
 
 				if (USE_RISC_NOOP_AUDIO) {
 					for (i = 0; i < NUM_NO_OPS; i++) {
@@ -555,8 +551,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 					}
 				}
 				/* Jump to 2nd Audio Frame */
-				*(rp++) =
-				    cpu_to_le32(RISC_JUMP | RISC_IRQ1 |
+				*(rp++) = cpu_to_le32(RISC_JUMP | RISC_IRQ1 |
 						RISC_CNT_RESET);
 				*(rp++) = cpu_to_le32(risc_phys_jump_addr);
 				*(rp++) = cpu_to_le32(0);
@@ -604,18 +599,17 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 	if (!dev)
 		return -1;
 
-	sram_ch = dev->channels[dev->_audio_upstream_channel_select].sram_channels;
+	sram_ch = dev->channels[dev->_audio_upstream_channel_select].
+			sram_channels;
 
 	msk_stat = cx_read(sram_ch->int_mstat);
 	audio_status = cx_read(sram_ch->int_stat);
 
 	/* Only deal with our interrupt */
 	if (audio_status) {
-		handled =
-		    cx25821_audio_upstream_irq(dev,
-					       dev->
-					       _audio_upstream_channel_select,
-					       audio_status);
+		handled = cx25821_audio_upstream_irq(dev,
+				dev->_audio_upstream_channel_select,
+				audio_status);
 	}
 
 	if (handled < 0)
@@ -770,9 +764,8 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		memcpy(dev->_audiofilename, _defaultAudioName, str_length + 1);
 	}
 
-	retval =
-	    cx25821_sram_channel_setup_upstream_audio(dev, sram_ch, _line_size,
-						      0);
+	retval = cx25821_sram_channel_setup_upstream_audio(dev, sram_ch,
+							_line_size, 0);
 
 	dev->audio_upstream_riscbuf_size =
 	    AUDIO_RISC_DMA_BUF_SIZE * NUM_AUDIO_PROGS +
@@ -780,8 +773,8 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	dev->audio_upstream_databuf_size = AUDIO_DATA_BUF_SZ * NUM_AUDIO_PROGS;
 
 	/* Allocating buffers and prepare RISC program */
-	retval =
-	    cx25821_audio_upstream_buffer_prepare(dev, sram_ch, _line_size);
+	retval = cx25821_audio_upstream_buffer_prepare(dev, sram_ch,
+							_line_size);
 	if (retval < 0) {
 		pr_err("%s: Failed to set up Audio upstream buffers!\n",
 		       dev->name);
diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.h b/drivers/staging/cx25821/cx25821-audio-upstream.h
index 668a4f1..66aa6d0 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.h
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.h
@@ -46,11 +46,16 @@
 #define USE_RISC_NOOP_AUDIO   1
 
 #ifdef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE \
+	(LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + \
+	RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 #ifndef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE \
+	(LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 static int _line_size;
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1JVFqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:46:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1JVFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:46:17 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/36] Staging: cx25821: cx25821-alsa.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:24 +0800
Message-Id: <1319262236-6498-5-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-alsa.c |   52 +++++++++++++-------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index e700365..00fda93 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -176,8 +176,7 @@ static int _cx25821_start_audio_dma(struct cx25821_audio_dev *chip)
 
 	/* Set the input mode to 16-bit */
 	tmp = cx_read(AUD_A_CFG);
-	cx_write(AUD_A_CFG,
-		 tmp | FLD_AUD_DST_PK_MODE | FLD_AUD_DST_ENABLE |
+	cx_write(AUD_A_CFG, tmp | FLD_AUD_DST_PK_MODE | FLD_AUD_DST_ENABLE |
 		 FLD_AUD_CLK_ENABLE);
 
 	/*
@@ -188,9 +187,8 @@ static int _cx25821_start_audio_dma(struct cx25821_audio_dev *chip)
 	*/
 
 	/* Enables corresponding bits at AUD_INT_STAT */
-	cx_write(AUD_A_INT_MSK,
-		 FLD_AUD_DST_RISCI1 | FLD_AUD_DST_OF | FLD_AUD_DST_SYNC |
-		 FLD_AUD_DST_OPC_ERR);
+	cx_write(AUD_A_INT_MSK, FLD_AUD_DST_RISCI1 | FLD_AUD_DST_OF |
+		 FLD_AUD_DST_SYNC | FLD_AUD_DST_OPC_ERR);
 
 	/* Clean any pending interrupt bits already set */
 	cx_write(AUD_A_INT_STAT, ~0);
@@ -200,8 +198,8 @@ static int _cx25821_start_audio_dma(struct cx25821_audio_dev *chip)
 
 	/* Turn on audio downstream fifo and risc enable 0x101 */
 	tmp = cx_read(AUD_INT_DMA_CTL);
-	cx_set(AUD_INT_DMA_CTL,
-	       tmp | (FLD_AUD_DST_A_RISC_EN | FLD_AUD_DST_A_FIFO_EN));
+	cx_set(AUD_INT_DMA_CTL, tmp |
+	       (FLD_AUD_DST_A_RISC_EN | FLD_AUD_DST_A_FIFO_EN));
 
 	mdelay(100);
 	return 0;
@@ -220,9 +218,8 @@ static int _cx25821_stop_audio_dma(struct cx25821_audio_dev *chip)
 
 	/* disable irqs */
 	cx_clear(PCI_INT_MSK, PCI_MSK_AUD_INT);
-	cx_clear(AUD_A_INT_MSK,
-		 AUD_INT_OPC_ERR | AUD_INT_DN_SYNC | AUD_INT_DN_RISCI2 |
-		 AUD_INT_DN_RISCI1);
+	cx_clear(AUD_A_INT_MSK, AUD_INT_OPC_ERR | AUD_INT_DN_SYNC |
+		 AUD_INT_DN_RISCI2 | AUD_INT_DN_RISCI1);
 
 	return 0;
 }
@@ -258,10 +255,8 @@ static void cx25821_aud_irq(struct cx25821_audio_dev *chip, u32 status,
 
 	cx_write(AUD_A_INT_STAT, status);
 	if (debug > 1 || (status & mask & ~0xff))
-		cx25821_print_irqbits(dev->name, "irq aud",
-				      cx25821_aud_irqs,
-				      ARRAY_SIZE(cx25821_aud_irqs), status,
-				      mask);
+		cx25821_print_irqbits(dev->name, "irq aud", cx25821_aud_irqs,
+				ARRAY_SIZE(cx25821_aud_irqs), status, mask);
 
 	/* risc op code error */
 	if (status & AUD_INT_OPC_ERR) {
@@ -270,8 +265,7 @@ static void cx25821_aud_irq(struct cx25821_audio_dev *chip, u32 status,
 		cx_clear(AUD_INT_DMA_CTL,
 			 FLD_AUD_DST_A_RISC_EN | FLD_AUD_DST_A_FIFO_EN);
 		cx25821_sram_channel_dump_audio(dev,
-						&cx25821_sram_channels
-						[AUDIO_SRAM_CHANNEL]);
+				&cx25821_sram_channels[AUDIO_SRAM_CHANNEL]);
 	}
 	if (status & AUD_INT_DN_SYNC) {
 		pr_warn("WARNING %s: Downstream sync error!\n", dev->name);
@@ -362,9 +356,8 @@ static int dsp_buffer_free(struct cx25821_audio_dev *chip)
  */
 #define DEFAULT_FIFO_SIZE	384
 static struct snd_pcm_hardware snd_cx25821_digital_hw = {
-	.info = SNDRV_PCM_INFO_MMAP |
-	    SNDRV_PCM_INFO_INTERLEAVED |
-	    SNDRV_PCM_INFO_BLOCK_TRANSFER | SNDRV_PCM_INFO_MMAP_VALID,
+	.info = SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED |
+		SNDRV_PCM_INFO_BLOCK_TRANSFER | SNDRV_PCM_INFO_MMAP_VALID,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 
 	.rates = SNDRV_PCM_RATE_48000,
@@ -397,8 +390,8 @@ static int snd_cx25821_pcm_open(struct snd_pcm_substream *substream)
 		return -ENODEV;
 	}
 
-	err =
-	    snd_pcm_hw_constraint_pow2(runtime, 0, SNDRV_PCM_HW_PARAM_PERIODS);
+	err = snd_pcm_hw_constraint_pow2(runtime, 0,
+					 SNDRV_PCM_HW_PARAM_PERIODS);
 	if (err < 0)
 		goto _error;
 
@@ -469,8 +462,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	dma = &buf->dma;
 	videobuf_dma_init(dma);
 	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
-				       (PAGE_ALIGN(chip->dma_size) >>
-					PAGE_SHIFT));
+			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
@@ -478,10 +470,8 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		goto error;
 
-	ret =
-	    cx25821_risc_databuffer_audio(chip->pci, &buf->risc, dma->sglist,
-					  chip->period_size, chip->num_periods,
-					  1);
+	ret = cx25821_risc_databuffer_audio(chip->pci, &buf->risc, dma->sglist,
+			chip->period_size, chip->num_periods, 1);
 	if (ret < 0) {
 		pr_info("DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
 		goto error;
@@ -712,8 +702,8 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 			  IRQF_SHARED | IRQF_DISABLED, chip->dev->name, chip);
 
 	if (err < 0) {
-		pr_err("ERROR %s: can't get IRQ %d for ALSA\n",
-		       chip->dev->name, dev->pci->irq);
+		pr_err("ERROR %s: can't get IRQ %d for ALSA\n", chip->dev->name,
+			dev->pci->irq);
 		goto error;
 	}
 
@@ -731,8 +721,8 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 		chip->iobase, chip->irq);
 	strcpy(card->mixername, "CX25821");
 
-	pr_info("%s/%i: ALSA support for cx25821 boards\n",
-		card->driver, devno);
+	pr_info("%s/%i: ALSA support for cx25821 boards\n", card->driver,
+		devno);
 
 	err = snd_card_register(card);
 	if (err < 0) {
-- 
1.7.0.4


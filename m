Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1JVFqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:46:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1JVFqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:46:40 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/36] Staging: cx25821: cx25821-audio-upstream.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:27 +0800
Message-Id: <1319262236-6498-8-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   54 ++++++++++------------
 1 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index b2cd794..7eefc05 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -175,10 +175,8 @@ int cx25821_risc_buffer_upstream_audio(struct cx25821_dev *dev,
 		}
 
 		rp = cx25821_risc_field_upstream_audio(dev, rp,
-						       dev->
-						       _audiodata_buf_phys_addr
-						       + databuf_offset, bpl,
-						       fifo_enable);
+				dev->_audiodata_buf_phys_addr + databuf_offset,
+				bpl, fifo_enable);
 
 		if (USE_RISC_NOOP_AUDIO) {
 			for (i = 0; i < NUM_NO_OPS; i++)
@@ -305,8 +303,8 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 		for (i = 0; i < dev->_audio_lines_count; i++) {
 			pos = file_offset;
 
-			vfs_read_retval =
-			    vfs_read(myfile, mybuf, line_size, &pos);
+			vfs_read_retval = vfs_read(myfile, mybuf, line_size,
+									&pos);
 
 			if (vfs_read_retval > 0 && vfs_read_retval == line_size
 			    && dev->_audiodata_buf_virt_addr != NULL) {
@@ -328,8 +326,8 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 		if (i > 0)
 			dev->_audioframe_count++;
 
-		dev->_audiofile_status =
-		    (vfs_read_retval == line_size) ? IN_PROGRESS : END_OF_FILE;
+		dev->_audiofile_status = (vfs_read_retval == line_size) ?
+						IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
 		filp_close(myfile, NULL);
@@ -340,8 +338,8 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 
 static void cx25821_audioups_handler(struct work_struct *work)
 {
-	struct cx25821_dev *dev =
-	    container_of(work, struct cx25821_dev, _audio_work_entry);
+	struct cx25821_dev *dev = container_of(work, struct cx25821_dev,
+			_audio_work_entry);
 
 	if (!dev) {
 		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
@@ -395,8 +393,8 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 			for (i = 0; i < dev->_audio_lines_count; i++) {
 				pos = offset;
 
-				vfs_read_retval =
-				    vfs_read(myfile, mybuf, line_size, &pos);
+				vfs_read_retval = vfs_read(myfile, mybuf,
+						line_size, &pos);
 
 				if (vfs_read_retval > 0 &&
 				    vfs_read_retval == line_size &&
@@ -423,8 +421,8 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 				break;
 		}
 
-		dev->_audiofile_status =
-		    (vfs_read_retval == line_size) ? IN_PROGRESS : END_OF_FILE;
+		dev->_audiofile_status = (vfs_read_retval == line_size) ?
+						IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
 		myfile->f_pos = 0;
@@ -444,9 +442,8 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 
 	cx25821_free_memory_audio(dev);
 
-	dev->_risc_virt_addr =
-	    pci_alloc_consistent(dev->pci, dev->audio_upstream_riscbuf_size,
-				 &dma_addr);
+	dev->_risc_virt_addr = pci_alloc_consistent(dev->pci,
+			dev->audio_upstream_riscbuf_size, &dma_addr);
 	dev->_risc_virt_start_addr = dev->_risc_virt_addr;
 	dev->_risc_phys_start_addr = dma_addr;
 	dev->_risc_phys_addr = dma_addr;
@@ -461,9 +458,8 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 	memset(dev->_risc_virt_addr, 0, dev->_audiorisc_size);
 
 	/* For Audio Data buffer allocation */
-	dev->_audiodata_buf_virt_addr =
-	    pci_alloc_consistent(dev->pci, dev->audio_upstream_databuf_size,
-				 &data_dma_addr);
+	dev->_audiodata_buf_virt_addr = pci_alloc_consistent(dev->pci,
+			dev->audio_upstream_databuf_size, &data_dma_addr);
 	dev->_audiodata_buf_phys_addr = data_dma_addr;
 	dev->_audiodata_buf_size = dev->audio_upstream_databuf_size;
 
@@ -480,9 +476,8 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 		return ret;
 
 	/* Creating RISC programs */
-	ret =
-	    cx25821_risc_buffer_upstream_audio(dev, dev->pci, bpl,
-					       dev->_audio_lines_count);
+	ret = cx25821_risc_buffer_upstream_audio(dev, dev->pci, bpl,
+						dev->_audio_lines_count);
 	if (ret < 0) {
 		printk(KERN_DEBUG
 			pr_fmt("ERROR creating audio upstream RISC programs!\n"));
@@ -661,9 +656,9 @@ int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
 
 	/* Set the input mode to 16-bit */
 	tmp = cx_read(sram_ch->aud_cfg);
-	tmp |=
-	    FLD_AUD_SRC_ENABLE | FLD_AUD_DST_PK_MODE | FLD_AUD_CLK_ENABLE |
-	    FLD_AUD_MASTER_MODE | FLD_AUD_CLK_SELECT_PLL_D | FLD_AUD_SONY_MODE;
+	tmp |= FLD_AUD_SRC_ENABLE | FLD_AUD_DST_PK_MODE | FLD_AUD_CLK_ENABLE |
+		FLD_AUD_MASTER_MODE | FLD_AUD_CLK_SELECT_PLL_D |
+		FLD_AUD_SONY_MODE;
 	cx_write(sram_ch->aud_cfg, tmp);
 
 	/* Read and write back the interrupt status register to clear it */
@@ -678,12 +673,11 @@ int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
 
-	err =
-	    request_irq(dev->pci->irq, cx25821_upstream_irq_audio,
+	err = request_irq(dev->pci->irq, cx25821_upstream_irq_audio,
 			IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
-		pr_err("%s: can't get upstream IRQ %d\n",
-		       dev->name, dev->pci->irq);
+		pr_err("%s: can't get upstream IRQ %d\n", dev->name,
+				dev->pci->irq);
 		goto fail_irq;
 	}
 
-- 
1.7.0.4


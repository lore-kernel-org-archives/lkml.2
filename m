Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab1IBD6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:58:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35020 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195Ab1IBD6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:58:13 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 10/19] Staging: cx25821: Fix obscure line endings in cx25821-audio-upstream.c
Date: Fri,  2 Sep 2011 11:55:38 +0800
Message-Id: <1314935747-6881-11-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. Rationale: more
readable.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   25 ++++++++--------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 55df658..e6c4b34 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -349,10 +349,8 @@ static void cx25821_audioups_handler(struct work_struct *work)
 		return;
 	}
 
-	cx25821_get_audio_data(dev,
-			      dev->channels[dev->
-				       _audio_upstream_channel].
-				       sram_channels);
+	cx25821_get_audio_data(dev, dev->channels[dev->_audio_upstream_channel].
+			sram_channels);
 }
 
 int cx25821_openfile_audio(struct cx25821_dev *dev,
@@ -555,8 +553,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 					}
 				}
 				/* Jump to 2nd Audio Frame */
-				*(rp++) =
-				    cpu_to_le32(RISC_JUMP | RISC_IRQ1 |
+				*(rp++) = cpu_to_le32(RISC_JUMP | RISC_IRQ1 |
 						RISC_CNT_RESET);
 				*(rp++) = cpu_to_le32(risc_phys_jump_addr);
 				*(rp++) = cpu_to_le32(0);
@@ -611,11 +608,8 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 
 	/* Only deal with our interrupt */
 	if (audio_status) {
-		handled =
-		    cx25821_audio_upstream_irq(dev,
-					       dev->
-					       _audio_upstream_channel,
-					       audio_status);
+		handled = cx25821_audio_upstream_irq(dev,
+				dev->_audio_upstream_channel, audio_status);
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
-- 
1.7.0.4


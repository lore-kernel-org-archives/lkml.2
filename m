Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1JVFs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1JVFsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:54 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/36] Staging: cx25821: cx25821-video-upstream.c: Remove braces
Date: Sat, 22 Oct 2011 13:43:46 +0800
Message-Id: <1319262236-6498-27-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete curly braces around single if-else statements.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video-upstream.c |   35 +++++++++-------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 14a6a6c..5daa4d5 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -326,16 +326,12 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 	if (dev->_file_status == END_OF_FILE)
 		return 0;
 
-	if (dev->_isNTSC) {
-		frame_size =
-		    (line_size ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_NTSC_Y411 :
-		    FRAME_SIZE_NTSC_Y422;
-	} else {
-		frame_size =
-		    (line_size ==
-		     Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
-	}
+	if (dev->_isNTSC)
+		frame_size = (line_size == Y411_LINE_SZ) ?
+			FRAME_SIZE_NTSC_Y411 : FRAME_SIZE_NTSC_Y422;
+	else
+		frame_size = (line_size == Y411_LINE_SZ) ?
+			FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
 
 	frame_offset = (frame_index_temp > 0) ? frame_size : 0;
 	file_offset = dev->_frame_count * frame_size;
@@ -507,10 +503,9 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 	dma_addr_t dma_addr;
 	dma_addr_t data_dma_addr;
 
-	if (dev->_dma_virt_addr != NULL) {
+	if (dev->_dma_virt_addr != NULL)
 		pci_free_consistent(dev->pci, dev->upstream_riscbuf_size,
-				    dev->_dma_virt_addr, dev->_dma_phys_addr);
-	}
+				dev->_dma_virt_addr, dev->_dma_phys_addr);
 
 	dev->_dma_virt_addr =
 	    pci_alloc_consistent(dev->pci, dev->upstream_riscbuf_size,
@@ -528,11 +523,10 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 	/* Clear memory at address */
 	memset(dev->_dma_virt_addr, 0, dev->_risc_size);
 
-	if (dev->_data_buf_virt_addr != NULL) {
+	if (dev->_data_buf_virt_addr != NULL)
 		pci_free_consistent(dev->pci, dev->upstream_databuf_size,
-				    dev->_data_buf_virt_addr,
-				    dev->_data_buf_phys_addr);
-	}
+				dev->_data_buf_virt_addr,
+				dev->_data_buf_phys_addr);
 	/* For Video Data buffer allocation */
 	dev->_data_buf_virt_addr =
 	    pci_alloc_consistent(dev->pci, dev->upstream_databuf_size,
@@ -672,10 +666,9 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 	vid_status = cx_read(sram_ch->int_stat);
 
 	/* Only deal with our interrupt */
-	if (vid_status) {
-		handled =
-		    cx25821_video_upstream_irq(dev, channel_num, vid_status);
-	}
+	if (vid_status)
+		handled = cx25821_video_upstream_irq(dev, channel_num,
+				vid_status);
 
 	if (handled < 0)
 		cx25821_stop_upstream_video_ch1(dev);
-- 
1.7.0.4


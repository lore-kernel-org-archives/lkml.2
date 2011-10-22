Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1JVFr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:47:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1JVFrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:47:23 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/36] Staging: cx25821: cx25821-core.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:33 +0800
Message-Id: <1319262236-6498-14-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-core.c |   48 ++++++++++++++------------------
 1 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index f8ead2a..4d99c3c 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -804,8 +804,8 @@ void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel_select,
 			      u32 format)
 {
 	if (channel_select <= 7 && channel_select >= 0) {
-		cx_write(dev->channels[channel_select].
-			sram_channels->pix_frmt, format);
+		cx_write(dev->channels[channel_select].sram_channels->pix_frmt,
+				format);
 		dev->channels[channel_select].pixel_formats = format;
 	}
 }
@@ -855,17 +855,15 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	}
 
 	cx25821_sram_channel_setup_audio(dev,
-				dev->channels[SRAM_CH08].sram_channels,
-				128, 0);
+			dev->channels[SRAM_CH08].sram_channels, 128, 0);
 
 	cx25821_gpio_init(dev);
 }
 
 static int cx25821_get_resources(struct cx25821_dev *dev)
 {
-	if (request_mem_region
-	    (pci_resource_start(dev->pci, 0), pci_resource_len(dev->pci, 0),
-	     dev->name))
+	if (request_mem_region(pci_resource_start(dev->pci, 0),
+				pci_resource_len(dev->pci, 0), dev->name))
 		return 0;
 
 	pr_err("%s: can't get MMIO memory @ 0x%llx\n",
@@ -972,8 +970,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	dev->lmmio = ioremap(dev->base_io_addr, pci_resource_len(dev->pci, 0));
 
 	if (!dev->lmmio) {
-		CX25821_ERR
-		    ("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
+		CX25821_ERR("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
 		cx25821_iounmap(dev);
 		return -ENOMEM;
 	}
@@ -1004,9 +1001,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	cx25821_video_register(dev);
 
 	/* register IOCTL device */
-	dev->ioctl_dev =
-	   cx25821_vdev_init(dev, dev->pci, &cx25821_videoioctl_template,
-			      "video");
+	dev->ioctl_dev = cx25821_vdev_init(dev, dev->pci,
+			&cx25821_videoioctl_template, "video");
 
 	if (video_register_device
 	    (dev->ioctl_dev, VFL_TYPE_GRABBER, VIDEO_IOCTL_CH) < 0) {
@@ -1103,16 +1099,15 @@ static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
 		}
 		if (bpl <= sg_dma_len(sg) - offset) {
 			/* fits into current chunk */
-			*(rp++) =
-			    cpu_to_le32(RISC_WRITE | RISC_SOL | RISC_EOL | bpl);
+			*(rp++) = cpu_to_le32(RISC_WRITE | RISC_SOL | RISC_EOL |
+					bpl);
 			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
 			*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 			offset += bpl;
 		} else {
 			/* scanline needs to be split */
 			todo = bpl;
-			*(rp++) =
-			    cpu_to_le32(RISC_WRITE | RISC_SOL |
+			*(rp++) = cpu_to_le32(RISC_WRITE | RISC_SOL |
 					(sg_dma_len(sg) - offset));
 			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
 			*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
@@ -1120,8 +1115,8 @@ static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
 			offset = 0;
 			sg++;
 			while (todo > sg_dma_len(sg)) {
-				*(rp++) =
-				    cpu_to_le32(RISC_WRITE | sg_dma_len(sg));
+				*(rp++) = cpu_to_le32(RISC_WRITE |
+						sg_dma_len(sg));
 				*(rp++) = cpu_to_le32(sg_dma_address(sg));
 				*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 				todo -= sg_dma_len(sg);
@@ -1160,8 +1155,8 @@ int cx25821_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	   can cause next bpl to start close to a page border.  First DMA
 	   region may be smaller than PAGE_SIZE */
 	/* write and jump need and extra dword */
-	instructions =
-	    fields * (1 + ((bpl + padding) * lines) / PAGE_SIZE + lines);
+	instructions = fields * (1 + ((bpl + padding) * lines) / PAGE_SIZE +
+			lines);
 	instructions += 2;
 	rc = btcx_riscmem_alloc(pci, risc, instructions * 12);
 
@@ -1215,8 +1210,8 @@ static __le32 *cx25821_risc_field_audio(__le32 * rp, struct scatterlist *sglist,
 
 		if (bpl <= sg_dma_len(sg) - offset) {
 			/* fits into current chunk */
-			*(rp++) =
-			    cpu_to_le32(RISC_WRITE | sol | RISC_EOL | bpl);
+			*(rp++) = cpu_to_le32(RISC_WRITE | sol | RISC_EOL |
+					bpl);
 			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
 			*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 			offset += bpl;
@@ -1339,8 +1334,8 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)
 				sram_channels->int_stat);
 
 			if (vid_status)
-				handled +=
-				cx25821_video_irq(dev, i, vid_status);
+				handled += cx25821_video_irq(dev, i,
+						vid_status);
 
 			cx_write(PCI_INT_STAT, mask[i]);
 		}
@@ -1427,9 +1422,8 @@ static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 		goto fail_irq;
 	}
 
-	err =
-	    request_irq(pci_dev->irq, cx25821_irq, IRQF_SHARED | IRQF_DISABLED,
-			dev->name, dev);
+	err = request_irq(pci_dev->irq, cx25821_irq,
+			IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n", dev->name, pci_dev->irq);
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0E0Jj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:39:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40886 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab0E0Jj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nOXwvsXJlVx9zuhHcNLjH7K8vCIZQum3i6D89YmN1ckpjM2ItBbTRb5O3sOsU4aBiT
         OrPIq3IVwh1zYcUOq9TL0Q/pqACDM5/xSW6FCejzjRhKAs1LXvKnyGqntd7MjIsNsfmA
         fP2vwREBWcOE1lFIu+f1baDO2SX8yOzk4Ihuo=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Bill Pemberton <wfp5p@virginia.edu>,
       Dirk Hohndel <hohndel@infradead.org>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Fixed long lines in gsc_hpdi.c
Date: Thu, 27 May 2010 17:39:15 +0800
Message-Id: <1274953155-7231-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some long line lengths in gsc_hpdi.c as found by the
checkpatch.pl tool

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/gsc_hpdi.c |   30 +++++++++++++++++++---------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 51f12bf..17c4f1f 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -311,17 +311,25 @@ struct hpdi_private {
 	void *plx9080_iobase;
 	void *hpdi_iobase;
 	uint32_t *dio_buffer[NUM_DMA_BUFFERS];	/*  dma buffers */
-	dma_addr_t dio_buffer_phys_addr[NUM_DMA_BUFFERS];	/*  physical addresses of dma buffers */
-	struct plx_dma_desc *dma_desc;	/*  array of dma descriptors read by plx9080, allocated to get proper alignment */
-	dma_addr_t dma_desc_phys_addr;	/*  physical address of dma descriptor array */
+	/* physical addresses of dma buffers */
+	dma_addr_t dio_buffer_phys_addr[NUM_DMA_BUFFERS];
+	/* array of dma descriptors read by plx9080, allocated to get proper
+	 * alignment */
+	struct plx_dma_desc *dma_desc;
+	/* physical address of dma descriptor array */
+	dma_addr_t dma_desc_phys_addr;
 	unsigned int num_dma_descriptors;
-	uint32_t *desc_dio_buffer[NUM_DMA_DESCRIPTORS];	/*  pointer to start of buffers indexed by descriptor */
-	volatile unsigned int dma_desc_index;	/*  index of the dma descriptor that is currently being used */
+	/* pointer to start of buffers indexed by descriptor */
+	uint32_t *desc_dio_buffer[NUM_DMA_DESCRIPTORS];
+	/* index of the dma descriptor that is currently being used */
+	volatile unsigned int dma_desc_index;
 	unsigned int tx_fifo_size;
 	unsigned int rx_fifo_size;
 	volatile unsigned long dio_count;
-	volatile uint32_t bits[24];	/*  software copies of values written to hpdi registers */
-	volatile unsigned int block_size;	/*  number of bytes at which to generate COMEDI_CB_BLOCK events */
+	/* software copies of values written to hpdi registers */
+	volatile uint32_t bits[24];
+	/* number of bytes at which to generate COMEDI_CB_BLOCK events */
+	volatile unsigned int block_size;
 	unsigned dio_config_output:1;
 };
 
@@ -570,7 +578,8 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 
 	pcidev = NULL;
-	for (i = 0; i < ARRAY_SIZE(hpdi_boards) && dev->board_ptr == NULL; i++) {
+	for (i = 0; i < ARRAY_SIZE(hpdi_boards) &&
+		    dev->board_ptr == NULL; i++) {
 		do {
 			pcidev = pci_get_subsys(PCI_VENDOR_ID_PLX,
 						hpdi_boards[i].device_id,
@@ -618,7 +627,7 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  remap, won't work with 2.0 kernels but who cares */
 	priv(dev)->plx9080_iobase = ioremap(priv(dev)->plx9080_phys_iobase,
 					    pci_resource_len(pcidev,
-							     PLX9080_BADDRINDEX));
+					    PLX9080_BADDRINDEX));
 	priv(dev)->hpdi_iobase =
 	    ioremap(priv(dev)->hpdi_phys_iobase,
 		    pci_resource_len(pcidev, HPDI_BADDRINDEX));
@@ -769,7 +778,8 @@ static int di_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and mutually
+	 * compatible */
 
 	/*  uniqueness check */
 	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE)
-- 
1.7.1


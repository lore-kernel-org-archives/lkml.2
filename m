Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0C0BuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:50:06 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:33801 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0C0BuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WCUjLq2a6HM78SWciJfa4w8BZh6rV4JIQDQusaAzQoGevQr+5wQh17rkkJIqt6oBn0
         9pZ01+pP8aeVQLv3B5QR5T2irYSl/sO1/TANPo88+I7EL9vsjN3yArkF0CTSsgL9EoyR
         2J0bGIWniDFBnYcE5jYHieX5FaXP5CB8xBcHU=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 8/9] Staging: comedi: cb_pcidas64: fixed multiple brace coding style issue
Date: Sat, 27 Mar 2010 09:48:42 +0800
Message-Id: <1269654523-2682-9-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   40 +++++++++++++-------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 82295e0..1d43d0d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1621,9 +1621,9 @@ int alloc_and_init_dma_members(struct comedi_device *dev)
 		priv(dev)->ai_buffer[i] =
 		    pci_alloc_consistent(priv(dev)->hw_dev, DMA_BUFFER_SIZE,
 					 &priv(dev)->ai_buffer_bus_addr[i]);
-		if (priv(dev)->ai_buffer[i] == NULL) {
+		if (priv(dev)->ai_buffer[i] == NULL)
 			return -ENOMEM;
-		}
+
 	}
 	for (i = 0; i < AO_DMA_RING_COUNT; i++) {
 		if (ao_cmd_is_supported(board(dev))) {
@@ -1632,9 +1632,9 @@ int alloc_and_init_dma_members(struct comedi_device *dev)
 						 DMA_BUFFER_SIZE,
 						 &priv(dev)->
 						 ao_buffer_bus_addr[i]);
-			if (priv(dev)->ao_buffer[i] == NULL) {
+			if (priv(dev)->ao_buffer[i] == NULL)
 				return -ENOMEM;
-			}
+
 		}
 	}
 	/*  allocate dma descriptors */
@@ -1643,9 +1643,9 @@ int alloc_and_init_dma_members(struct comedi_device *dev)
 				 sizeof(struct plx_dma_desc) *
 				 ai_dma_ring_count(board(dev)),
 				 &priv(dev)->ai_dma_desc_bus_addr);
-	if (priv(dev)->ai_dma_desc == NULL) {
+	if (priv(dev)->ai_dma_desc == NULL)
 		return -ENOMEM;
-	}
+
 	DEBUG_PRINT("ai dma descriptors start at bus addr 0x%x\n",
 		    priv(dev)->ai_dma_desc_bus_addr);
 	if (ao_cmd_is_supported(board(dev))) {
@@ -1654,9 +1654,9 @@ int alloc_and_init_dma_members(struct comedi_device *dev)
 					 sizeof(struct plx_dma_desc) *
 					 AO_DMA_RING_COUNT,
 					 &priv(dev)->ao_dma_desc_bus_addr);
-		if (priv(dev)->ao_dma_desc == NULL) {
+		if (priv(dev)->ao_dma_desc == NULL)
 			return -ENOMEM;
-		}
+
 		DEBUG_PRINT("ao dma descriptors start at bus addr 0x%x\n",
 			    priv(dev)->ao_dma_desc_bus_addr);
 	}
@@ -1848,9 +1848,9 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(" irq %u\n", dev->irq);
 
 	retval = setup_subdevices(dev);
-	if (retval < 0) {
+	if (retval < 0)
 		return retval;
-	}
+
 
 	return 0;
 }
@@ -1919,9 +1919,9 @@ static int detach(struct comedi_device *dev)
 						    priv(dev)->ao_dma_desc,
 						    priv(dev)->
 						    ao_dma_desc_bus_addr);
-			if (priv(dev)->main_phys_iobase) {
+			if (priv(dev)->main_phys_iobase)
 				comedi_pci_disable(priv(dev)->hw_dev);
-			}
+	
 			pci_dev_put(priv(dev)->hw_dev);
 		}
 	}
@@ -2902,9 +2902,9 @@ static void pio_drain_ai_fifo_16(struct comedi_device *dev)
 		if (cmd->stop_src == TRIG_COUNT) {
 			if (priv(dev)->ai_count == 0)
 				break;
-			if (num_samples > priv(dev)->ai_count) {
+			if (num_samples > priv(dev)->ai_count)
 				num_samples = priv(dev)->ai_count;
-			}
+
 			priv(dev)->ai_count -= num_samples;
 		}
 
@@ -2943,9 +2943,9 @@ static void pio_drain_ai_fifo_32(struct comedi_device *dev)
 	    readw(priv(dev)->main_iobase + ADC_READ_PNTR_REG) & 0x7fff;
 
 	if (cmd->stop_src == TRIG_COUNT) {
-		if (max_transfer > priv(dev)->ai_count) {
+		if (max_transfer > priv(dev)->ai_count)
 			max_transfer = priv(dev)->ai_count;
-		}
+
 	}
 	for (i = 0; read_code != write_code && i < max_transfer;) {
 		fifo_data = readl(priv(dev)->dio_counter_iobase + ADC_FIFO_REG);
@@ -2964,9 +2964,9 @@ static void pio_drain_ai_fifo_32(struct comedi_device *dev)
 /* empty fifo */
 static void pio_drain_ai_fifo(struct comedi_device *dev)
 {
-	if (board(dev)->layout == LAYOUT_4020) {
+	if (board(dev)->layout == LAYOUT_4020)
 		pio_drain_ai_fifo_32(dev);
-	} else
+	else
 		pio_drain_ai_fifo_16(dev);
 }
 
@@ -3038,9 +3038,9 @@ void handle_ai_interrupt(struct comedi_device *dev, unsigned short status,
 		       priv(dev)->plx9080_iobase + PLX_DMA1_CS_REG);
 		DEBUG_PRINT("dma1 status 0x%x\n", dma1_status);
 
-		if (dma1_status & PLX_DMA_EN_BIT) {
+		if (dma1_status & PLX_DMA_EN_BIT)
 			drain_dma_buffers(dev, 1);
-		}
+
 		DEBUG_PRINT(" cleared dma ch1 interrupt\n");
 	}
 	spin_unlock_irqrestore(&dev->spinlock, flags);
-- 
1.7.0.3


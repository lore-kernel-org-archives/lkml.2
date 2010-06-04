Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0FDMHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:07:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47105 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0FDMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=uUoZTbE1lLXGVpHQygF3jA5PFTqB1ItbTS09dNA7y13n8zeHIwE69vv1RQBV6DMbq8
         05QF4MDR3PAExS7dlXL0V1Zm+YgiwJXtG7t3X4F3k9LcrSLJEuSUAyMgS145boCa4Zoq
         lg51SKkrMM6Yj24w6yQwH667F8XLSGy0raZiw=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, stewart_r@aliencamel.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: fix printk() coding style issue in ni_labpc.c
Date: Fri,  4 Jun 2010 13:07:06 +0100
Message-Id: <1275653226-2589-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc.c file that fixes all, printk() should include KERN-facility level, warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   30 +++++++++++++++-------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index bf063ad..8b52466 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -526,7 +526,8 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	unsigned long dma_flags, isr_flags;
 	short lsb, msb;
 
-	printk("comedi%d: ni_labpc: %s, io 0x%lx", dev->minor, thisboard->name,
+	printk(KERN_ERR "comedi%d: ni_labpc: %s, io 0x%lx", dev->minor,
+								thisboard->name,
 	       iobase);
 	if (irq)
 		printk(", irq %u", irq);
@@ -543,7 +544,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		/* check if io addresses are available */
 		if (!request_region(iobase, LABPC_SIZE,
 				    driver_labpc.driver_name)) {
-			printk("I/O port conflict\n");
+			printk(KERN_ERR "I/O port conflict\n");
 			return -EIO;
 		}
 	}
@@ -575,7 +576,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 			isr_flags |= IRQF_SHARED;
 		if (request_irq(irq, labpc_interrupt, isr_flags,
 				driver_labpc.driver_name, dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			printk(KERN_ERR "unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
 	}
@@ -583,18 +584,18 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	/* grab dma channel */
 	if (dma_chan > 3) {
-		printk(" invalid dma channel %u\n", dma_chan);
+		printk(KERN_ERR " invalid dma channel %u\n", dma_chan);
 		return -EINVAL;
 	} else if (dma_chan) {
 		/* allocate dma buffer */
 		devpriv->dma_buffer =
 		    kmalloc(dma_buffer_size, GFP_KERNEL | GFP_DMA);
 		if (devpriv->dma_buffer == NULL) {
-			printk(" failed to allocate dma buffer\n");
+			printk(KERN_ERR " failed to allocate dma buffer\n");
 			return -ENOMEM;
 		}
 		if (request_dma(dma_chan, driver_labpc.driver_name)) {
-			printk(" failed to allocate dma channel %u\n",
+			printk(KERN_ERR " failed to allocate dma channel %u\n",
 			       dma_chan);
 			return -EINVAL;
 		}
@@ -690,7 +691,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		for (i = 0; i < EEPROM_SIZE; i++)
 			devpriv->eeprom_data[i] = labpc_eeprom_read(dev, i);
 #ifdef LABPC_DEBUG
-		printk(" eeprom:");
+		printk(KERN_ERR " eeprom:");
 		for (i = 0; i < EEPROM_SIZE; i++)
 			printk(" %i:0x%x ", i, devpriv->eeprom_data[i]);
 		printk("\n");
@@ -732,7 +733,8 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		iobase = (unsigned long)devpriv->mite->daq_io_addr;
 		irq = mite_irq(devpriv->mite);
 #else
-		printk(" this driver has not been built with PCI support.\n");
+		printk(KERN_ERR " this driver has not been built with PCI "
+								"support.\n");
 		return -EINVAL;
 #endif
 		break;
@@ -743,7 +745,7 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EINVAL;
 		break;
 	default:
-		printk("bug! couldn't determine board type\n");
+		printk(KERN_ERR "bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
@@ -777,7 +779,7 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 			}
 		}
 	}
-	printk("no device found\n");
+	printk(KERN_ERR "no device found\n");
 	mite_list_devices();
 	return -EIO;
 }
@@ -785,7 +787,7 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 
 int labpc_common_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: ni_labpc: detach\n", dev->minor);
+	printk(KERN_ERR "comedi%d: ni_labpc: detach\n", dev->minor);
 
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
@@ -847,7 +849,7 @@ static enum scan_mode labpc_ai_scan_mode(const struct comedi_cmd *cmd)
 	if (CR_CHAN(cmd->chanlist[0]) > CR_CHAN(cmd->chanlist[1]))
 		return MODE_MULT_CHAN_DOWN;
 
-	printk("ni_labpc: bug! this should never happen\n");
+	printk(KERN_ERR "ni_labpc: bug! this should never happen\n");
 
 	return 0;
 }
@@ -910,7 +912,7 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 			}
 			break;
 		default:
-			printk("ni_labpc: bug! in chanlist check\n");
+			printk(KERN_ERR "ni_labpc: bug! in chanlist check\n");
 			return 1;
 			break;
 		}
@@ -1759,7 +1761,7 @@ static int labpc_eeprom_write_insn(struct comedi_device *dev,
 
 	/*  only allow writes to user area of eeprom */
 	if (channel < 16 || channel > 127) {
-		printk("eeprom writes are only allowed to "
+		printk(KERN_ERR "eeprom writes are only allowed to "
 						"channels 16 through 127 "
 						"(the pointer and user areas)");
 		return -EINVAL;
-- 
1.7.0.4


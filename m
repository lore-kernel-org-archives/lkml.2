Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1JMNLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:11:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58699 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1JMNLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:11:15 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 6/6] Staging: comedi: fix printk issue in ni_pcimio.c
Date: Thu, 13 Oct 2011 18:40:28 +0530
Message-Id: <1318511428-3778-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

converted printks to pr_<level>
Remove unnecessary printks and Fixed a brace warning issue.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_pcimio.c |   37 ++++++++++++----------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 9148abd..ae76f57 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1470,8 +1470,8 @@ static void m_series_stc_writew(struct comedi_device *dev, uint16_t data,
 		/* FIXME: DIO_Output_Register (16 bit reg) is replaced by M_Offset_Static_Digital_Output (32 bit)
 		   and M_Offset_SCXI_Serial_Data_Out (8 bit) */
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		pr_warn("%s: bug! unhandled register=0x%x in switch.\n",
+			__func__, reg);
 		BUG();
 		return;
 		break;
@@ -1505,8 +1505,8 @@ static uint16_t m_series_stc_readw(struct comedi_device *dev, int reg)
 		offset = M_Offset_G01_Status;
 		break;
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		pr_warn("%s: bug! unhandled register=0x%x in switch.\n",
+			__func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -1547,8 +1547,8 @@ static void m_series_stc_writel(struct comedi_device *dev, uint32_t data,
 		offset = M_Offset_G1_Load_B;
 		break;
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		pr_warn("%s: bug! unhandled register=0x%x in switch.\n",
+			__func__, reg);
 		BUG();
 		return;
 		break;
@@ -1573,8 +1573,8 @@ static uint32_t m_series_stc_readl(struct comedi_device *dev, int reg)
 		offset = M_Offset_G1_Save;
 		break;
 	default:
-		printk("%s: bug! unhandled register=0x%x in switch.\n",
-		       __func__, reg);
+		pr_warn("%s: bug! unhandled register=0x%x in switch.\n",
+			__func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -1632,9 +1632,8 @@ static void m_series_init_eeprom_buffer(struct comedi_device *dev)
 	}
 	devpriv->serial_number = be32_to_cpu(devpriv->serial_number);
 
-	for (i = 0; i < M_SERIES_EEPROM_SIZE; ++i) {
+	for (i = 0; i < M_SERIES_EEPROM_SIZE; ++i)
 		devpriv->eeprom_buffer[i] = ni_readb(Start_Cal_EEPROM + i);
-	}
 
 	writel(old_iodwbsr1_bits, devpriv->mite->mite_io_addr + MITE_IODWBSR_1);
 	writel(old_iodwbsr_bits, devpriv->mite->mite_io_addr + MITE_IODWBSR);
@@ -1665,9 +1664,8 @@ static void init_6143(struct comedi_device *dev)
 static int pcimio_detach(struct comedi_device *dev)
 {
 	mio_common_detach(dev);
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
 	if (dev->private) {
 		mite_free_ring(devpriv->ai_mite_ring);
 		mite_free_ring(devpriv->ao_mite_ring);
@@ -1684,9 +1682,6 @@ static int pcimio_detach(struct comedi_device *dev)
 static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
-
-	printk("comedi%d: ni_pcimio:", dev->minor);
-
 	ret = ni_alloc_private(dev);
 	if (ret < 0)
 		return ret;
@@ -1695,7 +1690,7 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	printk(" %s", boardtype.name);
+	pr_debug("%s\n", boardtype.name);
 	dev->board_name = boardtype.name;
 
 	if (boardtype.reg_type & ni_reg_m_series_mask) {
@@ -1712,7 +1707,7 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	ret = mite_setup(devpriv->mite);
 	if (ret < 0) {
-		printk(" error setting up mite\n");
+		pr_warn("error setting up mite\n");
 		return ret;
 	}
 	comedi_set_hw_dev(dev, &devpriv->mite->pcidev->dev);
@@ -1740,13 +1735,13 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->irq = mite_irq(devpriv->mite);
 
 	if (dev->irq == 0) {
-		printk(" unknown irq (bad)\n");
+		pr_warn("unknown irq (bad)\n");
 	} else {
-		printk(" ( irq = %u )", dev->irq);
+		pr_debug("( irq = %u )\n", dev->irq);
 		ret = request_irq(dev->irq, ni_E_interrupt, NI_E_IRQ_FLAGS,
 				  DRV_NAME, dev);
 		if (ret < 0) {
-			printk(" irq not available\n");
+			pr_warn("irq not available\n");
 			dev->irq = 0;
 		}
 	}
@@ -1787,7 +1782,7 @@ static int pcimio_find_device(struct comedi_device *dev, int bus, int slot)
 			}
 		}
 	}
-	printk("no device found\n");
+	pr_err("no device found\n");
 	mite_list_devices();
 	return -EIO;
 }
-- 
1.7.6.4


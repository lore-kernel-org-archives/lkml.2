Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1JJFmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:42:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1JJFmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:42:44 -0400
From: Pelle Windestam <pelle@windestam.se>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Pelle Windestam <pelle@windestam.se>
Subject: [PATCH 1/1] drivers: staging: rts_pstor fixed checkpatch warnings
Date: Mon, 10 Oct 2011 07:42:17 +0200
Message-Id: <1318225337-25438-1-git-send-email-pelle@windestam.se>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warnings in rtsx.c/.h, mostly braces and spaces
before tabs issues. Also fixed warning about not using
DEFINE_PCI_DEVICE_TABLE(...) macro.

Signed-off-by: Pelle Windestam <pelle@windestam.se>
---
 drivers/staging/rts_pstor/rtsx.c |   65 +++++++++++++++++++++----------------
 drivers/staging/rts_pstor/rtsx.h |   10 +++---
 2 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 16c73fb..64fda1c 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -36,7 +36,7 @@
 #include "sd.h"
 #include "xd.h"
 
-#define DRIVER_VERSION 		"v1.10"
+#define DRIVER_VERSION "v1.10"
 
 MODULE_DESCRIPTION("Realtek PCI-Express card reader driver");
 MODULE_LICENSE("GPL");
@@ -77,7 +77,7 @@ static const char *host_info(struct Scsi_Host *host)
 	return "SCSI emulation for PCI-Express Mass Storage devices";
 }
 
-static int slave_alloc (struct scsi_device *sdev)
+static int slave_alloc(struct scsi_device *sdev)
 {
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -130,7 +130,7 @@ static int slave_configure(struct scsi_device *sdev)
 #define SPRINTF(args...) \
 	do { if (pos < buffer+length) pos += sprintf(pos, ## args); } while (0)
 
-static int proc_info (struct Scsi_Host *host, char *buffer,
+static int proc_info(struct Scsi_Host *host, char *buffer,
 		char **start, off_t offset, int length, int inout)
 {
 	char *pos = buffer;
@@ -506,13 +506,15 @@ static int rtsx_control_thread(void *__dev)
 		 */
 		else if (chip->srb->device->id) {
 			printk(KERN_ERR "Bad target number (%d:%d)\n",
-				  chip->srb->device->id, chip->srb->device->lun);
+				chip->srb->device->id,
+				chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
 			printk(KERN_ERR "Bad LUN (%d:%d)\n",
-				  chip->srb->device->id, chip->srb->device->lun);
+				chip->srb->device->id,
+				chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
@@ -625,26 +627,23 @@ static irqreturn_t rtsx_interrupt(int irq, void *dev_id)
 	int retval;
 	u32 status;
 
-	if (dev) {
+	if (dev)
 		chip = dev->chip;
-	} else {
+	else
 		return IRQ_NONE;
-	}
 
-	if (!chip) {
+	if (!chip)
 		return IRQ_NONE;
-	}
 
 	spin_lock(&dev->reg_lock);
 
 	retval = rtsx_pre_handle_interrupt(chip);
 	if (retval == STATUS_FAIL) {
 		spin_unlock(&dev->reg_lock);
-		if (chip->int_reg == 0xFFFFFFFF) {
+		if (chip->int_reg == 0xFFFFFFFF)
 			return IRQ_HANDLED;
-		} else {
+		else
 			return IRQ_NONE;
-		}
 	}
 
 	status = chip->int_reg;
@@ -661,9 +660,8 @@ static irqreturn_t rtsx_interrupt(int irq, void *dev_id)
 
 	if (status & (NEED_COMPLETE_INT | DELINK_INT)) {
 		if (status & (TRANS_FAIL_INT | DELINK_INT)) {
-			if (status & DELINK_INT) {
+			if (status & DELINK_INT)
 				RTSX_SET_DELINK(chip);
-			}
 			dev->trans_result = TRANS_RESULT_FAIL;
 			if (dev->done)
 				complete(dev->done);
@@ -844,7 +842,9 @@ static void rtsx_init_options(struct rtsx_chip *chip)
 	chip->ssc_en = 1;
 	chip->sd_speed_prior = 0x01040203;
 	chip->sd_current_prior = 0x00010203;
-	chip->sd_ctl = SD_PUSH_POINT_AUTO | SD_SAMPLE_POINT_AUTO | SUPPORT_MMC_DDR_MODE;
+	chip->sd_ctl = SD_PUSH_POINT_AUTO |
+		       SD_SAMPLE_POINT_AUTO |
+		       SUPPORT_MMC_DDR_MODE;
 	chip->sd_ddr_tx_phase = 0;
 	chip->mmc_ddr_tx_phase = 1;
 	chip->sd_default_tx_phase = 15;
@@ -896,7 +896,8 @@ static void rtsx_init_options(struct rtsx_chip *chip)
 	chip->s3_pwr_off_delay = 1000;
 }
 
-static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+static int __devinit rtsx_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	struct Scsi_Host *host;
 	struct rtsx_dev *dev;
@@ -913,7 +914,8 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 
 	err = pci_request_regions(pci, CR_DRIVER_NAME);
 	if (err < 0) {
-		printk(KERN_ERR "PCI request regions for %s failed!\n", CR_DRIVER_NAME);
+		printk(KERN_ERR "PCI request regions for %s failed!\n",
+		       CR_DRIVER_NAME);
 		pci_disable_device(pci);
 		return err;
 	}
@@ -934,9 +936,8 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 	memset(dev, 0, sizeof(struct rtsx_dev));
 
 	dev->chip = kzalloc(sizeof(struct rtsx_chip), GFP_KERNEL);
-	if (dev->chip == NULL) {
+	if (dev->chip == NULL)
 		goto errout;
-	}
 
 	spin_lock_init(&dev->reg_lock);
 	mutex_init(&(dev->dev_mutex));
@@ -950,7 +951,8 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 	dev->pci = pci;
 	dev->irq = -1;
 
-	printk(KERN_INFO "Resource length: 0x%x\n", (unsigned int)pci_resource_len(pci, 0));
+	printk(KERN_INFO "Resource length: 0x%x\n",
+	       (unsigned int)pci_resource_len(pci, 0));
 	dev->addr = pci_resource_start(pci, 0);
 	dev->remap_addr = ioremap_nocache(dev->addr, pci_resource_len(pci, 0));
 	if (dev->remap_addr == NULL) {
@@ -959,9 +961,12 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 		goto errout;
 	}
 
-	/* Using "unsigned long" cast here to eliminate gcc warning in 64-bit system */
+	/*
+	 * Using "unsigned long" cast here to eliminate gcc warning in
+	 * 64-bit system
+	 */
 	printk(KERN_INFO "Original address: 0x%lx, remapped address: 0x%lx\n",
-			(unsigned long)(dev->addr), (unsigned long)(dev->remap_addr));
+	       (unsigned long)(dev->addr), (unsigned long)(dev->remap_addr));
 
 	dev->rtsx_resv_buf = dma_alloc_coherent(&(pci->dev), RTSX_RESV_BUF_LEN,
 			&(dev->rtsx_resv_buf_addr), GFP_KERNEL);
@@ -973,7 +978,8 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 	dev->chip->host_cmds_ptr = dev->rtsx_resv_buf;
 	dev->chip->host_cmds_addr = dev->rtsx_resv_buf_addr;
 	dev->chip->host_sg_tbl_ptr = dev->rtsx_resv_buf + HOST_CMDS_BUF_LEN;
-	dev->chip->host_sg_tbl_addr = dev->rtsx_resv_buf_addr + HOST_CMDS_BUF_LEN;
+	dev->chip->host_sg_tbl_addr = dev->rtsx_resv_buf_addr +
+				      HOST_CMDS_BUF_LEN;
 
 	dev->chip->rtsx = dev;
 
@@ -1058,10 +1064,13 @@ static void __devexit rtsx_remove(struct pci_dev *pci)
 }
 
 /* PCI IDs */
-static struct pci_device_id rtsx_ids[] = {
-	{ 0x10EC, 0x5208, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
-	{ 0x10EC, 0x5209, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
-	{ 0x10EC, 0x5288, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
+static DEFINE_PCI_DEVICE_TABLE(rtsx_ids) = {
+	{ 0x10EC, 0x5208, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ 0x10EC, 0x5209, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ 0x10EC, 0x5288, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, },
 };
 
diff --git a/drivers/staging/rts_pstor/rtsx.h b/drivers/staging/rts_pstor/rtsx.h
index 86e47c2..1ab42fc 100644
--- a/drivers/staging/rts_pstor/rtsx.h
+++ b/drivers/staging/rts_pstor/rtsx.h
@@ -24,8 +24,8 @@
 #ifndef __REALTEK_RTSX_H
 #define __REALTEK_RTSX_H
 
-#include <asm/io.h>
-#include <asm/bitops.h>
+#include <linux/io.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -80,7 +80,7 @@
 
 #define wait_timeout_x(task_state, msecs)		\
 do {							\
-		set_current_state((task_state)); 	\
+		set_current_state((task_state));	\
 		schedule_timeout((msecs) * HZ / 1000);	\
 } while (0)
 #define wait_timeout(msecs)	wait_timeout_x(TASK_INTERRUPTIBLE, (msecs))
@@ -102,12 +102,12 @@ typedef unsigned long DELAY_PARA_T;
 struct rtsx_chip;
 
 struct rtsx_dev {
-	struct pci_dev 		*pci;
+	struct pci_dev *pci;
 
 	/* pci resources */
 	unsigned long 		addr;
 	void __iomem 		*remap_addr;
-	int 			irq;
+	int irq;
 
 	/* locks */
 	spinlock_t 		reg_lock;
-- 
1.7.3.4


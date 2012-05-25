Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2EYLIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:08:35 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:46348 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751912Ab2EYLId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:08:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAIZnv09bdWOb/2dsb2JhbABEtSOBB4JDQBKBPhOIEbs4kEcDlRiJHoZSgmI
X-IronPort-AV: E=Sophos;i="4.75,656,1330902000"; 
   d="scan'208";a="995316720"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: ipack/bridges/tpci200: change pr_* usage for dev_* functions
Date: Fri, 25 May 2012 13:08:12 +0200
Message-Id: <1337944093-16963-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |  126 +++++++++++++++++--------------
 1 file changed, 70 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 46127bc..c39499a 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -11,8 +11,6 @@
  * Software Foundation; version 2 of the License.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include "tpci200.h"
 
@@ -36,10 +34,8 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	struct tpci200_board *tpci200;
 	int found = 0;
 
-	if (dev == NULL) {
-		pr_info("Slot doesn't exist.\n");
+	if (dev == NULL)
 		return NULL;
-	}
 
 	list_for_each_entry(tpci200, &tpci200_list, list) {
 		if (tpci200->number == dev->bus_nr) {
@@ -49,13 +45,14 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	}
 
 	if (!found) {
-		pr_err("Carrier not found\n");
+		dev_err(&dev->dev, "Carrier not found\n");
 		return NULL;
 	}
 
 	if (dev->slot >= TPCI200_NB_SLOT) {
-		pr_info("Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
-			dev->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
+		dev_info(&dev->dev,
+			 "Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
+			 dev->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
 		return NULL;
 	}
 
@@ -116,14 +113,15 @@ static struct ipack_addr_space *get_slot_address_space(struct ipack_device *dev,
 		addr = &dev->mem_space;
 		break;
 	default:
-		pr_err("Slot [%d:%d] space number %d doesn't exist !\n",
-		       dev->bus_nr, dev->slot, space);
+		dev_err(&dev->dev,
+			"Slot [%d:%d] space number %d doesn't exist !\n",
+			dev->bus_nr, dev->slot, space);
 		return NULL;
 		break;
 	}
 
 	if ((addr->size == 0) || (addr->address == NULL)) {
-		pr_err("Error, slot space not mapped !\n");
+		dev_err(&dev->dev, "Error, slot space not mapped !\n");
 		return NULL;
 	}
 
@@ -145,7 +143,7 @@ static int tpci200_read8(struct ipack_device *dev, int space,
 		return -EINVAL;
 
 	if (offset >= addr->size) {
-		pr_err("Error, slot space offset error !\n");
+		dev_err(&dev->dev, "Error, slot space offset error !\n");
 		return -EFAULT;
 	}
 
@@ -169,7 +167,7 @@ static int tpci200_read16(struct ipack_device *dev, int space,
 		return -EINVAL;
 
 	if ((offset+2) >= addr->size) {
-		pr_err("Error, slot space offset error !\n");
+		dev_err(&dev->dev, "Error, slot space offset error !\n");
 		return -EFAULT;
 	}
 	*value = __tpci200_read16(addr->address, offset);
@@ -192,7 +190,7 @@ static int tpci200_read32(struct ipack_device *dev, int space,
 		return -EINVAL;
 
 	if ((offset+4) >= addr->size) {
-		pr_err("Error, slot space offset error !\n");
+		dev_err(&dev->dev, "Error, slot space offset error !\n");
 		return -EFAULT;
 	}
 
@@ -216,7 +214,7 @@ static int tpci200_write8(struct ipack_device *dev, int space,
 		return -EINVAL;
 
 	if (offset >= addr->size) {
-		pr_err("Error, slot space offset error !\n");
+		dev_err(&dev->dev, "Error, slot space offset error !\n");
 		return -EFAULT;
 	}
 
@@ -240,7 +238,7 @@ static int tpci200_write16(struct ipack_device *dev, int space,
 		return -EINVAL;
 
 	if ((offset+2) >= addr->size) {
-		pr_err("Error, slot space offset error !\n");
+		dev_err(&dev->dev, "Error, slot space offset error !\n");
 		return -EFAULT;
 	}
 
@@ -264,7 +262,7 @@ static int tpci200_write32(struct ipack_device *dev, int space,
 		return -EINVAL;
 
 	if ((offset+4) >= addr->size) {
-		pr_err("Error, slot space offset error !\n");
+		dev_err(&dev->dev, "Error, slot space offset error !\n");
 		return -EFAULT;
 	}
 
@@ -338,8 +336,9 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	if (unhandled_ints) {
 		for (i = 0; i < TPCI200_NB_SLOT; i++) {
 			if (unhandled_ints & ((TPCI200_INT0_EN | TPCI200_INT1_EN) << (2*i))) {
-				pr_info("No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
-					tpci200->number, i);
+				dev_info(&tpci200->slots[i].dev->dev,
+					 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
+					 tpci200->number, i);
 				reg_value = readw(
 					tpci200->info->interface_regs +
 					control_reg[i]);
@@ -371,9 +370,10 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	res = pci_request_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR,
 				 "Carrier IP interface registers");
 	if (res) {
-		pr_err("(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
-		       tpci200->info->pdev->bus->number,
-		       tpci200->info->pdev->devfn);
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
 		goto out_disable_pci;
 	}
 
@@ -382,9 +382,10 @@ static int tpci200_register(struct tpci200_board *tpci200)
 				 TPCI200_IO_ID_INT_SPACES_BAR,
 				 "Carrier IO ID INT space");
 	if (res) {
-		pr_err("(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
-		       tpci200->info->pdev->bus->number,
-		       tpci200->info->pdev->devfn);
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
 		goto out_release_ip_space;
 	}
 
@@ -392,9 +393,10 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	res = pci_request_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR,
 				 "Carrier MEM space");
 	if (res) {
-		pr_err("(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
-		       tpci200->info->pdev->bus->number,
-		       tpci200->info->pdev->devfn);
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
 		goto out_release_ioid_int_space;
 	}
 
@@ -452,9 +454,10 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			  tpci200_interrupt, IRQF_SHARED,
 			  KBUILD_MODNAME, (void *) tpci200);
 	if (res) {
-		pr_err("(bn 0x%X, sn 0x%X) unable to register IRQ !",
-		       tpci200->info->pdev->bus->number,
-		       tpci200->info->pdev->devfn);
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) unable to register IRQ !",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
 		goto out_release_ioid_int_space;
 	}
 
@@ -555,31 +558,35 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 	switch (space) {
 	case IPACK_IO_SPACE:
 		if (dev->io_space.address == NULL) {
-			pr_info("Slot [%d:%d] IO space not mapped !\n",
-				dev->bus_nr, dev->slot);
+			dev_info(&dev->dev,
+				 "Slot [%d:%d] IO space not mapped !\n",
+				 dev->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->io_space;
 		break;
 	case IPACK_ID_SPACE:
 		if (dev->id_space.address == NULL) {
-			pr_info("Slot [%d:%d] ID space not mapped !\n",
-				dev->bus_nr, dev->slot);
+			dev_info(&dev->dev,
+				 "Slot [%d:%d] ID space not mapped !\n",
+				 dev->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->id_space;
 		break;
 	case IPACK_MEM_SPACE:
 		if (dev->mem_space.address == NULL) {
-			pr_info("Slot [%d:%d] MEM space not mapped !\n",
-				dev->bus_nr, dev->slot);
+			dev_info(&dev->dev,
+				 "Slot [%d:%d] MEM space not mapped !\n",
+				 dev->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->mem_space;
 		break;
 	default:
-		pr_err("Slot [%d:%d] space number %d doesn't exist !\n",
-		       dev->bus_nr, dev->slot, space);
+		dev_err(&dev->dev,
+			"Slot [%d:%d] space number %d doesn't exist !\n",
+			dev->bus_nr, dev->slot, space);
 		mutex_unlock(&tpci200->mutex);
 		return -EINVAL;
 	}
@@ -639,8 +646,9 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 	switch (space) {
 	case IPACK_IO_SPACE:
 		if (dev->io_space.address != NULL) {
-			pr_err("Slot [%d:%d] IO space already mapped !\n",
-			       tpci200->number, dev->slot);
+			dev_err(&dev->dev,
+				"Slot [%d:%d] IO space already mapped !\n",
+				tpci200->number, dev->slot);
 			res = -EINVAL;
 			goto out_unlock;
 		}
@@ -651,8 +659,9 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		break;
 	case IPACK_ID_SPACE:
 		if (dev->id_space.address != NULL) {
-			pr_err("Slot [%d:%d] ID space already mapped !\n",
-			       tpci200->number, dev->slot);
+			dev_err(&dev->dev,
+				"Slot [%d:%d] ID space already mapped !\n",
+				tpci200->number, dev->slot);
 			res = -EINVAL;
 			goto out_unlock;
 		}
@@ -663,17 +672,19 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		break;
 	case IPACK_MEM_SPACE:
 		if (dev->mem_space.address != NULL) {
-			pr_err("Slot [%d:%d] MEM space already mapped !\n",
-			       tpci200->number, dev->slot);
+			dev_err(&dev->dev,
+				"Slot [%d:%d] MEM space already mapped !\n",
+				tpci200->number, dev->slot);
 			res = -EINVAL;
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->mem_space;
 
 		if (memory_size > tpci200->slots[dev->slot].mem_phys.size) {
-			pr_err("Slot [%d:%d] request is 0x%X memory, only 0x%X available !\n",
-			       dev->bus_nr, dev->slot, memory_size,
-			       tpci200->slots[dev->slot].mem_phys.size);
+			dev_err(&dev->dev,
+				"Slot [%d:%d] request is 0x%X memory, only 0x%X available !\n",
+				dev->bus_nr, dev->slot, memory_size,
+				tpci200->slots[dev->slot].mem_phys.size);
 			res = -EINVAL;
 			goto out_unlock;
 		}
@@ -682,8 +693,8 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		size_to_map = memory_size;
 		break;
 	default:
-		pr_err("Slot [%d:%d] space %d doesn't exist !\n",
-		       tpci200->number, dev->slot, space);
+		dev_err(&dev->dev, "Slot [%d:%d] space %d doesn't exist !\n",
+			tpci200->number, dev->slot, space);
 		res = -EINVAL;
 		goto out_unlock;
 		break;
@@ -718,16 +729,18 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	}
 
 	if (tpci200->slots[dev->slot].irq != NULL) {
-		pr_err("Slot [%d:%d] IRQ already registered !\n", dev->bus_nr,
-		       dev->slot);
+		dev_err(&dev->dev,
+			"Slot [%d:%d] IRQ already registered !\n", dev->bus_nr,
+			dev->slot);
 		res = -EINVAL;
 		goto out_unlock;
 	}
 
 	slot_irq = kzalloc(sizeof(struct slot_irq), GFP_KERNEL);
 	if (slot_irq == NULL) {
-		pr_err("Slot [%d:%d] unable to allocate memory for IRQ !\n",
-		       dev->bus_nr, dev->slot);
+		dev_err(&dev->dev,
+			"Slot [%d:%d] unable to allocate memory for IRQ !\n",
+			dev->bus_nr, dev->slot);
 		res = -ENOMEM;
 		goto out_unlock;
 	}
@@ -824,7 +837,7 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	/* register the device and initialize it */
 	ret = tpci200_install(tpci200);
 	if (ret) {
-		pr_err("Error during tpci200 install !\n");
+		dev_err(&pdev->dev, "Error during tpci200 install !\n");
 		kfree(tpci200->info);
 		kfree(tpci200);
 		return -ENODEV;
@@ -835,7 +848,8 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 						      TPCI200_NB_SLOT,
 						      &tpci200_bus_ops);
 	if (!tpci200->info->ipack_bus) {
-		pr_err("error registering the carrier on ipack driver\n");
+		dev_err(&pdev->dev,
+			"error registering the carrier on ipack driver\n");
 		tpci200_uninstall(tpci200);
 		kfree(tpci200->info);
 		kfree(tpci200);
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967852Ab2ERJLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:11:21 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:39870 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967112Ab2ERJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:10:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABMRtk9bdWOb/2dsb2JhbABFs2eBB4IWAQUnUhBRVwYTiBK8FJBFA5UgiSKGU4Jr
X-IronPort-AV: E=Sophos;i="4.75,616,1330902000"; 
   d="scan'208";a="915536503"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Staging ipack/bridges/tpci200: remove TPCI200_SHORTNAME constant
Date: Fri, 18 May 2012 11:10:07 +0200
Message-Id: <1337332208-26057-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed TPCI200_SHORTNAME. For the pr_* the name of the module is already
included due to pr_fmt declaration.

In other cases, KBUILD_MODNAME is used instead.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   70 +++++++++++++++----------------
 drivers/staging/ipack/bridges/tpci200.h |    2 -
 2 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index b460587..c043345 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -54,16 +54,15 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	}
 
 	if (dev->slot >= TPCI200_NB_SLOT) {
-		pr_info("Slot [%s %d:%d] doesn't exist! Last tpci200 slot is %d.\n",
-			TPCI200_SHORTNAME, dev->bus_nr, dev->slot,
-			TPCI200_NB_SLOT-1);
+		pr_info("Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
+			dev->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
 		return NULL;
 	}
 
 	BUG_ON(tpci200->slots == NULL);
 	if (tpci200->slots[dev->slot].dev == NULL) {
-		pr_info("Slot [%s %d:%d] is not registered !\n",
-			TPCI200_SHORTNAME, dev->bus_nr, dev->slot);
+		pr_info("Slot [%d:%d] is not registered !\n", dev->bus_nr,
+			dev->slot);
 		return NULL;
 	}
 
@@ -124,8 +123,8 @@ static struct ipack_addr_space *get_slot_address_space(struct ipack_device *dev,
 		addr = &dev->mem_space;
 		break;
 	default:
-		pr_err("Slot [%s %d:%d] space number %d doesn't exist !\n",
-		       TPCI200_SHORTNAME, dev->bus_nr, dev->slot, space);
+		pr_err("Slot [%d:%d] space number %d doesn't exist !\n",
+		       dev->bus_nr, dev->slot, space);
 		return NULL;
 		break;
 	}
@@ -350,8 +349,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	if (unhandled_ints) {
 		for (i = 0; i < TPCI200_NB_SLOT; i++) {
 			if (unhandled_ints & ((TPCI200_INT0_EN | TPCI200_INT1_EN) << (2*i))) {
-				pr_info("No registered ISR for slot [%s %d:%d]!. IRQ will be disabled.\n",
-					TPCI200_SHORTNAME,
+				pr_info("No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 					tpci200->number, i);
 				reg_value = readw(
 					(void __iomem *)(tpci200->info->interface_regs +
@@ -391,8 +389,8 @@ static struct ipack_device *tpci200_slot_register(unsigned int tpci200_number,
 	}
 
 	if (slot_position >= TPCI200_NB_SLOT) {
-		pr_info("Slot [%s %d:%d] doesn't exist!\n",
-			TPCI200_SHORTNAME, tpci200_number, slot_position);
+		pr_info("Slot [%d:%d] doesn't exist!\n", tpci200_number,
+			slot_position);
 		return NULL;
 	}
 
@@ -400,8 +398,8 @@ static struct ipack_device *tpci200_slot_register(unsigned int tpci200_number,
 		return NULL;
 
 	if (tpci200->slots[slot_position].dev != NULL) {
-		pr_err("Slot [%s %d:%d] already installed !\n",
-		       TPCI200_SHORTNAME, tpci200_number, slot_position);
+		pr_err("Slot [%d:%d] already installed !\n", tpci200_number,
+		       slot_position);
 		goto err_unlock;
 	}
 
@@ -668,7 +666,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 
 	res = request_irq(tpci200->info->pdev->irq,
 			  tpci200_interrupt, IRQF_SHARED,
-			  TPCI200_SHORTNAME, (void *) tpci200);
+			  KBUILD_MODNAME, (void *) tpci200);
 	if (res) {
 		pr_err("(bn 0x%X, sn 0x%X) unable to register IRQ !",
 		       tpci200->info->pdev->bus->number,
@@ -783,31 +781,31 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 	switch (space) {
 	case IPACK_IO_SPACE:
 		if (dev->io_space.address == NULL) {
-			pr_info("Slot [%s %d:%d] IO space not mapped !\n",
-				TPCI200_SHORTNAME, dev->bus_nr, dev->slot);
+			pr_info("Slot [%d:%d] IO space not mapped !\n",
+				dev->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->io_space;
 		break;
 	case IPACK_ID_SPACE:
 		if (dev->id_space.address == NULL) {
-			pr_info("Slot [%s %d:%d] ID space not mapped !\n",
-				TPCI200_SHORTNAME, dev->bus_nr, dev->slot);
+			pr_info("Slot [%d:%d] ID space not mapped !\n",
+				dev->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->id_space;
 		break;
 	case IPACK_MEM_SPACE:
 		if (dev->mem_space.address == NULL) {
-			pr_info("Slot [%s %d:%d] MEM space not mapped !\n",
-				TPCI200_SHORTNAME, dev->bus_nr, dev->slot);
+			pr_info("Slot [%d:%d] MEM space not mapped !\n",
+				dev->bus_nr, dev->slot);
 		goto out_unlock;
 		}
 		virt_addr_space = &dev->mem_space;
 		break;
 	default:
-		pr_err("Slot [%s %d:%d] space number %d doesn't exist !\n",
-		       TPCI200_SHORTNAME, dev->bus_nr, dev->slot, space);
+		pr_err("Slot [%d:%d] space number %d doesn't exist !\n",
+		       dev->bus_nr, dev->slot, space);
 		res = -EINVAL;
 		goto out_unlock;
 		break;
@@ -869,8 +867,8 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 	switch (space) {
 	case IPACK_IO_SPACE:
 		if (dev->io_space.address != NULL) {
-			pr_err("Slot [%s %d:%d] IO space already mapped !\n",
-			       TPCI200_SHORTNAME, tpci200->number, dev->slot);
+			pr_err("Slot [%d:%d] IO space already mapped !\n",
+			       tpci200->number, dev->slot);
 			res = -EINVAL;
 			goto out_unlock;
 		}
@@ -881,8 +879,8 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		break;
 	case IPACK_ID_SPACE:
 		if (dev->id_space.address != NULL) {
-			pr_err("Slot [%s %d:%d] ID space already mapped !\n",
-			       TPCI200_SHORTNAME, tpci200->number, dev->slot);
+			pr_err("Slot [%d:%d] ID space already mapped !\n",
+			       tpci200->number, dev->slot);
 			res = -EINVAL;
 			goto out_unlock;
 		}
@@ -893,8 +891,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		break;
 	case IPACK_MEM_SPACE:
 		if (dev->mem_space.address != NULL) {
-			pr_err("Slot [%s %d:%d] MEM space already mapped !\n",
-			       TPCI200_SHORTNAME,
+			pr_err("Slot [%d:%d] MEM space already mapped !\n",
 			       tpci200->number, dev->slot);
 			res = -EINVAL;
 			goto out_unlock;
@@ -902,9 +899,9 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		virt_addr_space = &dev->mem_space;
 
 		if (memory_size > tpci200->slots[dev->slot].mem_phys.size) {
-			pr_err("Slot [%s %d:%d] request is 0x%X memory, only 0x%X available !\n",
-			       TPCI200_SHORTNAME, dev->bus_nr, dev->slot,
-			       memory_size, tpci200->slots[dev->slot].mem_phys.size);
+			pr_err("Slot [%d:%d] request is 0x%X memory, only 0x%X available !\n",
+			       dev->bus_nr, dev->slot, memory_size,
+			       tpci200->slots[dev->slot].mem_phys.size);
 			res = -EINVAL;
 			goto out_unlock;
 		}
@@ -913,8 +910,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		size_to_map = memory_size;
 		break;
 	default:
-		pr_err("Slot [%s %d:%d] space %d doesn't exist !\n",
-		       TPCI200_SHORTNAME,
+		pr_err("Slot [%d:%d] space %d doesn't exist !\n",
 		       tpci200->number, dev->slot, space);
 		res = -EINVAL;
 		goto out_unlock;
@@ -950,16 +946,16 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	}
 
 	if (tpci200->slots[dev->slot].irq != NULL) {
-		pr_err("Slot [%s %d:%d] IRQ already registered !\n",
-		       TPCI200_SHORTNAME, dev->bus_nr, dev->slot);
+		pr_err("Slot [%d:%d] IRQ already registered !\n", dev->bus_nr,
+		       dev->slot);
 		res = -EINVAL;
 		goto out_unlock;
 	}
 
 	slot_irq = kzalloc(sizeof(struct slot_irq), GFP_KERNEL);
 	if (slot_irq == NULL) {
-		pr_err("Slot [%s %d:%d] unable to allocate memory for IRQ !\n",
-		       TPCI200_SHORTNAME, dev->bus_nr, dev->slot);
+		pr_err("Slot [%d:%d] unable to allocate memory for IRQ !\n",
+		       dev->bus_nr, dev->slot);
 		res = -ENOMEM;
 		goto out_unlock;
 	}
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 7eb994d..0b547ee 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -24,8 +24,6 @@
 
 #include "../ipack.h"
 
-#define TPCI200_SHORTNAME "TPCI200"
-
 #define TPCI200_NB_SLOT               0x4
 #define TPCI200_NB_BAR                0x6
 
-- 
1.7.10


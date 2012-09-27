Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2I0KmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:42:23 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:33408 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab2I0Kgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEtQBIwgQ4TiAm3b5E1A5VpiTyJWA
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447796"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 01/17] Staging: ipack: get rid of ipack_device->bus_nr.
Date: Thu, 27 Sep 2012 12:37:25 +0200
Message-Id: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

It is replicating information contained in ipack_device->bus->bus_nr.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   18 +++++++++---------
 drivers/staging/ipack/devices/ipoctal.c |    2 +-
 drivers/staging/ipack/ipack.c           |    5 ++---
 drivers/staging/ipack/ipack.h           |    2 --
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index bb8aa70..2f48dd5 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -46,7 +46,7 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	if (dev->slot >= TPCI200_NB_SLOT) {
 		dev_info(&dev->dev,
 			 "Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
-			 dev->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
+			 dev->bus->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
 		return NULL;
 	}
 
@@ -206,7 +206,7 @@ static int tpci200_request_irq(struct ipack_device *dev,
 
 	if (tpci200->slots[dev->slot].irq != NULL) {
 		dev_err(&dev->dev,
-			"Slot [%d:%d] IRQ already registered !\n", dev->bus_nr,
+			"Slot [%d:%d] IRQ already registered !\n", dev->bus->bus_nr,
 			dev->slot);
 		res = -EINVAL;
 		goto out_unlock;
@@ -216,7 +216,7 @@ static int tpci200_request_irq(struct ipack_device *dev,
 	if (slot_irq == NULL) {
 		dev_err(&dev->dev,
 			"Slot [%d:%d] unable to allocate memory for IRQ !\n",
-			dev->bus_nr, dev->slot);
+			dev->bus->bus_nr, dev->slot);
 		res = -ENOMEM;
 		goto out_unlock;
 	}
@@ -379,7 +379,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 		if (dev->io_space.address == NULL) {
 			dev_info(&dev->dev,
 				 "Slot [%d:%d] IO space not mapped !\n",
-				 dev->bus_nr, dev->slot);
+				 dev->bus->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->io_space;
@@ -388,7 +388,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 		if (dev->id_space.address == NULL) {
 			dev_info(&dev->dev,
 				 "Slot [%d:%d] ID space not mapped !\n",
-				 dev->bus_nr, dev->slot);
+				 dev->bus->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->id_space;
@@ -397,7 +397,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 		if (dev->int_space.address == NULL) {
 			dev_info(&dev->dev,
 				 "Slot [%d:%d] INT space not mapped !\n",
-				 dev->bus_nr, dev->slot);
+				 dev->bus->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->int_space;
@@ -406,7 +406,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 		if (dev->mem_space.address == NULL) {
 			dev_info(&dev->dev,
 				 "Slot [%d:%d] MEM space not mapped !\n",
-				 dev->bus_nr, dev->slot);
+				 dev->bus->bus_nr, dev->slot);
 			goto out_unlock;
 		}
 		virt_addr_space = &dev->mem_space;
@@ -414,7 +414,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 	default:
 		dev_err(&dev->dev,
 			"Slot [%d:%d] space number %d doesn't exist !\n",
-			dev->bus_nr, dev->slot, space);
+			dev->bus->bus_nr, dev->slot, space);
 		mutex_unlock(&tpci200->mutex);
 		return -EINVAL;
 	}
@@ -497,7 +497,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		if (memory_size > tpci200->slots[dev->slot].mem_phys.size) {
 			dev_err(&dev->dev,
 				"Slot [%d:%d] request is 0x%X memory, only 0x%X available !\n",
-				dev->bus_nr, dev->slot, memory_size,
+				dev->bus->bus_nr, dev->slot, memory_size,
 				tpci200->slots[dev->slot].mem_phys.size);
 			res = -EINVAL;
 			goto out_unlock;
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 2cdbf28..14a0aed 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -719,7 +719,7 @@ static int ipoctal_probe(struct ipack_device *dev)
 		return -ENOMEM;
 
 	ipoctal->dev = dev;
-	res = ipoctal_inst_slot(ipoctal, dev->bus_nr, dev->slot);
+	res = ipoctal_inst_slot(ipoctal, dev->bus->bus_nr, dev->slot);
 	if (res)
 		goto out_uninst;
 
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index d1e0651..ca8cb327 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -234,7 +234,7 @@ static int ipack_unregister_bus_member(struct device *dev, void *data)
 	struct ipack_device *idev = to_ipack_dev(dev);
 	struct ipack_bus_device *bus = data;
 
-	if (idev->bus_nr == bus->bus_nr)
+	if (idev->bus == bus)
 		ipack_device_unregister(idev);
 
 	return 1;
@@ -440,10 +440,9 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	dev->dev.release = ipack_device_release;
 	dev->dev.parent = bus->parent;
 	dev->slot = slot;
-	dev->bus_nr = bus->bus_nr;
 	dev->bus = bus;
 	dev_set_name(&dev->dev,
-		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
+		     "ipack-dev.%u.%u", dev->bus->bus_nr, dev->slot);
 
 	if (bus->ops->set_clockrate(dev, 8))
 		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index d8e3bb6..33fdea5 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -52,7 +52,6 @@ struct ipack_addr_space {
 /**
  *	struct ipack_device
  *
- *	@bus_nr: IP bus number where the device is plugged
  *	@slot: Slot where the device is plugged in the carrier board
  *	@bus: ipack_bus_device where the device is plugged to.
  *	@id_space: Virtual address to ID space.
@@ -65,7 +64,6 @@ struct ipack_addr_space {
  * by the carrier board throught bus->ops.
  */
 struct ipack_device {
-	unsigned int bus_nr;
 	unsigned int slot;
 	struct ipack_bus_device *bus;
 	struct ipack_addr_space id_space;
-- 
1.7.10.4


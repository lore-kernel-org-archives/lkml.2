Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2IDPKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:36 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2IDPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:33 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBGne5JggSGQDIESA5VZiTOJTA
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821816"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 04/16] Staging: ipack/bridges/tpci200: Remove the read/write functions from ipack_bus_ops.
Date: Tue,  4 Sep 2012 17:01:09 +0200
Message-Id: <1346770881-4723-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

They are not used any longer.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |  218 -------------------------------
 1 file changed, 218 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index f2501c9..b81a8c9 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -51,218 +51,6 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	return tpci200;
 }
 
-static inline unsigned char __tpci200_read8(void __iomem *address,
-					    unsigned long offset)
-{
-	return ioread8(address + offset);
-}
-
-static inline unsigned short __tpci200_read16(void __iomem *address,
-					      unsigned long offset)
-{
-	return ioread16be(address + offset);
-}
-
-static inline unsigned int __tpci200_read32(void __iomem *address,
-					    unsigned long offset)
-{
-	return ioread32be(address + offset);
-}
-
-static inline void __tpci200_write8(unsigned char value,
-				    void __iomem *address, unsigned long offset)
-{
-	iowrite8(value, address + offset);
-}
-
-static inline void __tpci200_write16(unsigned short value,
-				     void __iomem *address,
-				     unsigned long offset)
-{
-	iowrite16be(value, address + offset);
-}
-
-static inline void __tpci200_write32(unsigned int value,
-				     void __iomem *address,
-				     unsigned long offset)
-{
-	iowrite32be(value, address + offset);
-}
-
-static struct ipack_addr_space *get_slot_address_space(struct ipack_device *dev,
-						       int space)
-{
-	struct ipack_addr_space *addr;
-
-	switch (space) {
-	case IPACK_IO_SPACE:
-		addr = &dev->io_space;
-		break;
-	case IPACK_ID_SPACE:
-		addr = &dev->id_space;
-		break;
-	case IPACK_MEM_SPACE:
-		addr = &dev->mem_space;
-		break;
-	default:
-		dev_err(&dev->dev,
-			"Slot [%d:%d] space number %d doesn't exist !\n",
-			dev->bus_nr, dev->slot, space);
-		return NULL;
-		break;
-	}
-
-	if ((addr->size == 0) || (addr->address == NULL)) {
-		dev_err(&dev->dev, "Error, slot space not mapped !\n");
-		return NULL;
-	}
-
-	return addr;
-}
-
-static int tpci200_read8(struct ipack_device *dev, int space,
-			 unsigned long offset, unsigned char *value)
-{
-	struct ipack_addr_space *addr;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	addr = get_slot_address_space(dev, space);
-	if (addr == NULL)
-		return -EINVAL;
-
-	if (offset >= addr->size) {
-		dev_err(&dev->dev, "Error, slot space offset error !\n");
-		return -EFAULT;
-	}
-
-	*value = __tpci200_read8(addr->address, offset);
-
-	return 0;
-}
-
-static int tpci200_read16(struct ipack_device *dev, int space,
-			  unsigned long offset, unsigned short *value)
-{
-	struct ipack_addr_space *addr;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	addr = get_slot_address_space(dev, space);
-	if (addr == NULL)
-		return -EINVAL;
-
-	if ((offset+2) >= addr->size) {
-		dev_err(&dev->dev, "Error, slot space offset error !\n");
-		return -EFAULT;
-	}
-	*value = __tpci200_read16(addr->address, offset);
-
-	return 0;
-}
-
-static int tpci200_read32(struct ipack_device *dev, int space,
-			  unsigned long offset, unsigned int *value)
-{
-	struct ipack_addr_space *addr;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	addr = get_slot_address_space(dev, space);
-	if (addr == NULL)
-		return -EINVAL;
-
-	if ((offset+4) >= addr->size) {
-		dev_err(&dev->dev, "Error, slot space offset error !\n");
-		return -EFAULT;
-	}
-
-	*value = __tpci200_read32(addr->address, offset);
-
-	return 0;
-}
-
-static int tpci200_write8(struct ipack_device *dev, int space,
-			  unsigned long offset, unsigned char value)
-{
-	struct ipack_addr_space *addr;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	addr = get_slot_address_space(dev, space);
-	if (addr == NULL)
-		return -EINVAL;
-
-	if (offset >= addr->size) {
-		dev_err(&dev->dev, "Error, slot space offset error !\n");
-		return -EFAULT;
-	}
-
-	__tpci200_write8(value, addr->address, offset);
-
-	return 0;
-}
-
-static int tpci200_write16(struct ipack_device *dev, int space,
-			   unsigned long offset, unsigned short value)
-{
-	struct ipack_addr_space *addr;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	addr = get_slot_address_space(dev, space);
-	if (addr == NULL)
-		return -EINVAL;
-
-	if ((offset+2) >= addr->size) {
-		dev_err(&dev->dev, "Error, slot space offset error !\n");
-		return -EFAULT;
-	}
-
-	__tpci200_write16(value, addr->address, offset);
-
-	return 0;
-}
-
-static int tpci200_write32(struct ipack_device *dev, int space,
-			   unsigned long offset, unsigned int value)
-{
-	struct ipack_addr_space *addr;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	addr = get_slot_address_space(dev, space);
-	if (addr == NULL)
-		return -EINVAL;
-
-	if ((offset+4) >= addr->size) {
-		dev_err(&dev->dev, "Error, slot space offset error !\n");
-		return -EFAULT;
-	}
-
-	__tpci200_write32(value, addr->address, offset);
-
-	return 0;
-}
-
 static void tpci200_unregister(struct tpci200_board *tpci200)
 {
 	int i;
@@ -749,12 +537,6 @@ static struct ipack_bus_ops tpci200_bus_ops = {
 	.unmap_space = tpci200_slot_unmap_space,
 	.request_irq = tpci200_request_irq,
 	.free_irq = tpci200_free_irq,
-	.read8 = tpci200_read8,
-	.read16 = tpci200_read16,
-	.read32 = tpci200_read32,
-	.write8 = tpci200_write8,
-	.write16 = tpci200_write16,
-	.write32 = tpci200_write32,
 	.remove_device = tpci200_slot_unregister,
 };
 
-- 
1.7.10.4


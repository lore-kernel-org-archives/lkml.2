Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0CRPXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:23:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53376 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab0CRPW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:22:59 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [V2 PATCH 09/10] arch/microblaze: Remove obsolete
	dev_archdata.of_node and of_devce.node
To: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Date: Thu, 18 Mar 2010 09:22:56 -0600
Message-ID: <20100318152255.21082.21063.stgit@angua>
In-Reply-To: <20100318144836.21082.93040.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both dev_archdata.of_node and of_device.node are duplications of the
device.of_node value.  This patch removes them.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/microblaze/include/asm/device.h    |   14 --------------
 arch/microblaze/include/asm/of_device.h |    1 -
 arch/microblaze/kernel/of_device.c      |    4 +---
 3 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/arch/microblaze/include/asm/device.h b/arch/microblaze/include/asm/device.h
index 78a0384..8d46822 100644
--- a/arch/microblaze/include/asm/device.h
+++ b/arch/microblaze/include/asm/device.h
@@ -12,25 +12,11 @@
 struct device_node;
 
 struct dev_archdata {
-	/* Optional pointer to an OF device node */
-	struct device_node	*of_node;
 };
 
 struct pdev_archdata {
 };
 
-static inline void dev_archdata_set_node(struct dev_archdata *ad,
-					 struct device_node *np)
-{
-	ad->of_node = np;
-}
-
-static inline struct device_node *
-dev_archdata_get_node(const struct dev_archdata *ad)
-{
-	return ad->of_node;
-}
-
 #endif /* _ASM_MICROBLAZE_DEVICE_H */
 
 
diff --git a/arch/microblaze/include/asm/of_device.h b/arch/microblaze/include/asm/of_device.h
index ba917cf..ab25a40 100644
--- a/arch/microblaze/include/asm/of_device.h
+++ b/arch/microblaze/include/asm/of_device.h
@@ -21,7 +21,6 @@
  * probed using OF properties.
  */
 struct of_device {
-	struct device_node	*node; /* to be obsoleted */
 	u64			dma_mask; /* DMA mask */
 	struct device		dev; /* Generic device interface */
 };
diff --git a/arch/microblaze/kernel/of_device.c b/arch/microblaze/kernel/of_device.c
index 90d2246..ac7e6e1 100644
--- a/arch/microblaze/kernel/of_device.c
+++ b/arch/microblaze/kernel/of_device.c
@@ -49,12 +49,10 @@ struct of_device *of_device_alloc(struct device_node *np,
 	if (!dev)
 		return NULL;
 
-	dev->node = of_node_get(np);
+	dev->dev.of_node = of_node_get(np);
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.parent = parent;
 	dev->dev.release = of_release_dev;
-	dev->dev.archdata.of_node = np;
-	dev->dev.of_node = np;
 
 	if (bus_id)
 		dev_set_name(&dev->dev, bus_id);


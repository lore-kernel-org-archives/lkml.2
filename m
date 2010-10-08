Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0JHRdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:33:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58359 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab0JHRdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:33 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andreas Schwab <schwab@linux-m68k.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/11] macio: ensure all dma routines get copied over
Date: Fri,  8 Oct 2010 10:33:02 -0700
Message-Id: <1286559192-10898-2-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add a comment to dev_archdata, indicating that changes there need
to be verified against the driver code.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/include/asm/device.h |    6 ++++++
 drivers/macintosh/macio_asic.c    |    7 +++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index a3954e4..16d25c0 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -9,6 +9,12 @@
 struct dma_map_ops;
 struct device_node;
 
+/*
+ * Arch extensions to struct device.
+ *
+ * When adding fields, consider macio_add_one_device in
+ * drivers/macintosh/macio_asic.c
+ */
 struct dev_archdata {
 	/* DMA operations on that device */
 	struct dma_map_ops	*dma_ops;
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index b6e7ddc..18bf7a9 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -387,11 +387,10 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 	/* Set the DMA ops to the ones from the PCI device, this could be
 	 * fishy if we didn't know that on PowerMac it's always direct ops
 	 * or iommu ops that will work fine
+         *
+         * To get all the fields, copy all archdata
 	 */
-	dev->ofdev.dev.archdata.dma_ops =
-		chip->lbus.pdev->dev.archdata.dma_ops;
-	dev->ofdev.dev.archdata.dma_data =
-		chip->lbus.pdev->dev.archdata.dma_data;
+        dev->ofdev.dev.archdata = chip->lbus.pdev->dev.archdata;
 #endif /* CONFIG_PCI */
 
 #ifdef DEBUG
-- 
1.7.1


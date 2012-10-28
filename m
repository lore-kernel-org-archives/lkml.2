Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2J1IHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:07:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35900 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750821Ab2J1IHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:07:05 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 01/16] tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:39 -0700
Message-Id: <c7c947ee63de15e20b7a7e2f47aee66ef02ca50f.1351411047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce formats for easier grep.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/tile/kernel/pci_gx.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 2ba6d05..cf1b378 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1454,9 +1454,8 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	 * Most PCIe endpoint devices do support 64-bit message addressing.
 	 */
 	if (desc->msi_attrib.is_64 == 0) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			"64-bit MSI message address not supported, "
-			"falling back to legacy interrupts.\n");
+		dev_info(&pdev->dev,
+			 "64-bit MSI message address not supported, falling back to legacy interrupts\n");
 
 		ret = -ENOMEM;
 		goto is_64_failure;
@@ -1475,11 +1474,9 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	 */
 	mem_map = gxio_trio_alloc_memory_maps(trio_context, 1, 0, 0);
 	if (mem_map < 0) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			"%s Mem-Map alloc failure. "
-			"Failed to initialize MSI interrupts. "
-			"Falling back to legacy interrupts.\n",
-			desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
+		dev_info(&pdev->dev,
+			 "%s Mem-Map alloc failure. Failed to initialize MSI interrupts. Falling back to legacy interrupts.\n",
+			 desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
 
 		ret = -ENOMEM;
 		goto msi_mem_map_alloc_failure;
@@ -1501,7 +1498,7 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 					mem_map, mem_map_base, mem_map_limit,
 					trio_context->asid);
 	if (ret < 0) {
-		dev_printk(KERN_INFO, &pdev->dev, "HV MSI config failed.\n");
+		dev_info(&pdev->dev, "HV MSI config failed\n");
 
 		goto hv_msi_config_failure;
 	}
-- 
1.7.8.112.g3fd21


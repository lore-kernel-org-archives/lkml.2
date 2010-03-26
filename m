Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0CZTxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:53:46 -0400
Received: from server78.greatnet.de ([83.133.96.102]:56299 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0CZTxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:53:44 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: jbarnes@virtuousgeek.org
Cc: David.Woodhouse@intel.com, len.brown@intel.com, chrisw@sous-sol.org,
       suresh.b.siddha@intel.com, mingo@elte.hu, yu.zhao@intel.com,
       fenghua.yu@intel.com, weidong@intel.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH] dmar: section mismatch cleanup
Date: Fri, 26 Mar 2010 20:53:20 +0100
Message-Id: <1269633200-19970-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a section mismatch.

WARNING: drivers/pci/built-in.o(.text+0x182f5): Section mismatch in
reference from the function dmar_ir_support() to the variable
.init.data:acpi_slot_detected
The function dmar_ir_support() references
the variable __initdata acpi_slot_detected.
This is often because dmar_ir_support lacks a __initdata
annotation or the annotation of acpi_slot_detected is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/pci/dmar.c          |    2 +-
 include/linux/intel-iommu.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 83aae47..ffe22bc 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1456,7 +1456,7 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 9310c69..f51a553 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -361,6 +361,6 @@ extern void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
 
 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-extern int dmar_ir_support(void);
+extern int dmar_ir_support(void) __init;
 
 #endif
-- 
1.6.3.3


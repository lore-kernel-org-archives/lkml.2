Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161428Ab2JXWJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:09:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64288 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161387Ab2JXWJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:09:40 -0400
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 2/6] staging: tidspbridge: drop const from custom mmu implementation
Date: Wed, 24 Oct 2012 17:09:16 -0500
Message-Id: <1351116560-6918-3-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
References: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Custom mmu functions receive a 'const void __iomem *', all the
callers pass a 'void __iomem *', so drop the const to fix the
warnings like:

warning: passing argument 2 of '__raw_writel' discards qualifiers from pointer target type
../io.h:88: note: expected 'volatile void *' but argument is of type 'const void *'

Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
---

Intended for 3.7 due to code changes during rc1.

 drivers/staging/tidspbridge/hw/hw_mmu.c |   40 +++++++++++++++----------------
 drivers/staging/tidspbridge/hw/hw_mmu.h |   28 +++++++++++-----------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index 71cb822..a159450 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -78,7 +78,7 @@ static hw_status mmu_flush_entry(const void __iomem *base_address);
  * INPUTS:
  *
  *       Identifier      : base_address
- *       TypE		: const u32
+ *       Type		 : void __iomem *
  *       Description     : Base Address of instance of MMU module
  *
  *       Identifier      : page_sz
@@ -112,7 +112,7 @@ static hw_status mmu_flush_entry(const void __iomem *base_address);
  *
  * METHOD:	       	: Check the Input parameters and set the CAM entry.
  */
-static hw_status mmu_set_cam_entry(const void __iomem *base_address,
+static hw_status mmu_set_cam_entry(void __iomem *base_address,
 				   const u32 page_sz,
 				   const u32 preserved_bit,
 				   const u32 valid_bit,
@@ -124,7 +124,7 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
  * INPUTS:
  *
  *       Identifier      : base_address
- *       Type	    	: const u32
+ *       Type		 : void __iomem *
  *       Description     : Base Address of instance of MMU module
  *
  *       Identifier      : physical_addr
@@ -157,7 +157,7 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
  *
  * METHOD:	       : Check the Input parameters and set the RAM entry.
  */
-static hw_status mmu_set_ram_entry(const void __iomem *base_address,
+static hw_status mmu_set_ram_entry(void __iomem *base_address,
 				   const u32 physical_addr,
 				   enum hw_endianism_t endianism,
 				   enum hw_element_size_t element_size,
@@ -165,7 +165,7 @@ static hw_status mmu_set_ram_entry(const void __iomem *base_address,
 
 /* HW FUNCTIONS */
 
-hw_status hw_mmu_enable(const void __iomem *base_address)
+hw_status hw_mmu_enable(void __iomem *base_address)
 {
 	hw_status status = 0;
 
@@ -174,7 +174,7 @@ hw_status hw_mmu_enable(const void __iomem *base_address)
 	return status;
 }
 
-hw_status hw_mmu_disable(const void __iomem *base_address)
+hw_status hw_mmu_disable(void __iomem *base_address)
 {
 	hw_status status = 0;
 
@@ -183,7 +183,7 @@ hw_status hw_mmu_disable(const void __iomem *base_address)
 	return status;
 }
 
-hw_status hw_mmu_num_locked_set(const void __iomem *base_address,
+hw_status hw_mmu_num_locked_set(void __iomem *base_address,
 				u32 num_locked_entries)
 {
 	hw_status status = 0;
@@ -193,7 +193,7 @@ hw_status hw_mmu_num_locked_set(const void __iomem *base_address,
 	return status;
 }
 
-hw_status hw_mmu_victim_num_set(const void __iomem *base_address,
+hw_status hw_mmu_victim_num_set(void __iomem *base_address,
 				u32 victim_entry_num)
 {
 	hw_status status = 0;
@@ -203,7 +203,7 @@ hw_status hw_mmu_victim_num_set(const void __iomem *base_address,
 	return status;
 }
 
-hw_status hw_mmu_event_ack(const void __iomem *base_address, u32 irq_mask)
+hw_status hw_mmu_event_ack(void __iomem *base_address, u32 irq_mask)
 {
 	hw_status status = 0;
 
@@ -212,7 +212,7 @@ hw_status hw_mmu_event_ack(const void __iomem *base_address, u32 irq_mask)
 	return status;
 }
 
-hw_status hw_mmu_event_disable(const void __iomem *base_address, u32 irq_mask)
+hw_status hw_mmu_event_disable(void __iomem *base_address, u32 irq_mask)
 {
 	hw_status status = 0;
 	u32 irq_reg;
@@ -224,7 +224,7 @@ hw_status hw_mmu_event_disable(const void __iomem *base_address, u32 irq_mask)
 	return status;
 }
 
-hw_status hw_mmu_event_enable(const void __iomem *base_address, u32 irq_mask)
+hw_status hw_mmu_event_enable(void __iomem *base_address, u32 irq_mask)
 {
 	hw_status status = 0;
 	u32 irq_reg;
@@ -236,7 +236,7 @@ hw_status hw_mmu_event_enable(const void __iomem *base_address, u32 irq_mask)
 	return status;
 }
 
-hw_status hw_mmu_event_status(const void __iomem *base_address, u32 *irq_mask)
+hw_status hw_mmu_event_status(void __iomem *base_address, u32 *irq_mask)
 {
 	hw_status status = 0;
 
@@ -245,7 +245,7 @@ hw_status hw_mmu_event_status(const void __iomem *base_address, u32 *irq_mask)
 	return status;
 }
 
-hw_status hw_mmu_fault_addr_read(const void __iomem *base_address, u32 *addr)
+hw_status hw_mmu_fault_addr_read(void __iomem *base_address, u32 *addr)
 {
 	hw_status status = 0;
 
@@ -255,7 +255,7 @@ hw_status hw_mmu_fault_addr_read(const void __iomem *base_address, u32 *addr)
 	return status;
 }
 
-hw_status hw_mmu_ttb_set(const void __iomem *base_address, u32 ttb_phys_addr)
+hw_status hw_mmu_ttb_set(void __iomem *base_address, u32 ttb_phys_addr)
 {
 	hw_status status = 0;
 	u32 load_ttb;
@@ -267,7 +267,7 @@ hw_status hw_mmu_ttb_set(const void __iomem *base_address, u32 ttb_phys_addr)
 	return status;
 }
 
-hw_status hw_mmu_twl_enable(const void __iomem *base_address)
+hw_status hw_mmu_twl_enable(void __iomem *base_address)
 {
 	hw_status status = 0;
 
@@ -276,7 +276,7 @@ hw_status hw_mmu_twl_enable(const void __iomem *base_address)
 	return status;
 }
 
-hw_status hw_mmu_twl_disable(const void __iomem *base_address)
+hw_status hw_mmu_twl_disable(void __iomem *base_address)
 {
 	hw_status status = 0;
 
@@ -323,7 +323,7 @@ hw_status hw_mmu_tlb_flush(const void __iomem *base_address, u32 virtual_addr,
 	return status;
 }
 
-hw_status hw_mmu_tlb_add(const void __iomem *base_address,
+hw_status hw_mmu_tlb_add(void __iomem *base_address,
 			 u32 physical_addr,
 			 u32 virtual_addr,
 			 u32 page_sz,
@@ -516,7 +516,7 @@ static hw_status mmu_flush_entry(const void __iomem *base_address)
 }
 
 /* mmu_set_cam_entry */
-static hw_status mmu_set_cam_entry(const void __iomem *base_address,
+static hw_status mmu_set_cam_entry(void __iomem *base_address,
 				   const u32 page_sz,
 				   const u32 preserved_bit,
 				   const u32 valid_bit,
@@ -536,7 +536,7 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
 }
 
 /* mmu_set_ram_entry */
-static hw_status mmu_set_ram_entry(const void __iomem *base_address,
+static hw_status mmu_set_ram_entry(void __iomem *base_address,
 				   const u32 physical_addr,
 				   enum hw_endianism_t endianism,
 				   enum hw_element_size_t element_size,
@@ -556,7 +556,7 @@ static hw_status mmu_set_ram_entry(const void __iomem *base_address,
 
 }
 
-void hw_mmu_tlb_flush_all(const void __iomem *base)
+void hw_mmu_tlb_flush_all(void __iomem *base)
 {
 	__raw_writel(1, base + MMU_GFLUSH);
 }
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.h b/drivers/staging/tidspbridge/hw/hw_mmu.h
index 1458a2c..1cdd082 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.h
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.h
@@ -42,44 +42,44 @@ struct hw_mmu_map_attrs_t {
 	bool donotlockmpupage;
 };
 
-extern hw_status hw_mmu_enable(const void __iomem *base_address);
+extern hw_status hw_mmu_enable(void __iomem *base_address);
 
-extern hw_status hw_mmu_disable(const void __iomem *base_address);
+extern hw_status hw_mmu_disable(void __iomem *base_address);
 
-extern hw_status hw_mmu_num_locked_set(const void __iomem *base_address,
+extern hw_status hw_mmu_num_locked_set(void __iomem *base_address,
 				       u32 num_locked_entries);
 
-extern hw_status hw_mmu_victim_num_set(const void __iomem *base_address,
+extern hw_status hw_mmu_victim_num_set(void __iomem *base_address,
 				       u32 victim_entry_num);
 
 /* For MMU faults */
-extern hw_status hw_mmu_event_ack(const void __iomem *base_address,
+extern hw_status hw_mmu_event_ack(void __iomem *base_address,
 				  u32 irq_mask);
 
-extern hw_status hw_mmu_event_disable(const void __iomem *base_address,
+extern hw_status hw_mmu_event_disable(void __iomem *base_address,
 				      u32 irq_mask);
 
-extern hw_status hw_mmu_event_enable(const void __iomem *base_address,
+extern hw_status hw_mmu_event_enable(void __iomem *base_address,
 				     u32 irq_mask);
 
-extern hw_status hw_mmu_event_status(const void __iomem *base_address,
+extern hw_status hw_mmu_event_status(void __iomem *base_address,
 				     u32 *irq_mask);
 
-extern hw_status hw_mmu_fault_addr_read(const void __iomem *base_address,
+extern hw_status hw_mmu_fault_addr_read(void __iomem *base_address,
 					u32 *addr);
 
 /* Set the TT base address */
-extern hw_status hw_mmu_ttb_set(const void __iomem *base_address,
+extern hw_status hw_mmu_ttb_set(void __iomem *base_address,
 				u32 ttb_phys_addr);
 
-extern hw_status hw_mmu_twl_enable(const void __iomem *base_address);
+extern hw_status hw_mmu_twl_enable(void __iomem *base_address);
 
-extern hw_status hw_mmu_twl_disable(const void __iomem *base_address);
+extern hw_status hw_mmu_twl_disable(void __iomem *base_address);
 
 extern hw_status hw_mmu_tlb_flush(const void __iomem *base_address,
 				  u32 virtual_addr, u32 page_sz);
 
-extern hw_status hw_mmu_tlb_add(const void __iomem *base_address,
+extern hw_status hw_mmu_tlb_add(void __iomem *base_address,
 				u32 physical_addr,
 				u32 virtual_addr,
 				u32 page_sz,
@@ -97,7 +97,7 @@ extern hw_status hw_mmu_pte_set(const u32 pg_tbl_va,
 extern hw_status hw_mmu_pte_clear(const u32 pg_tbl_va,
 				  u32 virtual_addr, u32 page_size);
 
-void hw_mmu_tlb_flush_all(const void __iomem *base);
+void hw_mmu_tlb_flush_all(void __iomem *base);
 
 static inline u32 hw_mmu_pte_addr_l1(u32 l1_base, u32 va)
 {
-- 
1.7.9.5


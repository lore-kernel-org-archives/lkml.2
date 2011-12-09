Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1LILpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:45:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64045 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1LILp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:45:26 -0500
From: Michal Simek <monstr@monstr.eu>
To: robherring2@gmail.com
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        anton.vorontsov@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] microblaze: intc: Change variable name
Date: Fri,  9 Dec 2011 12:45:18 +0100
Message-Id: <1323431121-12780-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1323431121-12780-1-git-send-email-monstr@monstr.eu>
References: <1323431121-12780-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intr_type is mask - change name.
s/intr_type/intr_mask/g

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/intc.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index da33e45..1293098 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -99,7 +99,7 @@ unsigned int get_irq(struct pt_regs *regs)
 
 void __init init_IRQ(void)
 {
-	u32 i, intr_type;
+	u32 i, intr_mask;
 	struct device_node *intc = NULL;
 #ifdef CONFIG_SELFMOD_INTC
 	unsigned int intc_baseaddr = 0;
@@ -122,10 +122,9 @@ void __init init_IRQ(void)
 	nr_irq = be32_to_cpup(of_get_property(intc,
 						"xlnx,num-intr-inputs", NULL));
 
-	intr_type =
-		be32_to_cpup(of_get_property(intc,
-						"xlnx,kind-of-intr", NULL));
-	if (intr_type > (u32)((1ULL << nr_irq) - 1))
+	intr_mask =
+		be32_to_cpup(of_get_property(intc, "xlnx,kind-of-intr", NULL));
+	if (intr_mask > (u32)((1ULL << nr_irq) - 1))
 		printk(KERN_INFO " ERROR: Mismatch in kind-of-intr param\n");
 
 #ifdef CONFIG_SELFMOD_INTC
@@ -147,7 +146,7 @@ void __init init_IRQ(void)
 	out_be32(intc_baseaddr + MER, MER_HIE | MER_ME);
 
 	for (i = 0; i < nr_irq; ++i) {
-		if (intr_type & (0x00000001 << i)) {
+		if (intr_mask & (0x00000001 << i)) {
 			irq_set_chip_and_handler_name(i, &intc_dev,
 				handle_edge_irq, "edge");
 			irq_clear_status_flags(i, IRQ_LEVEL);
-- 
1.7.5.4


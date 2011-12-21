Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1LUOcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 09:32:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53311 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1LUOcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 09:32:22 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 4/4] microblaze: Remove NO_IRQ from architecture
Date: Wed, 21 Dec 2011 15:32:12 +0100
Message-Id: <1324477932-19262-4-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1324477932-19262-3-git-send-email-monstr@monstr.eu>
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
 <1324477932-19262-2-git-send-email-monstr@monstr.eu>
 <1324477932-19262-3-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NO_IRQ shouldn't be used by any driver. All Microblaze
drivers are fixed that's why NO_IRQ can be removed.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ryan Mallon <rmallon@gmail.com>
---
 arch/microblaze/include/asm/irq.h |    2 --
 arch/microblaze/pci/pci-common.c  |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index b116a82..a175132 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -27,8 +27,6 @@ typedef unsigned long irq_hw_number_t;
 
 extern unsigned int nr_irq;
 
-#define NO_IRQ 0
-
 struct pt_regs;
 extern void do_IRQ(struct pt_regs *regs);
 
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index db841c7..0d71b2e 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -242,7 +242,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
 			 line, pin);
 
 		virq = irq_create_mapping(NULL, line);
-		if (virq != NO_IRQ)
+		if (virq)
 			irq_set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
 	} else {
 		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
@@ -253,7 +253,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
 		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
 					     oirq.size);
 	}
-	if (virq == NO_IRQ) {
+	if (!virq) {
 		pr_debug(" Failed to map !\n");
 		return -1;
 	}
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0JJKCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:02:21 -0400
Received: from www.tglx.de ([62.245.132.106]:55589 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0JJKCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:02:20 -0400
Date: Sun, 10 Oct 2010 12:02:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] pci: intr_remapping: Fix bogus CONFIG ifdef
Message-ID: <alpine.LFD.2.00.1010101151460.2413@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt remapping code selects the dynamic allocation of the
irq_2_iommu structure depending on CONFIG_GENERIC_HARDIRQS. Introduced
by commit d7e51e668 (sparseirq: make some func to be used with genirq)

The correct config switch is CONFIG_SPARSE_IRQ.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index fd1d286..af63cc2 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -53,7 +53,7 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
-#ifdef CONFIG_GENERIC_HARDIRQS
+#ifdef CONFIG_SPARSE_IRQ
 static struct irq_2_iommu *get_one_free_irq_2_iommu(int node)
 {
 	struct irq_2_iommu *iommu;

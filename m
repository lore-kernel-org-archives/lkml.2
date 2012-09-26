Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2IZKtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:49:07 -0400
Received: from [216.32.181.181] ([216.32.181.181]:10118 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab2IZKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV4-01-D57-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/19] x86, irq: Move irq_remapping_enabled declaration to iommu code
Date: Wed, 26 Sep 2012 12:44:43 +0200
Message-ID: <1348656291-10375-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the last left-over from this flag from x86 code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/irq_remapping.h |    4 ----
 drivers/iommu/dmar.c                 |    2 ++
 drivers/iommu/intel-iommu.c          |    2 ++
 drivers/iommu/irq_remapping.h        |    3 +++
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index fb99a73..6f4b48b 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -26,8 +26,6 @@
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern int irq_remapping_enabled;
-
 extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
 extern int irq_remapping_prepare(void);
@@ -49,8 +47,6 @@ extern void panic_if_irq_remap(const char *msg);
 
 #else  /* CONFIG_IRQ_REMAP */
 
-#define irq_remapping_enabled	0
-
 static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 86e2f4a..174bb65 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -41,6 +41,8 @@
 #include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
+#include "irq_remapping.h"
+
 /* No locks are needed as DMA remapping hardware unit
  * list is constructed at boot time and hotplug of
  * these units are not supported by the architecture.
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 2297ec1..6d713db 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -46,6 +46,8 @@
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
+#include "irq_remapping.h"
+
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index b12974c..1003297 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -34,6 +34,7 @@ struct msi_msg;
 extern int disable_irq_remap;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
+extern int irq_remapping_enabled;
 
 struct irq_remap_ops {
 	/* Check whether Interrupt Remapping is supported */
@@ -83,6 +84,8 @@ struct irq_remap_ops {
 
 extern struct irq_remap_ops intel_irq_remap_ops;
 
+#else  /* CONFIG_IRQ_REMAP */
+#define irq_remapping_enabled 0
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __IRQ_REMAPPING_H */
-- 
1.7.9.5



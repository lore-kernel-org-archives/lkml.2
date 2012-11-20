Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2KTNNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:13:47 -0500
Received: from 8bytes.org ([85.214.48.195]:58478 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab2KTNNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:16 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 11/19] x86, irq: Move irq_remapping_enabled declaration to iommu code
Date: Tue, 20 Nov 2012 14:12:48 +0100
Message-Id: <1353417176-18945-12-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:15 2012
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81eb22971593221267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the last left-over from this flag from x86 code.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/irq_remapping.h |    4 ----
 drivers/iommu/dmar.c                 |    2 ++
 drivers/iommu/intel-iommu.c          |    2 ++
 drivers/iommu/irq_remapping.h        |    1 +
 4 files changed, 5 insertions(+), 4 deletions(-)

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
index d4a4cd4..51ddb33 100644
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
index 95363ac..ecb6376 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -34,6 +34,7 @@ struct msi_msg;
 extern int disable_irq_remap;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
+extern int irq_remapping_enabled;
 
 struct irq_remap_ops {
 	/* Check whether Interrupt Remapping is supported */
-- 
1.7.9.5



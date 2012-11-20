Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2KTNOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:14:55 -0500
Received: from 8bytes.org ([85.214.48.195]:58388 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab2KTNNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:15 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 19/19] x86, irq: Move irq_remapped out of x86 core code
Date: Tue, 20 Nov 2012 14:12:56 +0100
Message-Id: <1353417176-18945-20-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:15 2012
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81eb22973997761044
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_remapped function is only used in IOMMU code after
the last patch. So move its definition there too.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/irq_remapping.h |   10 ----------
 drivers/iommu/irq_remapping.c        |    5 +++++
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index b30fca1..95fd352 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -48,11 +48,6 @@ extern bool setup_remapped_irq(int irq,
 			       struct irq_cfg *cfg,
 			       struct irq_chip *chip);
 
-static inline bool irq_remapped(struct irq_cfg *cfg)
-{
-	return (cfg->remapped == 1);
-}
-
 void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
 #else  /* CONFIG_IRQ_REMAP */
@@ -87,11 +82,6 @@ static inline void panic_if_irq_remap(const char *msg)
 {
 }
 
-static inline bool irq_remapped(struct irq_cfg *cfg)
-{
-	return false;
-}
-
 static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
 }
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 5622589..93f149b 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -31,6 +31,11 @@ static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask,
 				     bool force);
 
+static bool irq_remapped(struct irq_cfg *cfg)
+{
+	return (cfg->remapped == 1);
+}
+
 static void irq_remapping_disable_io_apic(void)
 {
 	/*
-- 
1.7.9.5



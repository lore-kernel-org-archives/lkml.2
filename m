Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2HTN6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:58:46 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:1248
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab2HTN4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241P-02-F11-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/19] x86, irq: Move irq_remapped out of x86 core code
Date: Mon, 20 Aug 2012 15:56:05 +0200
Message-ID: <1345470965-24410-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_remapped function is only used in IOMMU code after
the last patch. So move its definition there too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/irq_remapping.h |   10 ----------
 drivers/iommu/irq_remapping.c        |    5 +++++
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index b670580..95fd352 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -48,11 +48,6 @@ extern bool setup_remapped_irq(int irq,
 			       struct irq_cfg *cfg,
 			       struct irq_chip *chip);
 
-static inline bool irq_remapped(struct irq_cfg *cfg)
-{
-	return cfg->remapped;
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
index d62e757..bf8be56 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -31,6 +31,11 @@ static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask,
 				     bool force);
 
+static bool irq_remapped(struct irq_cfg *cfg)
+{
+	return cfg->remapped;
+}
+
 static void irq_remapping_disable_io_apic(void)
 {
 	/*
-- 
1.7.9.5



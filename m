Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2GEMhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:37:23 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:51648
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932576Ab2GEMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPM-02-6NS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 26/28] iommu/irq: Use amd_iommu_irq_ops if supported
Date: Thu, 5 Jul 2012 14:36:46 +0200
Message-ID: <1341491808-23083-27-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally enable interrupt remapping for AMD systems.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/irq_remapping.c |    5 +++++
 drivers/iommu/irq_remapping.h |    1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 7a880c3..e2c06c1 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -47,6 +47,11 @@ early_param("intremap", setup_irqremap);
 void __init setup_irq_remapping_ops(void)
 {
 	remap_ops = &intel_irq_remap_ops;
+
+#ifdef CONFIG_AMD_IOMMU
+	if (amd_iommu_irq_ops.prepare() == 0)
+		remap_ops = &amd_iommu_irq_ops;
+#endif
 }
 
 int irq_remapping_supported(void)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index b3f70c9..915a247 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -84,6 +84,7 @@ struct irq_remap_ops {
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
+extern struct irq_remap_ops amd_iommu_irq_ops;
 
 #else  /* CONFIG_IRQ_REMAP */
 
-- 
1.7.9.5



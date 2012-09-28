Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2I1MYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:24:25 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:19504
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757809Ab2I1MYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27SB-01-LL1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/16] iommu/irq: Use amd_iommu_irq_ops if supported
Date: Fri, 28 Sep 2012 14:24:04 +0200
Message-ID: <1348835046-3262-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
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
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 151690d..faf85d6 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -51,6 +51,11 @@ early_param("intremap", setup_irqremap);
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
-- 
1.7.9.5



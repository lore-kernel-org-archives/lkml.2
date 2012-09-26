Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2IZKtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:49:46 -0400
Received: from [216.32.181.183] ([216.32.181.183]:43960 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab2IZKq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV3-01-D52-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/19] x86, irq: Add data structure to keep AMD specific irq remapping information
Date: Wed, 26 Sep 2012 12:44:44 +0200
Message-ID: <1348656291-10375-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a data structure to store information the IOMMU driver
can use to get from a 'struct irq_cfg' to the remapping
entry.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/hw_irq.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..fc89a2a 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -101,6 +101,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 	irq_attr->polarity	= polarity;
 }
 
+/* Intel specific interrupt remapping information */
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -108,6 +109,12 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
+/* AMD specific interrupt remapping information */
+struct irq_2_irte {
+	u16 devid; /* Device ID for IRTE table */
+	u16 index; /* Index into IRTE table*/
+};
+
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -120,7 +127,10 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
-	struct irq_2_iommu	irq_2_iommu;
+	union {
+		struct irq_2_iommu irq_2_iommu;
+		struct irq_2_irte  irq_2_irte;
+	};
 #endif
 };
 
-- 
1.7.9.5



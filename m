Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0F1URw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:17:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:52868 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0F1URv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:17:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,499,1272870000"; 
   d="scan'208";a="634381924"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/apic: do not clear nr_irqs_gsi if no legacy irqs
Date: Mon, 28 Jun 2010 13:09:53 -0700
Message-Id: <1277755793-15551-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_legacy_irqs is set in probe_nr_irqs_gsi, we should not clear it after that.
Otherwise, the result is that MSI irqs will be allocated from the wrong range
for the systems without legacy PIC.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d99388a..5592462 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -155,10 +155,8 @@ int __init arch_early_irq_init(void)
 	int node;
 	int i;
 
-	if (!legacy_pic->nr_legacy_irqs) {
-		nr_irqs_gsi = 0;
+	if (!legacy_pic->nr_legacy_irqs)
 		io_apic_irqs = ~0UL;
-	}
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
-- 
1.6.3.3


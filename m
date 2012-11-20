Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2KTNNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:13:45 -0500
Received: from 8bytes.org ([85.214.48.195]:58374 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab2KTNNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 14/19] x86, io-apic: Remove !irq_remapped() check from __target_IO_APIC_irq()
Date: Tue, 20 Nov 2012 14:12:51 +0100
Message-Id: <1353417176-18945-15-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:15 2012
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81eb22973030218947
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only called from default_ioapic_set_affinity()
which is only used when interrupt remapping is disabled
since the introduction of the set_affinity function pointer.
So the check will always evaluate as true and can be
removed.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index eb3fa21..f8c290b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2311,12 +2311,8 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 
 		apic = entry->apic;
 		pin = entry->pin;
-		/*
-		 * With interrupt-remapping, destination information comes
-		 * from interrupt-remapping table entry.
-		 */
-		if (!irq_remapped(cfg))
-			io_apic_write(apic, 0x11 + pin*2, dest);
+
+		io_apic_write(apic, 0x11 + pin*2, dest);
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
-- 
1.7.9.5



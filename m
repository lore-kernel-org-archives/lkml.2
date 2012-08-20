Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2HTN6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:58:15 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:13017
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755963Ab2HTN4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:25 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241S-01-3DW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/19] x86, io-apic: Remove !irq_remapped() check from __target_IO_APIC_irq()
Date: Mon, 20 Aug 2012 15:56:00 +0200
Message-ID: <1345470965-24410-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only called from default_ioapic_set_affinity()
which is only used when interrupt remapping is disabled. So
the check will always evaluate as true and can be removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/apic/io_apic.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fa6bfb3..e95325f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2298,12 +2298,8 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 
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



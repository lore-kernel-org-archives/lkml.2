Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0KKQLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:11:16 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51141 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0KKQLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:11:15 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86/mrst: set vRTC's IRQ to level trigger type
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Nov 2010 15:50:50 +0000
Message-ID: <20101111155019.12924.569.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

When setting up the mpc_intsrc structure for vRTC's IRQ,
we need to set its irqflag to level trigger, otherwise
it will be taken as edge triggered and the vRTC IRQ will
fire only once, as there is never a EOI issued from the
IA core for it.

The original code worked in previous kernel. This is  because it
was configured to level trigger type by luck. It fell
into the default PCI trigger category which is level triggered.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index f2bc945..9ad8f57 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -195,7 +195,7 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 			totallen, (u32)pentry->phys_addr, pentry->irq);
 		mp_irq.type = MP_IOAPIC;
 		mp_irq.irqtype = mp_INT;
-		mp_irq.irqflag = 0;
+		mp_irq.irqflag = 0xf;	/* level trigger and active low */
 		mp_irq.srcbus = 0;
 		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 		mp_irq.dstapic = MP_APIC_ALL;


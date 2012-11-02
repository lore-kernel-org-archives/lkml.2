Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab2KBOCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:02:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55268 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762868Ab2KBOCB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 10:02:01 -0400
Message-Id: <5093E09002000078000A60E6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:02:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix masking of MSI interrupts
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPET_TN_FSB is not a proper mask bit; it merely toggles between MSI and
legacy interrupt delivery. The proper mask bit is HPET_TN_ENABLE, so
use both bits when (un)masking the interrupt.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/hpet.c         |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- 3.7-rc3/arch/x86/kernel/hpet.c
+++ 3.7-rc3-x86-hpet-masking/arch/x86/kernel/hpet.c
@@ -434,7 +434,7 @@ void hpet_msi_unmask(struct irq_data *da
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg |= HPET_TN_FSB;
+	cfg |= HPET_TN_ENABLE | HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
@@ -445,7 +445,7 @@ void hpet_msi_mask(struct irq_data *data
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg &= ~HPET_TN_FSB;
+	cfg &= ~(HPET_TN_ENABLE | HPET_TN_FSB);
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2L1TUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:20:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55660 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932433Ab2L1TTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:43 -0500
Message-Id: <20121228190339.173398694@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <JBeulich@suse.com>, Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 044/173] x86: hpet: Fix masking of MSI interrupts
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 6acf5a8c931da9d26c8dd77d784daaf07fa2bff0 upstream.

HPET_TN_FSB is not a proper mask bit; it merely toggles between MSI and
legacy interrupt delivery. The proper mask bit is HPET_TN_ENABLE, so
use both bits when (un)masking the interrupt.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5093E09002000078000A60E6@nat28.tlf.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1460a5d..e28670f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -434,7 +434,7 @@ void hpet_msi_unmask(struct irq_data *data)
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg |= HPET_TN_FSB;
+	cfg |= HPET_TN_ENABLE | HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
@@ -445,7 +445,7 @@ void hpet_msi_mask(struct irq_data *data)
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg &= ~HPET_TN_FSB;
+	cfg &= ~(HPET_TN_ENABLE | HPET_TN_FSB);
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 



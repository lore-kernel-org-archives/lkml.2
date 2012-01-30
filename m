Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2A3V2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:28:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34721 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2A3V2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:28:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.236.124.15 as permitted sender) smtp.mail=glikely@secretlab.ca
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC] powerpc: Make SPARSE_IRQ required
Date: Mon, 30 Jan 2012 11:02:19 -0700
Message-Id: <1327946539-17614-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All IRQs on powerpc are managed via irq_domain anyway, there isn't really
any advantage to turning SPARSE_IRQ off, and it's the direction we want
to take the kernel design anyway.  This patch makes powerpc always use
SPARSE_IRQ.

On pseries_defconfig, SPARSE_IRQ adds only about 0x300 bytes to the
.text sections, and removes about 0x20000 from the data section for the
static irq_desc table.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/Kconfig      |    2 +-
 arch/powerpc/kernel/irq.c |    4 ----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 303703d..1aa840d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -133,7 +133,7 @@ config PPC
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_SPARSE_IRQ
+	select SPARSE_IRQ
 	select IRQ_PER_CPU
 	select IRQ_DOMAIN
 	select GENERIC_IRQ_SHOW
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index e3673ff..282fb39 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -93,10 +93,6 @@ extern int tau_interrupts(int);
 
 #ifdef CONFIG_PPC64
 
-#ifndef CONFIG_SPARSE_IRQ
-EXPORT_SYMBOL(irq_desc);
-#endif
-
 int distribute_irqs = 1;
 
 static inline notrace unsigned long get_hard_enabled(void)
-- 
1.7.5.4


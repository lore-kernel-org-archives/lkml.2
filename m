Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab2AHNdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 08:33:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2AHNd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 08:33:29 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [RFC PATCH v2 4/9] alpha: avoid using on_each_cpu hard coded ret value
Date: Sun,  8 Jan 2012 15:32:24 +0200
Message-Id: <1326029549-2794-5-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
References: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on_each_cpu always returns a hard coded return code of zero.

Removing all tests based on this return value saves run time
cycles for compares and code bloat for branches.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
CC: Richard Henderson <rth@twiddle.net>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Matt Turner <mattst88@gmail.com>
CC: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/smp.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 4087a56..97707e9 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -659,8 +659,7 @@ void
 smp_imb(void)
 {
 	/* Must wait other processors to flush their icache before continue. */
-	if (on_each_cpu(ipi_imb, NULL, 1))
-		printk(KERN_CRIT "smp_imb: timed out\n");
+	on_each_cpu(ipi_imb, NULL, 1);
 }
 EXPORT_SYMBOL(smp_imb);
 
@@ -675,9 +674,7 @@ flush_tlb_all(void)
 {
 	/* Although we don't have any data to pass, we do want to
 	   synchronize with the other processors.  */
-	if (on_each_cpu(ipi_flush_tlb_all, NULL, 1)) {
-		printk(KERN_CRIT "flush_tlb_all: timed out\n");
-	}
+	on_each_cpu(ipi_flush_tlb_all, NULL, 1);
 }
 
 #define asn_locked() (cpu_data[smp_processor_id()].asn_lock)
-- 
1.7.0.4


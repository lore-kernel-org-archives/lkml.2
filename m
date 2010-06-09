Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab0FILVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:21:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37169 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757317Ab0FILVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:21:10 -0400
Date: Wed, 9 Jun 2010 13:21:08 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Ralf Baechle <ralf@linux-mips.org>, Gilles Espinasse <g.esp@free.fr>,
       Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/9] Removing dead CONFIG_SIBYTE_BCM1480_PROF
Message-ID: <c217f4530c057f4b8030bd14459a0cb2856decde.1275925108.git.siccegge@cs.fau.de>
References: <cover.1275925108.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925108.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SIBYTE_BCM1480_PROF doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/mips/sibyte/bcm1480/irq.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 044bbe4..919d2d5 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -362,19 +362,8 @@ asmlinkage void plat_irq_dispatch(void)
 	unsigned int cpu = smp_processor_id();
 	unsigned int pending;
 
-#ifdef CONFIG_SIBYTE_BCM1480_PROF
-	/* Set compare to count to silence count/compare timer interrupts */
-	write_c0_compare(read_c0_count());
-#endif
-
 	pending = read_c0_cause() & read_c0_status();
 
-#ifdef CONFIG_SIBYTE_BCM1480_PROF
-	if (pending & CAUSEF_IP7)	/* Cpu performance counter interrupt */
-		sbprof_cpu_intr();
-	else
-#endif
-
 	if (pending & CAUSEF_IP4)
 		do_IRQ(K_BCM1480_INT_TIMER_0 + cpu);
 #ifdef CONFIG_SMP
-- 
1.6.3.3


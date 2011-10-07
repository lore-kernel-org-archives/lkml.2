Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab1JGR11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:27:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38526 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1JGR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:27:25 -0400
From: Nasir Abed <nasirabed@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        venki@google.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Nasir Abed <nasirabed+kernel@gmail.com>
Subject: [PATCH 1/1] x86: removed deprecated IRQF_DISABLED
Date: Fri,  7 Oct 2011 19:26:20 +0200
Message-Id: <1318008380-3379-2-git-send-email-nasirabed+kernel@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318008380-3379-1-git-send-email-nasirabed+kernel@gmail.com>
References: <1318008380-3379-1-git-send-email-nasirabed+kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nasir Abed <nasirabed+kernel@gmail.com>
---
 arch/x86/include/asm/floppy.h |    4 ++--
 arch/x86/kernel/hpet.c        |    2 +-
 arch/x86/kernel/time.c        |    2 +-
 arch/x86/xen/smp.c            |    8 ++++----
 arch/x86/xen/spinlock.c       |    2 +-
 arch/x86/xen/time.c           |    5 ++---
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/floppy.h b/arch/x86/include/asm/floppy.h
index dbe82a5..22bf4d6 100644
--- a/arch/x86/include/asm/floppy.h
+++ b/arch/x86/include/asm/floppy.h
@@ -145,10 +145,10 @@ static int fd_request_irq(void)
 {
 	if (can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static unsigned long dma_mem_alloc(unsigned long size)
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4aecc54..9d96096 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -515,7 +515,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_TIMER | IRQF_NOBALANCING,
 			dev->name, dev))
 		return -1;
 
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 5a64d05..e62386a 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -70,7 +70,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.flags = IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
 	.name = "timer"
 };
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 041d4fe..a375a75 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -100,7 +100,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
 				    cpu,
 				    xen_reschedule_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    resched_name,
 				    NULL);
 	if (rc < 0)
@@ -111,7 +111,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
 				    cpu,
 				    xen_call_function_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
 	if (rc < 0)
@@ -120,7 +120,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 
 	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
 	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
-				     IRQF_DISABLED | IRQF_PERCPU | IRQF_NOBALANCING,
+				     IRQF_PERCPU | IRQF_NOBALANCING,
 				     debug_name, NULL);
 	if (rc < 0)
 		goto fail;
@@ -130,7 +130,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
 				    cpu,
 				    xen_call_function_single_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
 	if (rc < 0)
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index cc9b1e1..27882f5 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -354,7 +354,7 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
 				     dummy_handler,
-				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				     IRQF_PERCPU|IRQF_NOBALANCING,
 				     name,
 				     NULL);
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 163b467..1889b8e 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -394,9 +394,8 @@ void xen_setup_timer(int cpu)
 		name = "<timer kasprintf failed>";
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|
-				      IRQF_NOBALANCING|IRQF_TIMER|
-				      IRQF_FORCE_RESUME,
+				      IRQF_PERCPU|IRQF_NOBALANCING|
+				      IRQF_TIMER|IRQF_FORCE_RESUME,
 				      name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);
-- 
1.7.4.1


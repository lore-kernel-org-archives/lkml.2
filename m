Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1IUJbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:31:25 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:49741 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1IUJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:31:21 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        James Bottomley <James.Bottomley@suse.de>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 14/57] parisc: irq: remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:15 +0800
Message-Id: <1316597339-29861-15-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 arch/parisc/include/asm/floppy.h |    4 ++--
 arch/parisc/kernel/irq.c         |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/include/asm/floppy.h b/arch/parisc/include/asm/floppy.h
index 4ca69f5..f84ff12 100644
--- a/arch/parisc/include/asm/floppy.h
+++ b/arch/parisc/include/asm/floppy.h
@@ -157,10 +157,10 @@ static int fd_request_irq(void)
 {
 	if(can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static unsigned long dma_mem_alloc(unsigned long size)
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index c0b1aff..420676b 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -379,14 +379,14 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
+	.flags = IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
 };
 
 #ifdef CONFIG_SMP
 static struct irqaction ipi_action = {
 	.handler = ipi_interrupt,
 	.name = "IPI",
-	.flags = IRQF_DISABLED | IRQF_PERCPU,
+	.flags = IRQF_PERCPU,
 };
 #endif
 
-- 
1.7.4.1


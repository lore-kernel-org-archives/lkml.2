Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1IUJ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:29:30 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:49741 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1IUJ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:29:27 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Kyle McMartin <kyle@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-alpha@vger.kernel.org
Subject: [PATCH 02/57] alpha: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:03 +0800
Message-Id: <1316597339-29861-3-git-send-email-yong.zhang0@gmail.com>
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
 arch/alpha/include/asm/floppy.h |    2 +-
 arch/alpha/kernel/irq_alpha.c   |    1 -
 arch/alpha/kernel/sys_titan.c   |   14 +++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/include/asm/floppy.h b/arch/alpha/include/asm/floppy.h
index 46cefbd..bae97eb 100644
--- a/arch/alpha/include/asm/floppy.h
+++ b/arch/alpha/include/asm/floppy.h
@@ -26,7 +26,7 @@
 #define fd_disable_irq()        disable_irq(FLOPPY_IRQ)
 #define fd_cacheflush(addr,size) /* nothing */
 #define fd_request_irq()        request_irq(FLOPPY_IRQ, floppy_interrupt,\
-					    IRQF_DISABLED, "floppy", NULL)
+					    0, "floppy", NULL)
 #define fd_free_irq()           free_irq(FLOPPY_IRQ, NULL)
 
 #ifdef CONFIG_PCI
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 51b7fbd..e0312e8 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -221,7 +221,6 @@ process_mcheck_info(unsigned long vector, unsigned long la_ptr,
 
 struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED,
 	.name		= "timer",
 };
 
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index f47b30a..f96dc81 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -281,15 +281,15 @@ titan_late_init(void)
 	 * all reported to the kernel as machine checks, so the handler
 	 * is a nop so it can be called to count the individual events.
 	 */
-	titan_request_irq(63+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(63+16, titan_intr_nop, 0,
 		    "CChip Error", NULL);
-	titan_request_irq(62+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(62+16, titan_intr_nop, 0,
 		    "PChip 0 H_Error", NULL);
-	titan_request_irq(61+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(61+16, titan_intr_nop, 0,
 		    "PChip 1 H_Error", NULL);
-	titan_request_irq(60+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(60+16, titan_intr_nop, 0,
 		    "PChip 0 C_Error", NULL);
-	titan_request_irq(59+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(59+16, titan_intr_nop, 0,
 		    "PChip 1 C_Error", NULL);
 
 	/* 
@@ -348,9 +348,9 @@ privateer_init_pci(void)
 	 * Hook a couple of extra err interrupts that the
 	 * common titan code won't.
 	 */
-	titan_request_irq(53+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(53+16, titan_intr_nop, 0,
 		    "NMI", NULL);
-	titan_request_irq(50+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(50+16, titan_intr_nop, 0,
 		    "Temperature Warning", NULL);
 
 	/*
-- 
1.7.4.1


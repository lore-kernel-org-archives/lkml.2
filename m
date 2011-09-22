Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1IVJLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:11:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40391 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1IVJAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:00:35 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        David Howells <dhowells@redhat.com>, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 06/55] frv: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:33 +0800
Message-Id: <1316681962-8217-7-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/irq-mb93091.c |    8 ++++----
 arch/frv/kernel/irq-mb93093.c |    1 -
 arch/frv/kernel/irq-mb93493.c |    4 ++--
 arch/frv/kernel/time.c        |    1 -
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/frv/kernel/irq-mb93091.c b/arch/frv/kernel/irq-mb93091.c
index 9afc2ea..f4dfc0b 100644
--- a/arch/frv/kernel/irq-mb93091.c
+++ b/arch/frv/kernel/irq-mb93091.c
@@ -108,25 +108,25 @@ static irqreturn_t fpga_interrupt(int irq, void *_mask)
 static struct irqaction fpga_irq[4]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0028UL,
 	},
 	[1] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.1",
 		.dev_id		= (void *) 0x0050UL,
 	},
 	[2] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.2",
 		.dev_id		= (void *) 0x1c00UL,
 	},
 	[3] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.3",
 		.dev_id		= (void *) 0x6386UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93093.c b/arch/frv/kernel/irq-mb93093.c
index 4d4ad09..bac526d 100644
--- a/arch/frv/kernel/irq-mb93093.c
+++ b/arch/frv/kernel/irq-mb93093.c
@@ -106,7 +106,6 @@ static irqreturn_t fpga_interrupt(int irq, void *_mask)
 static struct irqaction fpga_irq[1]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0700UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93493.c b/arch/frv/kernel/irq-mb93493.c
index 4d034c7..b632726 100644
--- a/arch/frv/kernel/irq-mb93493.c
+++ b/arch/frv/kernel/irq-mb93493.c
@@ -119,13 +119,13 @@ static irqreturn_t mb93493_interrupt(int irq, void *_piqsr)
 static struct irqaction mb93493_irq[2]  = {
 	[0] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "mb93493.0",
 		.dev_id		= (void *) __addr_MB93493_IQSR(0),
 	},
 	[1] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "mb93493.1",
 		.dev_id		= (void *) __addr_MB93493_IQSR(1),
 	}
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index b457de4..332e00b 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -44,7 +44,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy);
 
 static struct irqaction timer_irq  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "timer",
 };
 
-- 
1.7.4.1


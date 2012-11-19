Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2KSFc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:32:58 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51700 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab2KSFc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:32:56 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 50/58] x86: arch/x86/kernel/irq_work.c: Add prototype for smp_irq_work_interrupt
Date: Sun, 18 Nov 2012 21:28:29 -0800
Message-Id: <1353302917-13995-51-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/irq_work.c defines a function smp_irq_work_interrupt,
only called from assembly.  Add a prototype right before its definition,
to satisfy GCC (-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/irq_work.c:12:6: warning: no previous prototype for ‘smp_irq_work_interrupt’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/irq_work.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..7c25e97 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -9,6 +9,8 @@
 #include <linux/hardirq.h>
 #include <asm/apic.h>
 
+void smp_irq_work_interrupt(struct pt_regs *regs);
+
 void smp_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
-- 
1.7.10.4


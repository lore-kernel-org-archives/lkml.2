Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0JOEFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:05:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0JOEFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:05:32 -0400
Date: Fri, 15 Oct 2010 00:05:31 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        kyle@mcmartin.ca
Subject: [PATCH 4/4] cris: turn on GENERIC_HARDIRQS_NO__DO_IRQ
Message-ID: <20101015040531.GE6333@bombadil.infradead.org>
References: <20101015040127.GA6333@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015040127.GA6333@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we no longer require __do_IRQ.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/cris/Kconfig           |    3 +++
 arch/cris/include/asm/irq.h |    3 ---
 arch/cris/kernel/irq.c      |    4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index aefe3b1..459d4f7 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -78,6 +78,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
 config ETRAX_CMDLINE
 	string "Kernel command line"
 	default "root=/dev/mtdblock3"
diff --git a/arch/cris/include/asm/irq.h b/arch/cris/include/asm/irq.h
index 3406c68..ce0fcf5 100644
--- a/arch/cris/include/asm/irq.h
+++ b/arch/cris/include/asm/irq.h
@@ -8,9 +8,6 @@ static inline int irq_canonicalize(int irq)
   return irq; 
 }
 
-struct irq_desc;
-extern void cris_do_IRQ(unsigned int irq, struct irq_desc *desc);
-
 #endif  /* _ASM_IRQ_H */
 
 
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index b6d54eb..14d9ce9 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -105,7 +105,3 @@ void weird_irq(void)
 	while(1);
 }
 
-void cris_do_IRQ(unsigned int irq, struct irq_desc *desc)
-{
-	__do_IRQ(irq);
-}
-- 
1.7.3.1


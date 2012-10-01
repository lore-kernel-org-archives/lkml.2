Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2JAMd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:33:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53597 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2JAMdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:33:55 -0400
Date: Mon, 1 Oct 2012 14:33:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core changes for v3.7
Message-ID: <20121001123350.GA21952@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

   HEAD: 17d83127d4c2b322dd8f217e0ac08c66eb403779 genirq: Export dummy_irq_chip

Two symbol exports for modular irq-chip drivers.

 Thanks,

	Ingo

------------------>
Kuninori Morimoto (2):
      genirq: Export irq_set_chip_and_handler_name()
      genirq: Export dummy_irq_chip


 kernel/irq/chip.c      | 1 +
 kernel/irq/dummychip.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..57d86d0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -671,6 +671,7 @@ irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 	irq_set_chip(irq, chip);
 	__irq_set_handler(irq, handle, 0, name);
 }
+EXPORT_SYMBOL_GPL(irq_set_chip_and_handler_name);
 
 void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 {
diff --git a/kernel/irq/dummychip.c b/kernel/irq/dummychip.c
index b5fcd96..988dc58 100644
--- a/kernel/irq/dummychip.c
+++ b/kernel/irq/dummychip.c
@@ -6,6 +6,7 @@
  */
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/export.h>
 
 #include "internals.h"
 
@@ -57,3 +58,4 @@ struct irq_chip dummy_irq_chip = {
 	.irq_mask	= noop,
 	.irq_unmask	= noop,
 };
+EXPORT_SYMBOL_GPL(dummy_irq_chip);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab1D3U4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:56:25 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:59862 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1D3U4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:56:24 -0400
Date: Sat, 30 Apr 2011 22:56:20 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] genirq: Fix typo CONFIG_GENIRC_IRQ_SHOW_LEVEL
Message-ID: <alpine.DEB.2.00.1104302251370.19068@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ab7798ffcf98b11a9525cf65bacdae3fd58d357f ("genirq: Expand generic
show_interrupts()") added the Kconfig option GENERIC_IRQ_SHOW_LEVEL to
accomodate PowerPC, but this doesn't actually enable the functionality due
to a typo in the #ifdef check.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/irq/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index dd201bd..834899f 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -419,7 +419,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	} else {
 		seq_printf(p, " %8s", "None");
 	}
-#ifdef CONFIG_GENIRC_IRQ_SHOW_LEVEL
+#ifdef CONFIG_GENERIC_IRQ_SHOW_LEVEL
 	seq_printf(p, " %-8s", irqd_is_level_type(&desc->irq_data) ? "Level" : "Edge");
 #endif
 	if (desc->name)
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

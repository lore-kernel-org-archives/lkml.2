Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1ASV4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:56:36 -0500
Received: from www.tglx.de ([62.245.132.106]:33338 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1ASVtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:14 -0500
Message-Id: <20110119210839.162689615@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mikael Starvik <starvik@axis.com>
Subject: [patch 07/37] cris: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=cris-cleanup-kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic irq Kconfig. Select GENERIC_HARDIRQS_NO_DEPRECATED as
we have converted all irq_chip functions. Fix the fallout in
show_interrupts().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
---
 arch/cris/Kconfig      |    6 ++----
 arch/cris/kernel/irq.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/cris/Kconfig
===================================================================
--- linux-2.6.orig/arch/cris/Kconfig
+++ linux-2.6/arch/cris/Kconfig
@@ -54,6 +54,8 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config HZ
 	int
@@ -67,10 +69,6 @@ menu "General setup"
 
 source "fs/Kconfig.binfmt"
 
-config GENERIC_HARDIRQS
-	bool
-	default y
-
 config ETRAX_CMDLINE
 	string "Kernel command line"
 	default "root=/dev/mtdblock3"
Index: linux-2.6/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/irq.c
+++ linux-2.6/arch/cris/kernel/irq.c
@@ -62,7 +62,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, " %14s", irq_desc[i].irq_data.chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)



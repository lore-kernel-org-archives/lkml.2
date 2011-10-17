Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1JQCHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 22:07:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51614 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1JQCHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 22:07:37 -0400
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH v2 1/2] irq: Add EXPORT_SYMBOL_GPL to function of irq generic-chip
Date: Mon, 17 Oct 2011 11:08:46 +0900
Message-Id: <1318817327-4589-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions of irq generic-chip is undefined, because
EXPORT_SYMBOL_GPL is not set to these.

-----
ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
-----

This is revised that EXPORT_SYMBOL_GPL can be added and referred
to in functions.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---

V2: Add EXPORT_SYMBOL_GPL to irq_setup_generic_chip, irq_alloc_generic_chip,
irq_setup_alt_chip and irq_remove_generic_chip only.

 kernel/irq/generic-chip.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index e38544d..6cb7613 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -211,6 +211,7 @@ irq_alloc_generic_chip(const char *name, int num_ct, unsigned int irq_base,
 	}
 	return gc;
 }
+EXPORT_SYMBOL_GPL(irq_alloc_generic_chip);
 
 /*
  * Separate lockdep class for interrupt chip which can nest irq_desc
@@ -258,6 +259,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	}
 	gc->irq_cnt = i - gc->irq_base;
 }
+EXPORT_SYMBOL_GPL(irq_setup_generic_chip);
 
 /**
  * irq_setup_alt_chip - Switch to alternative chip
@@ -281,6 +283,7 @@ int irq_setup_alt_chip(struct irq_data *d, unsigned int type)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(irq_setup_alt_chip);
 
 /**
  * irq_remove_generic_chip - Remove a chip
@@ -311,6 +314,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		irq_modify_status(i, clr, set);
 	}
 }
+EXPORT_SYMBOL_GPL(irq_remove_generic_chip);
 
 #ifdef CONFIG_PM
 static int irq_gc_suspend(void)
-- 
1.7.7


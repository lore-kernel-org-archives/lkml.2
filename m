Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2JIPX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:23:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JIPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Magnus Damm <damm@opensource.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/9] ARM: export set_irq_flags
Date: Tue,  9 Oct 2012 17:22:56 +0200
Message-Id: <1349796183-30648-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UKrqZGtRVZdk5/T2Jj8mdbZvqutraIuxHn5LfXd/PF7
 lTZLfT2gN1+VJIijix/uSfsFAOg4jhJbAd+K7Xvh2tAVjHmQlw
 cu4v2eu+wFc14+Dcu5dYHF+yZoTYOa8uDbnPgSzStH6xod7XvJ
 CMhA1ggpALihm2RjpbdPNJzj1xtP96LHDtrXPihBCGSrJicEhJ
 UG7qhgGASpKHrVkZ2dVe9juS8KcabMwv5ZPgpb4taWZ8i+J4xT
 XyZaQ/qUWjaJKaJBm9bsBKLftvzLYrnsc3rdJjxB3ad4U6k1oO
 Sb3GRsmqFvAA85nvL4+QJbOzSmW8huodYEApyut0+CxulFVLSJ
 K2g5aOVpLaS9e7LygwQ1SFPPdbCEcwMYThNOmTttQWLl/GuTLQ
 nwo0AQbu/SD9A0pjTzDqcPOkot95cmWS+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently added Emma Mobile GPIO driver calls set_irq_flags
and irq_set_chip_and_handler for the interrupts it exports and
it can be built as a module, which currently fails with

ERROR: "set_irq_flags" [drivers/gpio/gpio-em.ko] undefined!

We either need to replace the call to set_irq_flags with something
else or export that function. This patch does the latter.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Magnus Damm <damm@opensource.se>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/irq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 16cedb4..8961650 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -34,6 +34,7 @@
 #include <linux/list.h>
 #include <linux/kallsyms.h>
 #include <linux/proc_fs.h>
+#include <linux/export.h>
 
 #include <asm/exception.h>
 #include <asm/mach/arch.h>
@@ -109,6 +110,7 @@ void set_irq_flags(unsigned int irq, unsigned int iflags)
 	/* Order is clear bits in "clr" then set bits in "set" */
 	irq_modify_status(irq, clr, set & ~clr);
 }
+EXPORT_SYMBOL_GPL(set_irq_flags);
 
 void __init init_IRQ(void)
 {
-- 
1.7.10


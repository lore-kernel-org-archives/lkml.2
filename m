Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2BWO0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:41 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:1112 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab2BWO0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:38 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de
Subject: [PATCH v3 01/21] ARM: at91: factorise duplicated at91sam9 idle
Date: Thu, 23 Feb 2012 15:25:45 +0100
Message-Id: <0d78171672a30e8ec8084f54a557e9948260356d.1330006537.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Remove duplicated at91sam9xxxx_idle() functions introduced
by commit c9dfafb "ARM: mach-at91: move special idle code out of line".
Replace by a generic at91sam9_idle() function in setup.c common
location.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9260.c |    8 +-------
 arch/arm/mach-at91/at91sam9261.c |    8 +-------
 arch/arm/mach-at91/at91sam9263.c |    8 +-------
 arch/arm/mach-at91/at91sam9g45.c |    8 +-------
 arch/arm/mach-at91/at91sam9rl.c  |    8 +-------
 arch/arm/mach-at91/clock.c       |    8 ++++++++
 arch/arm/mach-at91/generic.h     |    3 +++
 7 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 9ac8c6f..e965332 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -329,15 +329,9 @@ static void __init at91sam9260_ioremap_registers(void)
 	at91sam9_ioremap_smc(0, AT91SAM9260_BASE_SMC);
 }
 
-static void at91sam9260_idle(void)
-{
-	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-	cpu_do_idle();
-}
-
 static void __init at91sam9260_initialize(void)
 {
-	arm_pm_idle = at91sam9260_idle;
+	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
 	at91_extern_irq = (1 << AT91SAM9260_ID_IRQ0) | (1 << AT91SAM9260_ID_IRQ1)
 			| (1 << AT91SAM9260_ID_IRQ2);
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index ab76868..d7f51d6 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -287,15 +287,9 @@ static void __init at91sam9261_ioremap_registers(void)
 	at91sam9_ioremap_smc(0, AT91SAM9261_BASE_SMC);
 }
 
-static void at91sam9261_idle(void)
-{
-	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-	cpu_do_idle();
-}
-
 static void __init at91sam9261_initialize(void)
 {
-	arm_pm_idle = at91sam9261_idle;
+	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
 	at91_extern_irq = (1 << AT91SAM9261_ID_IRQ0) | (1 << AT91SAM9261_ID_IRQ1)
 			| (1 << AT91SAM9261_ID_IRQ2);
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 247ab63..8bdba2a 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -308,15 +308,9 @@ static void __init at91sam9263_ioremap_registers(void)
 	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
 }
 
-static void at91sam9263_idle(void)
-{
-	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-	cpu_do_idle();
-}
-
 static void __init at91sam9263_initialize(void)
 {
-	arm_pm_idle = at91sam9263_idle;
+	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
 	at91_extern_irq = (1 << AT91SAM9263_ID_IRQ0) | (1 << AT91SAM9263_ID_IRQ1);
 
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 5b12192..5d2ff90 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -317,12 +317,6 @@ static struct at91_gpio_bank at91sam9g45_gpio[] __initdata = {
 	}
 };
 
-static void at91sam9g45_idle(void)
-{
-	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-	cpu_do_idle();
-}
-
 /* --------------------------------------------------------------------
  *  AT91SAM9G45 processor initialization
  * -------------------------------------------------------------------- */
@@ -343,7 +337,7 @@ static void __init at91sam9g45_ioremap_registers(void)
 
 static void __init at91sam9g45_initialize(void)
 {
-	arm_pm_idle = at91sam9g45_idle;
+	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9g45_restart;
 	at91_extern_irq = (1 << AT91SAM9G45_ID_IRQ0);
 
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index fd60e22..e86c50b 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -292,15 +292,9 @@ static void __init at91sam9rl_ioremap_registers(void)
 	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
 }
 
-static void at91sam9rl_idle(void)
-{
-	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-	cpu_do_idle();
-}
-
 static void __init at91sam9rl_initialize(void)
 {
-	arm_pm_idle = at91sam9rl_idle;
+	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
 	at91_extern_irq = (1 << AT91SAM9RL_ID_IRQ0);
 
diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index a5291e0..d1b4e07 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -28,6 +28,8 @@
 #include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
+#include <asm/proc-fns.h>
+
 #include "clock.h"
 #include "generic.h"
 
@@ -818,3 +820,9 @@ static int __init at91_clock_reset(void)
 	return 0;
 }
 late_initcall(at91_clock_reset);
+
+void at91sam9_idle(void)
+{
+	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
+	cpu_do_idle();
+}
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 7e8280e..4e322f34 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -56,6 +56,9 @@ struct device;
 extern void at91_irq_suspend(void);
 extern void at91_irq_resume(void);
 
+/* idle */
+extern void at91sam9_idle(void);
+
 /* reset */
 extern void at91_ioremap_rstc(u32 base_addr);
 extern void at91sam9_alt_restart(char, const char *);
-- 
1.7.9


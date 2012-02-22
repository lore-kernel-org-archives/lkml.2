Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2BVJkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:40:09 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:31161 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVJkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:40:00 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk
Subject: [PATCH v2 06/19] ARM: at91/pm_slowclock: rename register to named define
Date: Wed, 22 Feb 2012 10:39:32 +0100
Message-Id: <cce50d2859ae080d6bfd9260fcd6932d634f7b9a.1329903206.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

This patch will give a name to ARM registers in the assembly
source code (using #defines). It is done to simplify the code
reading and the passing of parameters to functions.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/pm_slowclock.S |  177 +++++++++++++++++++------------------
 1 files changed, 91 insertions(+), 86 deletions(-)

diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index f8539a8..97124f5 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -46,17 +46,22 @@
 #define PLLALOCK_TIMEOUT	1000
 #define PLLBLOCK_TIMEOUT	1000
 
+#define pmc	r1
+#define sdramc	r2
+#define tmp1	r3
+#define tmp2	r4
+#define ramc1	r5
 
 /*
  * Wait until master clock is ready (after switching master clock source)
  */
 	.macro wait_mckrdy
-	mov	r4, #MCKRDY_TIMEOUT
-1:	sub	r4, r4, #1
-	cmp	r4, #0
+	mov	tmp2, #MCKRDY_TIMEOUT
+1:	sub	tmp2, tmp2, #1
+	cmp	tmp2, #0
 	beq	2f
-	ldr	r3, [r1, #(AT91_PMC_SR - AT91_PMC)]
-	tst	r3, #AT91_PMC_MCKRDY
+	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
+	tst	tmp1, #AT91_PMC_MCKRDY
 	beq	1b
 2:
 	.endm
@@ -65,12 +70,12 @@
  * Wait until master oscillator has stabilized.
  */
 	.macro wait_moscrdy
-	mov	r4, #MOSCRDY_TIMEOUT
-1:	sub	r4, r4, #1
-	cmp	r4, #0
+	mov	tmp2, #MOSCRDY_TIMEOUT
+1:	sub	tmp2, tmp2, #1
+	cmp	tmp2, #0
 	beq	2f
-	ldr	r3, [r1, #(AT91_PMC_SR - AT91_PMC)]
-	tst	r3, #AT91_PMC_MOSCS
+	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
+	tst	tmp1, #AT91_PMC_MOSCS
 	beq	1b
 2:
 	.endm
@@ -79,12 +84,12 @@
  * Wait until PLLA has locked.
  */
 	.macro wait_pllalock
-	mov	r4, #PLLALOCK_TIMEOUT
-1:	sub	r4, r4, #1
-	cmp	r4, #0
+	mov	tmp2, #PLLALOCK_TIMEOUT
+1:	sub	tmp2, tmp2, #1
+	cmp	tmp2, #0
 	beq	2f
-	ldr	r3, [r1, #(AT91_PMC_SR - AT91_PMC)]
-	tst	r3, #AT91_PMC_LOCKA
+	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
+	tst	tmp1, #AT91_PMC_LOCKA
 	beq	1b
 2:
 	.endm
@@ -93,12 +98,12 @@
  * Wait until PLLB has locked.
  */
 	.macro wait_pllblock
-	mov	r4, #PLLBLOCK_TIMEOUT
-1:	sub	r4, r4, #1
-	cmp	r4, #0
+	mov	tmp2, #PLLBLOCK_TIMEOUT
+1:	sub	tmp2, tmp2, #1
+	cmp	tmp2, #0
 	beq	2f
-	ldr	r3, [r1, #(AT91_PMC_SR - AT91_PMC)]
-	tst	r3, #AT91_PMC_LOCKB
+	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
+	tst	tmp1, #AT91_PMC_LOCKB
 	beq	1b
 2:
 	.endm
@@ -117,55 +122,55 @@ ENTRY(at91_slow_clock)
 	 *  R4 = temporary register
 	 *  R5 = Base address of second RAM Controller or 0 if not present
 	 */
-	ldr	r1, .at91_va_base_pmc
-	ldr	r2, .at91_va_base_sdramc
-	ldr	r5, .at91_va_base_ramc1
+	ldr	pmc, .at91_va_base_pmc
+	ldr	sdramc, .at91_va_base_sdramc
+	ldr	ramc1, .at91_va_base_ramc1
 
 	/* Drain write buffer */
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4
+	mov	tmp1, #0
+	mcr	p15, 0, tmp1, c7, c10, 4
 
 #ifdef CONFIG_ARCH_AT91RM9200
 	/* Put SDRAM in self-refresh mode */
-	mov	r3, #1
-	str	r3, [r2, #AT91_SDRAMC_SRR]
+	mov	tmp1, #1
+	str	tmp1, [sdramc, #AT91_SDRAMC_SRR]
 #elif defined(CONFIG_ARCH_AT91SAM9G45)
 
 	/* prepare for DDRAM self-refresh mode */
-	ldr	r3, [r2, #AT91_DDRSDRC_LPR]
-	str	r3, .saved_sam9_lpr
-	bic	r3, #AT91_DDRSDRC_LPCB
-	orr	r3, #AT91_DDRSDRC_LPCB_SELF_REFRESH
+	ldr	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
+	str	tmp1, .saved_sam9_lpr
+	bic	tmp1, #AT91_DDRSDRC_LPCB
+	orr	tmp1, #AT91_DDRSDRC_LPCB_SELF_REFRESH
 
 	/* figure out if we use the second ram controller */
-	cmp	r5, #0
-	ldrne	r4, [r5, #AT91_DDRSDRC_LPR]
-	strne	r4, .saved_sam9_lpr1
-	bicne	r4, #AT91_DDRSDRC_LPCB
-	orrne	r4, #AT91_DDRSDRC_LPCB_SELF_REFRESH
+	cmp	ramc1, #0
+	ldrne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
+	strne	tmp2, .saved_sam9_lpr1
+	bicne	tmp2, #AT91_DDRSDRC_LPCB
+	orrne	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
 
 	/* Enable DDRAM self-refresh mode */
-	str	r3, [r2, #AT91_DDRSDRC_LPR]
-	strne	r4, [r5, #AT91_DDRSDRC_LPR]
+	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
+	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
 #else
 	/* Enable SDRAM self-refresh mode */
-	ldr	r3, [r2, #AT91_SDRAMC_LPR]
-	str	r3, .saved_sam9_lpr
+	ldr	tmp1, [sdramc, #AT91_SDRAMC_LPR]
+	str	tmp1, .saved_sam9_lpr
 
-	bic	r3, #AT91_SDRAMC_LPCB
-	orr	r3, #AT91_SDRAMC_LPCB_SELF_REFRESH
-	str	r3, [r2, #AT91_SDRAMC_LPR]
+	bic	tmp1, #AT91_SDRAMC_LPCB
+	orr	tmp1, #AT91_SDRAMC_LPCB_SELF_REFRESH
+	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
 #endif
 
 	/* Save Master clock setting */
-	ldr	r3, [r1, #(AT91_PMC_MCKR - AT91_PMC)]
-	str	r3, .saved_mckr
+	ldr	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
+	str	tmp1, .saved_mckr
 
 	/*
 	 * Set the Master clock source to slow clock
 	 */
-	bic	r3, r3, #AT91_PMC_CSS
-	str	r3, [r1, #(AT91_PMC_MCKR - AT91_PMC)]
+	bic	tmp1, tmp1, #AT91_PMC_CSS
+	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
 
 	wait_mckrdy
 
@@ -175,61 +180,61 @@ ENTRY(at91_slow_clock)
 	 *
 	 * See AT91RM9200 errata #27 and #28 for details.
 	 */
-	mov	r3, #0
-	str	r3, [r1, #(AT91_PMC_MCKR - AT91_PMC)]
+	mov	tmp1, #0
+	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
 
 	wait_mckrdy
 #endif
 
 	/* Save PLLA setting and disable it */
-	ldr	r3, [r1, #(AT91_CKGR_PLLAR - AT91_PMC)]
-	str	r3, .saved_pllar
+	ldr	tmp1, [pmc, #(AT91_CKGR_PLLAR - AT91_PMC)]
+	str	tmp1, .saved_pllar
 
-	mov	r3, #AT91_PMC_PLLCOUNT
-	orr	r3, r3, #(1 << 29)		/* bit 29 always set */
-	str	r3, [r1, #(AT91_CKGR_PLLAR - AT91_PMC)]
+	mov	tmp1, #AT91_PMC_PLLCOUNT
+	orr	tmp1, tmp1, #(1 << 29)		/* bit 29 always set */
+	str	tmp1, [pmc, #(AT91_CKGR_PLLAR - AT91_PMC)]
 
 	/* Save PLLB setting and disable it */
-	ldr	r3, [r1, #(AT91_CKGR_PLLBR - AT91_PMC)]
-	str	r3, .saved_pllbr
+	ldr	tmp1, [pmc, #(AT91_CKGR_PLLBR - AT91_PMC)]
+	str	tmp1, .saved_pllbr
 
-	mov	r3, #AT91_PMC_PLLCOUNT
-	str	r3, [r1, #(AT91_CKGR_PLLBR - AT91_PMC)]
+	mov	tmp1, #AT91_PMC_PLLCOUNT
+	str	tmp1, [pmc, #(AT91_CKGR_PLLBR - AT91_PMC)]
 
 	/* Turn off the main oscillator */
-	ldr	r3, [r1, #(AT91_CKGR_MOR - AT91_PMC)]
-	bic	r3, r3, #AT91_PMC_MOSCEN
-	str	r3, [r1, #(AT91_CKGR_MOR - AT91_PMC)]
+	ldr	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
+	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
+	str	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
 
 	/* Wait for interrupt */
-	mcr	p15, 0, r0, c7, c0, 4
+	mcr	p15, 0, tmp1, c7, c0, 4
 
 	/* Turn on the main oscillator */
-	ldr	r3, [r1, #(AT91_CKGR_MOR - AT91_PMC)]
-	orr	r3, r3, #AT91_PMC_MOSCEN
-	str	r3, [r1, #(AT91_CKGR_MOR - AT91_PMC)]
+	ldr	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
+	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
+	str	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
 
 	wait_moscrdy
 
 	/* Restore PLLB setting */
-	ldr	r3, .saved_pllbr
-	str	r3, [r1, #(AT91_CKGR_PLLBR - AT91_PMC)]
+	ldr	tmp1, .saved_pllbr
+	str	tmp1, [pmc, #(AT91_CKGR_PLLBR - AT91_PMC)]
 
-	tst	r3, #(AT91_PMC_MUL &  0xff0000)
+	tst	tmp1, #(AT91_PMC_MUL &  0xff0000)
 	bne	1f
-	tst	r3, #(AT91_PMC_MUL & ~0xff0000)
+	tst	tmp1, #(AT91_PMC_MUL & ~0xff0000)
 	beq	2f
 1:
 	wait_pllblock
 2:
 
 	/* Restore PLLA setting */
-	ldr	r3, .saved_pllar
-	str	r3, [r1, #(AT91_CKGR_PLLAR - AT91_PMC)]
+	ldr	tmp1, .saved_pllar
+	str	tmp1, [pmc, #(AT91_CKGR_PLLAR - AT91_PMC)]
 
-	tst	r3, #(AT91_PMC_MUL &  0xff0000)
+	tst	tmp1, #(AT91_PMC_MUL &  0xff0000)
 	bne	3f
-	tst	r3, #(AT91_PMC_MUL & ~0xff0000)
+	tst	tmp1, #(AT91_PMC_MUL & ~0xff0000)
 	beq	4f
 3:
 	wait_pllalock
@@ -242,11 +247,11 @@ ENTRY(at91_slow_clock)
 	 *
 	 * See AT91RM9200 errata #27 and #28 for details.
 	 */
-	ldr	r3, .saved_mckr
-	tst	r3, #AT91_PMC_PRES
+	ldr	tmp1, .saved_mckr
+	tst	tmp1, #AT91_PMC_PRES
 	beq	2f
-	and	r3, r3, #AT91_PMC_PRES
-	str	r3, [r1, #(AT91_PMC_MCKR - AT91_PMC)]
+	and	tmp1, tmp1, #AT91_PMC_PRES
+	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
 
 	wait_mckrdy
 #endif
@@ -254,8 +259,8 @@ ENTRY(at91_slow_clock)
 	/*
 	 * Restore master clock setting
 	 */
-2:	ldr	r3, .saved_mckr
-	str	r3, [r1, #(AT91_PMC_MCKR - AT91_PMC)]
+2:	ldr	tmp1, .saved_mckr
+	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
 
 	wait_mckrdy
 
@@ -263,18 +268,18 @@ ENTRY(at91_slow_clock)
 	/* Do nothing - self-refresh is automatically disabled. */
 #elif defined(CONFIG_ARCH_AT91SAM9G45)
 	/* Restore LPR on AT91 with DDRAM */
-	ldr	r3, .saved_sam9_lpr
-	str	r3, [r2, #AT91_DDRSDRC_LPR]
+	ldr	tmp1, .saved_sam9_lpr
+	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
 
 	/* if we use the second ram controller */
-	cmp	r5, #0
-	ldrne	r4, .saved_sam9_lpr1
-	strne	r4, [r5, #AT91_DDRSDRC_LPR]
+	cmp	ramc1, #0
+	ldrne	tmp2, .saved_sam9_lpr1
+	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
 
 #else
 	/* Restore LPR on AT91 with SDRAM */
-	ldr	r3, .saved_sam9_lpr
-	str	r3, [r2, #AT91_SDRAMC_LPR]
+	ldr	tmp1, .saved_sam9_lpr
+	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
 #endif
 
 	/* Restore registers, and return */
-- 
1.7.9


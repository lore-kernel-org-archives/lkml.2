Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2J1Ufu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:35:50 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:46065 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755323Ab2J1Ufr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:35:47 -0400
From: Roland Stigge <stigge@antcom.de>
To: tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        benh@kernel.crashing.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/3] ARM: LPC32xx: Cleanup irq.c
Date: Sun, 28 Oct 2012 21:35:22 +0100
Message-Id: <1351456522-22309-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351456522-22309-1-git-send-email-stigge@antcom.de>
References: <1351456522-22309-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the IRQ mask initialization which is already done some lines
above.

This was actually a bug: The init was supposed to set the bits for the
(chained) SUB IRQs. But this is already fixed by the previous patch, doing this
implicitely via irq_set_chained_handler().

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/irq.c |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/irq.c
+++ linux-2.6/arch/arm/mach-lpc32xx/irq.c
@@ -442,11 +442,6 @@ void __init lpc32xx_init_irq(void)
 	lpc32xx_set_default_mappings(SIC1_APR_DEFAULT, SIC1_ATR_DEFAULT, 32);
 	lpc32xx_set_default_mappings(SIC2_APR_DEFAULT, SIC2_ATR_DEFAULT, 64);
 
-	/* mask all interrupts except SUBIRQ */
-	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_MIC_BASE));
-	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_SIC1_BASE));
-	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_SIC2_BASE));
-
 	/* Initially disable all wake events */
 	__raw_writel(0, LPC32XX_CLKPWR_P01_ER);
 	__raw_writel(0, LPC32XX_CLKPWR_INT_ER);

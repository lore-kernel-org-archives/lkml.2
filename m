Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2BVJlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:41:46 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:43420 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2BVJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:40:19 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk
Subject: [PATCH v2 19/19] ARM: at91/board-dt: move at91_initialize() to init_irq()
Date: Wed, 22 Feb 2012 10:39:45 +0100
Message-Id: <5a6951fcbe28c3093c936d40c4b28f7ae3161d8d.1329903206.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Remove the need for at91_initialize() to be called at init_early().
We move it to init_irq() function as we still need it before the
timer initialization.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-dt.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
index 08c8ad8..8868b3c 100644
--- a/arch/arm/mach-at91/board-dt.c
+++ b/arch/arm/mach-at91/board-dt.c
@@ -34,12 +34,6 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
-{
-	/* Initialize processor: 12.000 MHz crystal */
-	at91_initialize(12000000);
-}
-
 /* det_pin is not connected */
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
@@ -89,6 +83,9 @@ static const struct of_device_id aic_of_match[] __initconst = {
 
 static void __init at91_dt_init_irq(void)
 {
+	/* Initialize processor: 12.000 MHz crystal */
+	at91_initialize(12000000);
+
 	irq_domain_generate_simple(aic_of_match, 0xfffff000, 0);
 	at91_init_irq_default();
 }
@@ -112,7 +109,6 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
 	.timer		= &at91sam926x_timer,
 	.map_io		= at91_map_io,
-	.init_early	= ek_init_early,
 	.init_irq	= at91_dt_init_irq,
 	.init_machine	= at91_dt_device_init,
 	.dt_compat	= at91_dt_board_compat,
-- 
1.7.9


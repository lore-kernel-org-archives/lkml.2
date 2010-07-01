Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0GAHtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:49:33 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:63201 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0GAHtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:49:31 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       siccegge@cs.fau.de, costa.antonior@gmail.com
Cc: linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: Correct configuration define value
Date: Thu,  1 Jul 2010 10:55:45 +0200
Message-Id: <1277974545-30331-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4c6fe9a4c298214223ff89d06401ac7b66f81c98.1277911346.git.siccegge@cs.fau.de>
References: <4c6fe9a4c298214223ff89d06401ac7b66f81c98.1277911346.git.siccegge@cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MTD nand driver for Atmel chips is atmel_nand and not at91_nand anymore.
Change wrong configuration variables that were remaining.

Reported-by: Christoph Egger <siccegge@cs.fau.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Christoph,

Thank you for highlighting this. But please consider this
patch instead of yours.

 arch/arm/mach-at91/board-at572d940hf_ek.c |    2 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/board-at572d940hf_ek.c b/arch/arm/mach-at91/board-at572d940hf_ek.c
index 5daff27..4665162 100644
--- a/arch/arm/mach-at91/board-at572d940hf_ek.c
+++ b/arch/arm/mach-at91/board-at572d940hf_ek.c
@@ -216,7 +216,7 @@ static struct atmel_nand_data __initdata eb_nand_data = {
 /*	.rdy_pin	= AT91_PIN_PC16, */
 	.enable_pin	= AT91_PIN_PA15,
 	.partition_info	= nand_partitions,
-#if defined(CONFIG_MTD_NAND_AT91_BUSWIDTH_16)
+#if defined(CONFIG_MTD_NAND_ATMEL_BUSWIDTH_16)
 	.bus_width_16	= 1,
 #else
 	.bus_width_16	= 0,
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index ee80059..37af9b1 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -135,7 +135,7 @@ static struct atmel_nand_data __initdata ek_nand_data = {
 	.rdy_pin	= AT91_PIN_PC8,
 	.enable_pin	= AT91_PIN_PC14,
 	.partition_info	= nand_partitions,
-#if defined(CONFIG_MTD_NAND_AT91_BUSWIDTH_16)
+#if defined(CONFIG_MTD_NAND_ATMEL_BUSWIDTH_16)
 	.bus_width_16	= 1,
 #else
 	.bus_width_16	= 0,
-- 
1.5.6.5


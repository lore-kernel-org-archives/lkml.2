Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0IJJIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:08:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:41492 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab0IJJIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:08:09 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: dm9000 initialization update
Date: Fri, 10 Sep 2010 12:13:48 +0200
Message-Id: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information in dm9000 mac/phy chip initialization:
- irq resource details
- platform data details

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-sam9261ek.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index c4c8865..b4307ab 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -93,11 +93,12 @@ static struct resource dm9000_resource[] = {
 		.start	= AT91_PIN_PC11,
 		.end	= AT91_PIN_PC11,
 		.flags	= IORESOURCE_IRQ
+			| IORESOURCE_IRQ_LOWEDGE | IORESOURCE_IRQ_HIGHEDGE,
 	}
 };
 
 static struct dm9000_plat_data dm9000_platdata = {
-	.flags		= DM9000_PLATF_16BITONLY,
+	.flags		= DM9000_PLATF_16BITONLY | DM9000_PLATF_NO_EEPROM,
 };
 
 static struct platform_device dm9000_device = {
-- 
1.5.6.5


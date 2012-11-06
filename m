Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab2KFQbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:31:20 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47173 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2KFQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:31:19 -0500
From: Nicolas Royer <nicolas@eukrea.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        plagnioj@jcrosoft.com, eric@eukrea.com,
        Nicolas Royer <nicolas@eukrea.com>
Subject: [PATCH 1/5] ARM: AT91SAM9G45: fix crypto peripherals irq issue due to sparse irq support.
Date: Tue,  6 Nov 2012 17:31:03 +0100
Message-Id: <1352219463-30360-1-git-send-email-nicolas@eukrea.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spare irq support introduced by commit "8fe82a5 ARM: at91: sparse irq support"
involves to add the NR_IRQS_LEGACY offset to irq number.

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric Bénard <eric@eukrea.com>
Tested-by: Eric Bénard <eric@eukrea.com>
Cc: stable@vger.kernel.org # 3.6
---
 arch/arm/mach-at91/at91sam9g45_devices.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index b159607..fcd233c 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1841,8 +1841,8 @@ static struct resource sha_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -1874,8 +1874,8 @@ static struct resource tdes_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -1910,8 +1910,8 @@ static struct resource aes_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
-- 
1.7.6.5


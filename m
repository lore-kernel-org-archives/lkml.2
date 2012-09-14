Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab2INVfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2INVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 18/24] ARM: samsung: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:46 +0200
Message-Id: <1347658492-11608-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1AY76ZbJrQmexTGTuR4wGqen0ftDpkq1krfdrhJyxi6
 Q73ncgnHvJPuW0WAfHZ6uWnzpM5rEshkzsyy9PKeQrma+0LAVu
 K4GzbuQ6SSPenwfhLaKKrLC0G8/3rfqqwzxqSAvSU9Wiu6xDx5
 1+O5fMrGS/OA8wlE35wV8rnAw1JuLU7u+3lFIDc2Sah9QcKTWf
 sbyeEsMLh7iV56pY5rYhS1zyjbUEeK2KUhIG743gPpktwjwC7Z
 nfZAbRUty+3X//Fd9gFD52MRfN5mO4uD1KL1ZqFkDmbFoIA8Bx
 Y0QPYUDVTPfRwFj5umsKc/DwPRi0pzS2yLck3jroybqw3O+jeG
 tWkHKOp7dgw+Uq/GTLnnRxeqAu3gffT+oh6yRdTVwzthdl6tU1
 o3KkdOR7Eeuhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/plat-samsung/s5p-irq-gpioint.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/s5p-irq-gpioint.c b/arch/arm/plat-samsung/s5p-irq-gpioint.c
index f9431fe..23557d3 100644
--- a/arch/arm/plat-samsung/s5p-irq-gpioint.c
+++ b/arch/arm/plat-samsung/s5p-irq-gpioint.c
@@ -24,7 +24,7 @@
 
 #include <asm/mach/irq.h>
 
-#define GPIO_BASE(chip)		(((unsigned long)(chip)->base) & 0xFFFFF000u)
+#define GPIO_BASE(chip)		((void __iomem *)((unsigned long)((chip)->base) & 0xFFFFF000u))
 
 #define CON_OFFSET		0x700
 #define MASK_OFFSET		0x900
@@ -153,7 +153,7 @@ static __init int s5p_gpioint_add(struct samsung_gpio_chip *chip)
 	bank->chips[group - bank->start] = chip;
 
 	gc = irq_alloc_generic_chip("s5p_gpioint", 1, chip->irq_base,
-				    (void __iomem *)GPIO_BASE(chip),
+				    GPIO_BASE(chip),
 				    handle_level_irq);
 	if (!gc)
 		return -ENOMEM;
-- 
1.7.10


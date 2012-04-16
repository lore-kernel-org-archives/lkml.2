Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2DPJX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:23:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:31541 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2DPJVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org,
        Joachim Eastwood <joachim.eastwood@jotron.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 02/12] ARM: at91: Export at91_ramc_base
Date: Mon, 16 Apr 2012 11:20:46 +0200
Message-Id: <9268c6c6fab0b27a01afec8268f7c863783541bf.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <joachim.eastwood@jotron.com>

After commit f363c40 (ARM: at91: make sdram/ddr register base soc independent)
building at91_cf as a module fails with:
  ERROR: "at91_ramc_base" [drivers/pcmcia/at91_cf.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

Export at91_ramc_base symbol to allow drivers using at91_ramc_*
functions to be built as modules again.

Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
[nicolas.ferre@atmel.com: modify slightly commit message]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 97cc04d..0607847 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -54,6 +54,7 @@ void __init at91_init_interrupts(unsigned int *priority)
 }
 
 void __iomem *at91_ramc_base[2];
+EXPORT_SYMBOL_GPL(at91_ramc_base);
 
 void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
 {
-- 
1.7.10


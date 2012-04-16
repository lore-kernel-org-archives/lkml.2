Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2DPJYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:24:37 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:39722 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2DPJVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 01/12] ARM: at91: Export at91_st_base
Date: Mon, 16 Apr 2012 11:20:45 +0200
Message-Id: <9fce85c7e4357a93457c8fd2534a1cc1c3055bf5.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

After commit 5e9cf5e (ARM: at91: make ST (System Timer) soc independent)
building at91rm9200_wdt as a module fails with following message
  ERROR: "at91_st_base" [drivers/watchdog/at91rm9200_wdt.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

Export symbol to allow wdt driver to be built as a module again.

Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
[nicolas.ferre@atmel.com: use EXPORT_SYMBOL_GPL()]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200_time.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index dd7f782..104ca40 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/clockchips.h>
+#include <linux/export.h>
 
 #include <asm/mach/time.h>
 
@@ -176,6 +177,7 @@ static struct clock_event_device clkevt = {
 };
 
 void __iomem *at91_st_base;
+EXPORT_SYMBOL_GPL(at91_st_base);
 
 void __init at91rm9200_ioremap_st(u32 addr)
 {
-- 
1.7.10


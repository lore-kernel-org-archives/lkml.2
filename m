Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2DPJVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:21:21 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:36428 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2DPJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:19 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 03/12] ARM: at91: Export at91_pmc_base
Date: Mon, 16 Apr 2012 11:20:47 +0200
Message-Id: <f19b797c08017c9b03d81986b2efc4c5cf4bc453.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

After commit b55149529d26 (ARM: at91/PMC: make register base soc independent)
building atmel_usba_udc as a module fails with following message
  ERROR: "at91_pmc_base" [drivers/usb/gadget/atmel_usba_udc.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

Export symbol to allow driver to be built as a module again.

Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index a0f4d74..6b69282 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -35,6 +35,7 @@
 #include "generic.h"
 
 void __iomem *at91_pmc_base;
+EXPORT_SYMBOL_GPL(at91_pmc_base);
 
 /*
  * There's a lot more which can be done with clocks, including cpufreq
-- 
1.7.10


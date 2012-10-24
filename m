Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124Ab2JXOrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:47:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41271 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934820Ab2JXOpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:45:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/6] ARM: ux500: Fix build error relating to IRQCHIP_SKIP_SET_WAKE
Date: Wed, 24 Oct 2012 15:45:23 +0100
Message-Id: <1351089926-32161-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the build error below:

arch/arm/mach-ux500/cpu.c: In function ‘ux500_init_irq’:
arch/arm/mach-ux500/cpu.c:55:2: error: invalid use of undefined type ‘struct irq_chip’
arch/arm/mach-ux500/cpu.c:55:24: error: ‘IRQCHIP_SKIP_SET_WAKE’ undeclared (first use in this function)
arch/arm/mach-ux500/cpu.c:55:24: note: each undeclared identifier is reported only once for each function it appears in
arch/arm/mach-ux500/cpu.c:55:48: error: ‘IRQCHIP_MASK_ON_SUSPEND’ undeclared (first use in this function)

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index fb25f4e..721e7b4 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -16,6 +16,7 @@
 #include <linux/stat.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
+#include <linux/irq.h>
 #include <linux/platform_data/clk-ux500.h>
 
 #include <asm/hardware/gic.h>
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab1FBJgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:36:07 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:46305 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933137Ab1FBJgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:36:04 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCHv2 3/3] mach-ux500: Initialize the DB8500 PRCMU timer
Date: Thu, 2 Jun 2011 11:35:49 +0200
Message-ID: <1307007349-1159-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource and sched_clk registration needs to be started
early so it is called from the platform sys_timer init.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/cpu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 1da23bb..7109921 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -10,6 +10,7 @@
 #include <linux/clk.h>
 #include <linux/mfd/db8500-prcmu.h>
 #include <linux/mfd/db5500-prcmu.h>
+#include <linux/clksrc-db8500-prcmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -141,6 +142,7 @@ static void __init ux500_timer_init(void)
 		ux500_unknown_soc();
 
 	nmdk_timer_init();
+	clksrc_db8500_prcmu_init();
 }
 
 struct sys_timer ux500_timer = {
-- 
1.7.4.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1FYWKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:10:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65268 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1FYWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UxhvZ68OkCN8nz6ga5wSYt8g30jf6cJvAB6orGdmE4cVLRdPml8U8BFaGiqwfisQMK
         HcaYvdGwiwWlHHRvdFWJ3e/U+b09kPoIy5pplPRBDrOiNVNAn5jucXgVthYZkwOFAbWs
         BQT0qTUvyM2Y19H9LQ90SheGkLGzpRDCd1xP4=
From: Bryan Wu <bryan.wu@canonical.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ARM: use new LEDS CPU trigger stub to replace old one
Date: Sun, 26 Jun 2011 06:10:02 +0800
Message-Id: <1309039804-659-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc:  Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/kernel/process.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 5e1e541..d3b70cc 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -30,9 +30,9 @@
 #include <linux/uaccess.h>
 #include <linux/random.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/leds.h>
 
 #include <asm/cacheflush.h>
-#include <asm/leds.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/thread_notify.h>
@@ -183,7 +183,7 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick(1);
-		leds_event(led_idle_start);
+		ledtrig_cpu(CPU_LED_IDLE_START);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
 			if (cpu_is_offline(smp_processor_id()))
@@ -207,7 +207,7 @@ void cpu_idle(void)
 				local_irq_enable();
 			}
 		}
-		leds_event(led_idle_end);
+		ledtrig_cpu(CPU_LED_IDLE_END);
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab1J3Mwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:52:47 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:37518 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab1J3Mss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 22/27] m68k/sun3: Use the kstat_irqs_cpu() wrapper
Date: Sun, 30 Oct 2011 13:48:30 +0100
Message-Id: <1319978915-10933-23-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Sam Creasey <sammy@sammy.net>
---
 arch/m68k/sun3/sun3ints.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 20ffee7..1273eb8 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -51,14 +51,19 @@ void sun3_disable_irq(unsigned int irq)
 
 static irqreturn_t sun3_int7(int irq, void *dev_id)
 {
+	unsigned int cnt;
+
 	*sun3_intreg |=  (1 << irq);
-	if (!(kstat_cpu(0).irqs[irq] % 2000))
-		sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 16000) / 2000]);
+	cnt = kstat_irqs_cpu(irq, 0);
+	if (!(cnt % 2000))
+		sun3_leds(led_pattern[cnt % 16000 / 2000]);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t sun3_int5(int irq, void *dev_id)
 {
+	unsigned int cnt;
+
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
@@ -68,8 +73,9 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #endif
 	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
-        if (!(kstat_cpu(0).irqs[irq] % 20))
-                sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 160) / 20]);
+	cnt = kstat_irqs_cpu(irq, 0);
+	if (!(cnt % 20))
+		sun3_leds(led_pattern[cnt % 160 / 20]);
 	return IRQ_HANDLED;
 }
 
-- 
1.7.0.4


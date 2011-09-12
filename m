Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1ILS2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:28:46 -0400
Received: from anhedonia.sammy.net ([174.143.180.86]:42341 "EHLO sammy.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1ILS2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:28:43 -0400
X-Greylist: delayed 2993 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Sep 2011 14:28:43 EDT
Date: Mon, 12 Sep 2011 13:38:44 -0400
From: Sam Creasey <sammy@sammy.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Creasey <sammy@sammy.net>
Subject: Re: [PATCH 24/28] m68k/sun3: Use the kstat_irqs_cpu() wrapper
Message-ID: <20110912173843.GK32271@anhedonia>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org> <1315742394-16036-25-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315742394-16036-25-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Creasey <sammy@sammy.net>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
v4: Added this changeset
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


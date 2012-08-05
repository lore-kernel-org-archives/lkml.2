Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2HEXI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:08:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53436 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2HEXIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:08:55 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 9/9] ARM: FIQ: Make show_fiq_list() return void
Date: Sun,  5 Aug 2012 16:03:39 -0700
Message-Id: <1344207819-3415-9-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120805230238.GA1663@lizard>
References: <20120805230238.GA1663@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is never checked, so we can turn show_fiq_list() into
returning void.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/include/asm/mach/irq.h |    4 ++--
 arch/arm/kernel/fiq.c           |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/mach/irq.h b/arch/arm/include/asm/mach/irq.h
index 420d211..8be5ba9 100644
--- a/arch/arm/include/asm/mach/irq.h
+++ b/arch/arm/include/asm/mach/irq.h
@@ -19,10 +19,10 @@ struct seq_file;
  */
 #ifdef CONFIG_FIQ
 extern void init_FIQ(void);
-extern int show_fiq_list(struct seq_file *, int);
+extern void show_fiq_list(struct seq_file *, int);
 #else
 static inline void init_FIQ(void) {}
-static inline int show_fiq_list(struct seq_file *p, int prec) { return 0; }
+static inline void show_fiq_list(struct seq_file *p, int prec) {}
 #endif
 
 #ifdef CONFIG_MULTI_IRQ_HANDLER
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 7be2e74..9bf3a60 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -69,13 +69,11 @@ static struct fiq_handler default_owner = {
 
 static struct fiq_handler *current_fiq = &default_owner;
 
-int show_fiq_list(struct seq_file *p, int prec)
+void show_fiq_list(struct seq_file *p, int prec)
 {
 	if (current_fiq != &default_owner)
 		seq_printf(p, "%*s:              %s\n", prec, "FIQ",
 			current_fiq->name);
-
-	return 0;
 }
 
 void set_fiq_handler(void *start, unsigned int length)
-- 
1.7.10.4


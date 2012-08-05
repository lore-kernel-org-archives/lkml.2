Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2HEXIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:08:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53436 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2HEXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:08:03 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 5/9] ARM: FIQ: Remove enable_fiq() and disable_fiq() calls
Date: Sun,  5 Aug 2012 16:03:35 -0700
Message-Id: <1344207819-3415-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120805230238.GA1663@lizard>
References: <20120805230238.GA1663@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no users left, so these can be removed.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/include/asm/fiq.h |    2 --
 arch/arm/kernel/fiq.c      |   15 ---------------
 2 files changed, 17 deletions(-)

diff --git a/arch/arm/include/asm/fiq.h b/arch/arm/include/asm/fiq.h
index d493d0b..a293be4 100644
--- a/arch/arm/include/asm/fiq.h
+++ b/arch/arm/include/asm/fiq.h
@@ -36,8 +36,6 @@ struct fiq_handler {
 extern int claim_fiq(struct fiq_handler *f);
 extern void release_fiq(struct fiq_handler *f);
 extern void set_fiq_handler(void *start, unsigned int length);
-extern void enable_fiq(int fiq);
-extern void disable_fiq(int fiq);
 
 /* helpers defined in fiqasm.S: */
 extern void __set_fiq_regs(unsigned long const *regs);
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 2adda11..29b93b8 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -122,28 +122,13 @@ void release_fiq(struct fiq_handler *f)
 	while (current_fiq->fiq_op(current_fiq->dev_id, 0));
 }
 
-static int fiq_start;
-
-void enable_fiq(int fiq)
-{
-	enable_irq(fiq + fiq_start);
-}
-
-void disable_fiq(int fiq)
-{
-	disable_irq(fiq + fiq_start);
-}
-
 EXPORT_SYMBOL(set_fiq_handler);
 EXPORT_SYMBOL(__set_fiq_regs);	/* defined in fiqasm.S */
 EXPORT_SYMBOL(__get_fiq_regs);	/* defined in fiqasm.S */
 EXPORT_SYMBOL(claim_fiq);
 EXPORT_SYMBOL(release_fiq);
-EXPORT_SYMBOL(enable_fiq);
-EXPORT_SYMBOL(disable_fiq);
 
 void __init init_FIQ(int start)
 {
 	no_fiq_insn = *(unsigned long *)0xffff001c;
-	fiq_start = start;
 }
-- 
1.7.10.4


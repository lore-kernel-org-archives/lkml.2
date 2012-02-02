Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab2BBRhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:37:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57652 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab2BBRbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:16 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 23/25] gpio/omap: enable irq at the end of all configuration in restore
Date: Thu, 2 Feb 2012 23:00:49 +0530
Message-ID: <1328203851-20435-24-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Setup the interrupt enable registers only after we have configured the
required edge and required configurations, not before, to prevent
spurious events as part of restore routine.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 560567d..36aaea7 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1348,10 +1348,6 @@ void omap2_gpio_resume_after_idle(void)
 
 static void omap_gpio_restore_context(struct gpio_bank *bank)
 {
-	__raw_writel(bank->context.irqenable1,
-				bank->base + bank->regs->irqenable);
-	__raw_writel(bank->context.irqenable2,
-				bank->base + bank->regs->irqenable2);
 	__raw_writel(bank->context.wake_en,
 				bank->base + bank->regs->wkup_en);
 	__raw_writel(bank->context.ctrl, bank->base + bank->regs->ctrl);
@@ -1371,6 +1367,11 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
 		__raw_writel(bank->context.debounce_en,
 					bank->base + bank->regs->debounce_en);
 	}
+
+	__raw_writel(bank->context.irqenable1,
+				bank->base + bank->regs->irqenable);
+	__raw_writel(bank->context.irqenable2,
+				bank->base + bank->regs->irqenable2);
 }
 #else
 #define omap_gpio_suspend NULL
-- 
1.7.0.4


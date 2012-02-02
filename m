Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2BBRbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47538 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab2BBRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:13 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 24/25] gpio/omap: restore OE only after setting the output level
Date: Thu, 2 Feb 2012 23:00:50 +0530
Message-ID: <1328203851-20435-25-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Setup the dataout register before restoring OE. This is to make
sure that we have valid data in dataout register which would be
made available in output pins as soon as OE is enabled. Else,
there is risk of unknown data getting out into gpio pins.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 36aaea7..81fdbcf 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1351,7 +1351,6 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
 	__raw_writel(bank->context.wake_en,
 				bank->base + bank->regs->wkup_en);
 	__raw_writel(bank->context.ctrl, bank->base + bank->regs->ctrl);
-	__raw_writel(bank->context.oe, bank->base + bank->regs->direction);
 	__raw_writel(bank->context.leveldetect0,
 				bank->base + bank->regs->leveldetect0);
 	__raw_writel(bank->context.leveldetect1,
@@ -1361,6 +1360,8 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
 	__raw_writel(bank->context.fallingdetect,
 				bank->base + bank->regs->fallingdetect);
 	__raw_writel(bank->context.dataout, bank->base + bank->regs->dataout);
+	__raw_writel(bank->context.oe, bank->base + bank->regs->direction);
+
 	if (bank->dbck_enable_mask) {
 		__raw_writel(bank->context.debounce, bank->base +
 					bank->regs->debounce);
-- 
1.7.0.4


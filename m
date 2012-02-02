Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2BBRh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:37:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47542 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab2BBRbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:15 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 25/25] gpio/omap: handle set_dataout reg capable IP on restore
Date: Thu, 2 Feb 2012 23:00:51 +0530
Message-ID: <1328203851-20435-26-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

GPIO IP revisions such as those used in OMAP4 have a set_dataout
while the previous revisions used a single dataout register.
Depending on what is available restore the dataout settings
to the right register.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 81fdbcf..4273401 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1359,7 +1359,12 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
 				bank->base + bank->regs->risingdetect);
 	__raw_writel(bank->context.fallingdetect,
 				bank->base + bank->regs->fallingdetect);
-	__raw_writel(bank->context.dataout, bank->base + bank->regs->dataout);
+	if (bank->regs->set_dataout && bank->regs->clr_dataout)
+		__raw_writel(bank->context.dataout,
+				bank->base + bank->regs->set_dataout);
+	else
+		__raw_writel(bank->context.dataout,
+				bank->base + bank->regs->dataout);
 	__raw_writel(bank->context.oe, bank->base + bank->regs->direction);
 
 	if (bank->dbck_enable_mask) {
-- 
1.7.0.4


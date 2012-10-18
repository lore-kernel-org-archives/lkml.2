Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2JRQdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:33:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49585 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab2JRQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:33:46 -0400
From: Sangho Yi <antiroot@gmail.com>
To: paul.gortmaker@windriver.com, stefan.xk.nilsson@stericsson.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com, rjw@sisk.pl,
        girish.shivananjappa@linaro.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 5/6] mmc: core: sdio_bus.c: Fixed a warning for the pr_warning(...
Date: Fri, 19 Oct 2012 01:31:58 +0900
Message-Id: <1350577919-2750-5-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350577919-2750-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350577919-2750-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed a line which had the following warning:
WARNING: Prefer pr_warn(... to pr_warning(...

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 1a1d96c..e5b7197 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -175,7 +175,7 @@ static int sdio_bus_remove(struct device *dev)
 	drv->remove(func);
 
 	if (func->irq_handler) {
-		pr_warning("WARNING: driver %s did not remove "
+		pr_warn("WARNING: driver %s did not remove "
 			"its interrupt handler!\n", drv->name);
 		sdio_claim_host(func);
 		sdio_release_irq(func);
-- 
1.7.9.5


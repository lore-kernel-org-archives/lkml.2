Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2JRQdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:33:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63415 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab2JRQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:33:50 -0400
From: Sangho Yi <antiroot@gmail.com>
To: paul.gortmaker@windriver.com, stefan.xk.nilsson@stericsson.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com, rjw@sisk.pl,
        girish.shivananjappa@linaro.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 6/6] mmc: core: sdio_bus.c: Removed unnecessary NULL check routine
Date: Fri, 19 Oct 2012 01:31:59 +0900
Message-Id: <1350577919-2750-6-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350577919-2750-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350577919-2750-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree(something) is safe function, so I removed the NULL check routine
for the input of kfree.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio_bus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index e5b7197..cf02146 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -259,8 +259,7 @@ static void sdio_release_func(struct device *dev)
 
 	sdio_free_func_cis(func);
 
-	if (func->info)
-		kfree(func->info);
+	kfree(func->info);
 
 	kfree(func);
 }
-- 
1.7.9.5


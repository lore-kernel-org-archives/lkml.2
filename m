Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2JSN7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:59:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38868 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2JSN7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:59:18 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@nvidia.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        paul.gortmaker@windriver.com, chuanxiao.dong@intel.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/2] mmc: core: bus.c: removed unnecessary NULL check for kfree(...)
Date: Fri, 19 Oct 2012 22:58:57 +0900
Message-Id: <1350655138-2252-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree(NULL) is safe so I removed the if statements for NULL check.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/bus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 9b68933..420cb67 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -225,8 +225,7 @@ static void mmc_release_card(struct device *dev)
 
 	sdio_free_common_cis(card);
 
-	if (card->info)
-		kfree(card->info);
+	kfree(card->info);
 
 	kfree(card);
 }
-- 
1.7.9.5


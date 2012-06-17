Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2FQPQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 11:16:08 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58105 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab2FQPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 11:15:18 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl: pinctrl-mxs: fix implicit declaration of free()
Date: Sun, 17 Jun 2012 12:17:32 -0300
Message-Id: <1339946252-21019-2-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339946252-21019-1-git-send-email-otavio@ossystems.com.br>
References: <1339946252-21019-1-git-send-email-otavio@ossystems.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

,--[ build failure ]
| ...
| .../pinctrl-mxs.c: In function 'mxs_dt_node_to_map':
| .../pinctrl-mxs.c:140:3: error: implicit declaration of function 'free'
|                   [-Werror=implicit-function-declaration]
| .../pinctrl-mxs.c:140:3: warning: incompatible implicit declaration of
|                   built-in function 'free' [enabled by default]
| ...
`--

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-mxs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index afb50ee..85f8dda 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -136,8 +136,7 @@ static int mxs_dt_node_to_map(struct pinctrl_dev *pctldev,
 	return 0;
 
 free_group:
-	if (!purecfg)
-		free(group);
+	kfree(group);
 free:
 	kfree(new_map);
 	return ret;
-- 
1.7.10


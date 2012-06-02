Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2FBREo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 13:04:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab2FBREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 13:04:43 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] pinctrl: free if of_get_parent fails to get the parent node
Date: Sat,  2 Jun 2012 22:34:37 +0530
Message-Id: <1338656677-3979-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_parent can return null if no parent node found, so the allocated new_map
should be freed.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/pinctrl-imx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 553ed95..82c1d80 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -173,8 +173,10 @@ static int imx_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 	/* create mux map */
 	parent = of_get_parent(np);
-	if (!parent)
+	if (!parent) {
+		kfree(new_map);
 		return -EINVAL;
+	}
 	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
 	new_map[0].data.mux.function = parent->name;
 	new_map[0].data.mux.group = np->name;
-- 
1.7.9.5


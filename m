Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270Ab2FGQtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:49:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50312 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2FGQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:49:34 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng <aisheng.dong@freescale.com>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH V2 2/2] pinctrl: pinctrl-imx: free if of_get_parent fails to get the parent node
Date: Thu,  7 Jun 2012 22:19:26 +0530
Message-Id: <1339087766-14739-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_parent can return null if no parent node found, so the allocated new_map
should be freed.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/pinctrl-imx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 7a59a59..59a5fa3 100644
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


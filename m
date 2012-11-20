Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2KTLKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:10:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52291 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2KTLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:10:50 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] pinctrl: pinctrl-single: Fix error check condition
Date: Tue, 20 Nov 2012 16:34:39 +0530
Message-Id: <1353409479-3304-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*map should be tested for NULL instead of map.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-single.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 726a729..3fc2a22 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -772,7 +772,7 @@ static int pcs_dt_node_to_map(struct pinctrl_dev *pctldev,
 	pcs = pinctrl_dev_get_drvdata(pctldev);
 
 	*map = devm_kzalloc(pcs->dev, sizeof(**map), GFP_KERNEL);
-	if (!map)
+	if (!*map)
 		return -ENOMEM;
 
 	*num_maps = 0;
-- 
1.7.4.1


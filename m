Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2JZOyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:54:37 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37235 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2JZOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:54:35 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 22:54:34 +0800
Message-ID: <CAPgLHd8wKSubYtsnSm28-5R7aJ6uKcO1K31LCJCWTnU2A8+iPA@mail.gmail.com>
Subject: [PATCH -next] ARM: at91: remove unused variable in at91_dt_node_to_map()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable pin is initialized but never used
otherwise, so remove the unused variable.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-at91.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 01bf924..19b57bb 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -221,7 +221,6 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
 	struct device_node *parent;
 	int map_num = 1;
 	int i;
-	struct at91_pmx_pin *pin;
 
 	/*
 	 * first find the group of this node and check if we need create
@@ -256,8 +255,6 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
 	/* create config map */
 	new_map++;
 	for (i = 0; i < grp->npins; i++) {
-		pin = &grp->pins_conf[i];
-
 		new_map[i].type = PIN_MAP_TYPE_CONFIGS_PIN;
 		new_map[i].data.configs.group_or_pin =
 				pin_get_name(pctldev, grp->pins[i]);


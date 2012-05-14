Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2ENLBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:01:31 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:22901 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755562Ab2ENLB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:01:29 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <haojian.zhuang@marvell.com>,
        <shawn.guo@freescale.com>
Subject: [PATCH 1/5] pinctrl: a minor error checking improvement for pinconf
Date: Mon, 14 May 2012 19:06:36 +0800
Message-ID: <1336993600-30065-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Also checking invalid num_configs when validate the pinconf map.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/pinconf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 7ce139e..43f474c 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -50,9 +50,9 @@ int pinconf_validate_map(struct pinctrl_map const *map, int i)
 		return -EINVAL;
 	}
 
-	if (map->data.configs.num_configs &&
+	if (!map->data.configs.num_configs ||
 			!map->data.configs.configs) {
-		pr_err("failed to register map %s (%d): no configs ptr given\n",
+		pr_err("failed to register map %s (%d): no configs given\n",
 		       map->name, i);
 		return -EINVAL;
 	}
-- 
1.7.0.4



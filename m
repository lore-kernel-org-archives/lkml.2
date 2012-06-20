Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2FTEwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:52:22 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:29986
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab2FTEwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:52:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>
Subject: [PATCH 1/1] pinctrl: pinctrl-mxs: fix a compiling error
Date: Wed, 20 Jun 2012 12:48:37 +0800
Message-ID: <1340167717-13082-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The compiling error is:
drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_dt_node_to_map':
drivers/pinctrl/pinctrl-mxs.c:140: error: implicit declaration of function 'free'
drivers/pinctrl/pinctrl-mxs.c:140: warning: incompatible implicit declaration of built-in function 'free'
It should be kfree.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/pinctrl-mxs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index afb50ee..4ba4636 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -137,7 +137,7 @@ static int mxs_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 free_group:
 	if (!purecfg)
-		free(group);
+		kfree(group);
 free:
 	kfree(new_map);
 	return ret;
-- 
1.7.0.4



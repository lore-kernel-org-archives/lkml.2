Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2FMRGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:06:19 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:49900
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab2FMRGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:06:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz1102Izz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <linus.walleij@linaro.org>, <shawn.guo@freescale.com>,
        <devendra.aaru@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] pinctrl: mxs: Use kfree to fix build error
Date: Wed, 13 Jun 2012 14:06:07 -0300
Message-ID: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0bf7481 (pinctrl: pinctrl-mxs: Take care of frees if the kzalloc fails)
introduced the following build error:

drivers/pinctrl/pinctrl-mxs.c:140:3: error: implicit declaration of function 'free' 

Use kfree function instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
This applies against linux-next
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
1.7.1



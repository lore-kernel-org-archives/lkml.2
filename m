Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2ENLB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:01:29 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42561 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200Ab2ENLB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:01:27 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <haojian.zhuang@marvell.com>,
        <shawn.guo@freescale.com>
Subject: [PATCH 2/5] pinctrl: make pinmux disable function optional
Date: Mon, 14 May 2012 19:06:37 +0800
Message-ID: <1336993600-30065-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336993600-30065-1-git-send-email-b29396@freescale.com>
References: <1336993600-30065-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Some SoCs may not have pinmux disable function in HW.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/pinmux.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 220fa49..3d5ac73 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -41,8 +41,7 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev)
 	    !ops->get_functions_count ||
 	    !ops->get_function_name ||
 	    !ops->get_function_groups ||
-	    !ops->enable ||
-	    !ops->disable) {
+	    !ops->enable) {
 		dev_err(pctldev->dev, "pinmux ops lacks necessary functions\n");
 		return -EINVAL;
 	}
@@ -497,7 +496,8 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 		desc->mux_setting = NULL;
 	}
 
-	ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
+	if (ops->disable)
+		ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
 }
 
 #ifdef CONFIG_DEBUG_FS
-- 
1.7.0.4



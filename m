Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2DEI43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:56:29 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:54272 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248Ab2DEI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:56:28 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH 1/1] pinctrl: fix compile error if not select PINMUX support
Date: Thu, 5 Apr 2012 17:07:23 +0800
Message-ID: <1333616843-3607-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The pinctrl_register_mappings is defined in core.c, so change the dependent
macro from CONFIG_MUX to CONFIG_PINCTRL.

The compile error message is:
drivers/pinctrl/core.c:886: error: redefinition of 'pinctrl_register_mappings'
include/linux/pinctrl/machine.h:160: note: previous definition of 'pinctrl_register_mappings' was here
make[2]: *** [drivers/pinctrl/core.o] Error 1
make[1]: *** [drivers/pinctrl] Error 2
make: *** [drivers] Error 2

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 include/linux/pinctrl/machine.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 226444e..e4d1de7 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -150,7 +150,7 @@ struct pinctrl_map {
 #define PIN_MAP_CONFIGS_GROUP_HOG_DEFAULT(dev, grp, cfgs)		\
 	PIN_MAP_CONFIGS_GROUP(dev, PINCTRL_STATE_DEFAULT, dev, grp, cfgs)
 
-#ifdef CONFIG_PINMUX
+#ifdef CONFIG_PINCTRL
 
 extern int pinctrl_register_mappings(struct pinctrl_map const *map,
 				unsigned num_maps);
-- 
1.7.0.4



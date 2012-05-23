Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2EWNUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:20:04 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:38447
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175Ab2EWNUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:20:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH RFC v3 2/3] pinctrl: add pinctrl_add_gpio_ranges function
Date: Wed, 23 May 2012 21:22:41 +0800
Message-ID: <1337779362-31259-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337779362-31259-1-git-send-email-b29396@freescale.com>
References: <1337779362-31259-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog v2->v3:
* remove pinctrl_remove_gpio_ranges function.
---
 drivers/pinctrl/core.c          |   11 +++++++++++
 include/linux/pinctrl/pinctrl.h |    3 +++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index e16529e..f6c51c4 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -332,6 +332,17 @@ void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 }
 EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
+void pinctrl_add_gpio_ranges(struct pinctrl_dev *pctldev,
+			     struct pinctrl_gpio_range *ranges,
+			     unsigned nranges)
+{
+	int i;
+
+	for (i = 0; i < nranges; i++)
+		pinctrl_add_gpio_range(pctldev, &ranges[i]);
+}
+EXPORT_SYMBOL_GPL(pinctrl_add_gpio_ranges);
+
 /**
  * pinctrl_get_group_selector() - returns the group selector for a group
  * @pctldev: the pin controller handling the group
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 170a588..69393a6 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -131,6 +131,9 @@ extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
 extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
 extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
+extern void pinctrl_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *ranges,
+				unsigned nranges);
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
 #else
-- 
1.7.0.4



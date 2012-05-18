Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945984Ab2ERNIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:08:16 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:46771
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945955Ab2ERNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:08:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH RFC v2 1/2] pinctrl: add pinctrl_add_gpio_ranges function
Date: Fri, 18 May 2012 21:12:34 +0800
Message-ID: <1337346755-8761-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/core.c          |   22 ++++++++++++++++++++++
 include/linux/pinctrl/pinctrl.h |    6 ++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c3b331b..916ed49 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -346,6 +346,28 @@ void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 }
 EXPORT_SYMBOL_GPL(pinctrl_remove_gpio_range);
 
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
+void pinctrl_remove_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *ranges,
+				unsigned nranges)
+{
+	int i;
+
+	for (i = 0; i < nranges; i++)
+		pinctrl_remove_gpio_range(pctldev, &ranges[i]);
+}
+EXPORT_SYMBOL_GPL(pinctrl_remove_gpio_ranges);
+
 /**
  * pinctrl_get_group_selector() - returns the group selector for a group
  * @pctldev: the pin controller handling the group
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 3b894a6..6a29965 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -133,6 +133,12 @@ extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
 extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
+extern void pinctrl_add_gpio_ranges(struct pinctrl_dev *pctldev,
+			     struct pinctrl_gpio_range *ranges,
+			     unsigned nranges);
+extern void pinctrl_remove_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *ranges,
+				unsigned nranges);
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
 #else
-- 
1.7.0.4



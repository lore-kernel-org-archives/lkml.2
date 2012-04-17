Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2DQGuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:50:12 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:44021
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937Ab2DQGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:50:11 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH v2 1/2] pinctrl: show pin name when request pins
Date: Tue, 17 Apr 2012 15:00:45 +0800
Message-ID: <1334646046-467-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Pin name is more useful to users.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

---
No changes since v1.

After change, when call pinctrl_get_*, the debug information becomes :
pinctrl-imx 20e0000.iomuxc: request pin 305 (MX6Q_PAD_SD4_CMD) for 219c000.usdhc
pinctrl-imx 20e0000.iomuxc: request pin 306 (MX6Q_PAD_SD4_CLK) for 219c000.usdhc
---
 drivers/pinctrl/pinmux.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index c494c37..fa0357b 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -88,8 +88,6 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 	int status = -EINVAL;
 
-	dev_dbg(pctldev->dev, "request pin %d for %s\n", pin, owner);
-
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
 		dev_err(pctldev->dev,
@@ -97,6 +95,9 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
+	dev_dbg(pctldev->dev, "request pin %d (%s) for %s\n",
+		pin, desc->name, owner);
+
 	if (gpio_range) {
 		/* There's no need to support multiple GPIO requests */
 		if (desc->gpio_owner) {
-- 
1.7.0.4



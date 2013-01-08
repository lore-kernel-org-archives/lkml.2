Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3AHAyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:54:17 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:33827 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3AHAyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:54:16 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] pinctrl: pinctrl-mxs: Fix variables' definition type
Date: Mon,  7 Jan 2013 22:53:49 -0200
Message-Id: <1357606429-23388-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following warnings when building with W=1 option:

drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_dt_free_map':
drivers/pinctrl/pinctrl-mxs.c:151:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_pinctrl_enable':
drivers/pinctrl/pinctrl-mxs.c:208:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_pinconf_group_set':
drivers/pinctrl/pinctrl-mxs.c:265:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_pinctrl_parse_group':
drivers/pinctrl/pinctrl-mxs.c:376:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/pinctrl/pinctrl-mxs.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index dd227d2..23af9f1 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -146,7 +146,7 @@ free:
 static void mxs_dt_free_map(struct pinctrl_dev *pctldev,
 			    struct pinctrl_map *map, unsigned num_maps)
 {
-	int i;
+	u32 i;
 
 	for (i = 0; i < num_maps; i++) {
 		if (map[i].type == PIN_MAP_TYPE_MUX_GROUP)
@@ -203,7 +203,7 @@ static int mxs_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	void __iomem *reg;
 	u8 bank, shift;
 	u16 pin;
-	int i;
+	u32 i;
 
 	for (i = 0; i < g->npins; i++) {
 		bank = PINID_TO_BANK(g->pins[i]);
@@ -256,7 +256,7 @@ static int mxs_pinconf_group_set(struct pinctrl_dev *pctldev,
 	void __iomem *reg;
 	u8 ma, vol, pull, bank, shift;
 	u16 pin;
-	int i;
+	u32 i;
 
 	ma = CONFIG_TO_MA(config);
 	vol = CONFIG_TO_VOL(config);
@@ -345,8 +345,7 @@ static int mxs_pinctrl_parse_group(struct platform_device *pdev,
 	const char *propname = "fsl,pinmux-ids";
 	char *group;
 	int length = strlen(np->name) + SUFFIX_LEN;
-	int i;
-	u32 val;
+	u32 val, i;
 
 	group = devm_kzalloc(&pdev->dev, length, GFP_KERNEL);
 	if (!group)
-- 
1.7.9.5


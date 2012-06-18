Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2FRRqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:46:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2FRRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:46:12 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] pinctrl/pinctrl-spear: remove IS_ERR checking of pmx->pctl
Date: Mon, 18 Jun 2012 23:16:04 +0530
Message-Id: <1340041564-30168-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl_register returns a pointer of struct type struct pinctrl_dev,
if successfully registered to pinctrl subsystem, otherwise returns
NULL, and there wont' be any pointers which are not dereferencible.

They are not type of pointer addresses but are kind of error
codes rather actual addresses, but are a kind of return
codes of functions returning integer types.

return -ENODEV if device registration fails.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/spear/pinctrl-spear.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
index 5ae50aa..b9a52c9 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.c
+++ b/drivers/pinctrl/spear/pinctrl-spear.c
@@ -336,9 +336,9 @@ int __devinit spear_pinctrl_probe(struct platform_device *pdev,
 	spear_pinctrl_desc.npins = machdata->npins;
 
 	pmx->pctl = pinctrl_register(&spear_pinctrl_desc, &pdev->dev, pmx);
-	if (IS_ERR(pmx->pctl)) {
+	if (!pmx->pctl) {
 		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
-		return PTR_ERR(pmx->pctl);
+		return -ENODEV;
 	}
 
 	return 0;
-- 
1.7.9.5


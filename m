Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2E2DOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 23:14:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61726 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2E2DOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 23:14:47 -0400
From: Fabio Estevam <festevam@gmail.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: pinctrl: Remove redefinition of 'pinctrl_provide_dummies'
Date: Tue, 29 May 2012 00:14:38 -0300
Message-Id: <1338261278-17962-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

For mxs_defconfig and imx_v6_v7_defconfig targets, the following
build error is observed:

drivers/pinctrl/core.c:87:6: error: redefinition of 'pinctrl_provide_dummies'

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
This applies against linux-next-20120528

 drivers/pinctrl/core.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4446a33..4e89097 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -76,19 +76,6 @@ void pinctrl_provide_dummies(void)
 	pinctrl_dummy_state = true;
 }
 
-/**
- * pinctrl_provide_dummies() - indicate if pinctrl provides dummy state support
- *
- * Usually this function is called by platforms without pinctrl driver support
- * but run with some shared drivers using pinctrl APIs.
- * After calling this function, the pinctrl core will return successfully
- * with creating a dummy state for the driver to keep going smoothly.
- */
-void pinctrl_provide_dummies(void)
-{
-	pinctrl_dummy_state = true;
-}
-
 const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev)
 {
 	/* We're not allowed to register devices without name */
-- 
1.7.1


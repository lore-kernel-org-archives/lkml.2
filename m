Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2IENfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:35:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54778 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2IENfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:35:38 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/8] pwm i.MX: Use module_platform_driver
Date: Wed,  5 Sep 2012 15:35:23 +0200
Message-Id: <1346852127-25226-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346852127-25226-1-git-send-email-s.hauer@pengutronix.de>
References: <1346852127-25226-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/pwm-imx.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 3fc4ae8..a689144 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -270,17 +270,7 @@ static struct platform_driver imx_pwm_driver = {
 	.remove		= __devexit_p(imx_pwm_remove),
 };
 
-static int __init imx_pwm_init(void)
-{
-	return platform_driver_register(&imx_pwm_driver);
-}
-arch_initcall(imx_pwm_init);
-
-static void __exit imx_pwm_exit(void)
-{
-	platform_driver_unregister(&imx_pwm_driver);
-}
-module_exit(imx_pwm_exit);
+module_platform_driver(imx_pwm_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
-- 
1.7.10.4


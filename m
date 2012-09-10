Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2IJJAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:00:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53829 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2IJJAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:00:04 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/7] pwm: i.MX: Use module_platform_driver
Date: Mon, 10 Sep 2012 10:59:34 +0200
Message-Id: <1347267577-3296-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
References: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/pwm/pwm-imx.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 13d4d22..a1e799e 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -271,17 +271,7 @@ static struct platform_driver imx_pwm_driver = {
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


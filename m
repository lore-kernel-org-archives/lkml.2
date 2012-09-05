Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab2IEWCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:02:40 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:49151 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759698Ab2IEWBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:01:40 -0400
From: Fabio Estevam <festevam@gmail.com>
To: zbr@ioremap.net
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 3/3] w1: mxc_w1: Convert to platform driver
Date: Wed,  5 Sep 2012 19:01:20 -0300
Message-Id: <1346882480-18254-3-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346882480-18254-1-git-send-email-festevam@gmail.com>
References: <1346882480-18254-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Using module_platform_driver() makes the code smaller and cleaner.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/w1/masters/mxc_w1.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 25b234c..a06514b 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -191,21 +191,9 @@ static struct platform_driver mxc_w1_driver = {
 		   .name = "mxc_w1",
 	},
 	.probe = mxc_w1_probe,
-	.remove = mxc_w1_remove,
+	.remove = __devexit_p(mxc_w1_remove),
 };
-
-static int __init mxc_w1_init(void)
-{
-	return platform_driver_register(&mxc_w1_driver);
-}
-
-static void mxc_w1_exit(void)
-{
-	platform_driver_unregister(&mxc_w1_driver);
-}
-
-module_init(mxc_w1_init);
-module_exit(mxc_w1_exit);
+module_platform_driver(mxc_w1_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Freescale Semiconductors Inc");
-- 
1.7.9.5


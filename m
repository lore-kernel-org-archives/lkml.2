Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2AKDAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 22:00:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62635 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2AKDAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 22:00:05 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: zbr@ioremap.net, kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: w1: mxc_w1: Convert mxc_w1 to use module_platform_driver()
Date: Wed, 11 Jan 2012 00:59:57 -0200
Message-Id: <1326250797-17716-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using module_platform_driver makes the code smaller and simpler.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/w1/masters/mxc_w1.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index a3b6a74..b3830d1 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -194,18 +194,7 @@ static struct platform_driver mxc_w1_driver = {
 	.remove = mxc_w1_remove,
 };
 
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
1.7.1


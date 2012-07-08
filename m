Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2GHQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 12:23:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2GHQXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 12:23:54 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] geodewdt: do a little cleanup at probe
Date: Sun,  8 Jul 2012 21:53:45 +0530
Message-Id: <1341764625-2728-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at probe with out ret var, simple return misc_register was sufficient.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/watchdog/geodewdt.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index dc563b6..df825b5 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -217,8 +217,6 @@ static struct miscdevice geodewdt_miscdev = {
 
 static int __devinit geodewdt_probe(struct platform_device *dev)
 {
-	int ret;
-
 	wdt_timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 	if (!wdt_timer) {
 		pr_err("No timers were available\n");
@@ -238,9 +236,7 @@ static int __devinit geodewdt_probe(struct platform_device *dev)
 	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_CMP2,
 		timeout * GEODEWDT_HZ);
 
-	ret = misc_register(&geodewdt_miscdev);
-
-	return ret;
+	return misc_register(&geodewdt_miscdev);
 }
 
 static int __devexit geodewdt_remove(struct platform_device *dev)
-- 
1.7.9.5


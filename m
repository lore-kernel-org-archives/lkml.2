Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2GDQcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:32:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59336 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2GDQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:32:28 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog/ie6xx_wdt: section mismatch in ie6xx_wdt_probe()
Date: Wed,  4 Jul 2012 09:32:11 -0700
Message-Id: <1341419531-8031-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.11.rc0.55.gb2478aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ie6xx_wdt_probe() calls ie6xx_wdt_debugfs_exit() as part of
it's error cleanup path, and ie6xx_wdt_debugfs_exit() is
currently annotated __devexit.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/watchdog/ie6xx_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/ie6xx_wdt.c b/drivers/watchdog/ie6xx_wdt.c
index 5f0d776..8f541b9 100644
--- a/drivers/watchdog/ie6xx_wdt.c
+++ b/drivers/watchdog/ie6xx_wdt.c
@@ -232,7 +232,7 @@ static void __devinit ie6xx_wdt_debugfs_init(void)
 		S_IFREG | S_IRUGO, NULL, NULL, &ie6xx_wdt_dbg_operations);
 }
 
-static void __devexit ie6xx_wdt_debugfs_exit(void)
+static void ie6xx_wdt_debugfs_exit(void)
 {
 	debugfs_remove(ie6xx_wdt_data.debugfs);
 }
@@ -242,7 +242,7 @@ static void __devinit ie6xx_wdt_debugfs_init(void)
 {
 }
 
-static void __devexit ie6xx_wdt_debugfs_exit(void)
+static void ie6xx_wdt_debugfs_exit(void)
 {
 }
 #endif
-- 
1.7.11.rc0.55.gb2478aa


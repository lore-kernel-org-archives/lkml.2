Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2AKJUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:20:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38126 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2AKJT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:19:57 -0500
Message-ID: <1326273585.8938.1.camel@phoenix>
Subject: [PATCH] power_supply: Fix modalias for charger-manager
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>
Date: Wed, 11 Jan 2012 17:19:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:".
Current code has the id_table, thus add MODULE_DEVICE_TABLE will
automatically setup the modalias.

Also make charger_manager_id static as it is only used in this driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/charger-manager.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 0378d01..88fd971 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -974,10 +974,11 @@ static int __devexit charger_manager_remove(struct platform_device *pdev)
 	return 0;
 }
 
-const struct platform_device_id charger_manager_id[] = {
+static const struct platform_device_id charger_manager_id[] = {
 	{ "charger-manager", 0 },
 	{ },
 };
+MODULE_DEVICE_TABLE(platform, charger_manager_id);
 
 static int cm_suspend_prepare(struct device *dev)
 {
@@ -1069,4 +1070,3 @@ module_exit(charger_manager_cleanup);
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
 MODULE_DESCRIPTION("Charger Manager");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("charger-manager");
-- 
1.7.5.4




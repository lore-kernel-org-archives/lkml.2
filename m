Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1GaXXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:23:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41182 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1GaXXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:23:12 -0400
Subject: [PATCH] power_supply: fix unterminated platform_device_id table
 for max8997_charger and max8998_charger
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        KyungMin Park <kyungmin.park@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 07:23:00 +0800
Message-ID: <1312154581.2445.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/max8997_charger.c |    1 +
 drivers/power/max8998_charger.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index 7106b49..9848fb8 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -177,6 +177,7 @@ static int __devexit max8997_battery_remove(struct platform_device *pdev)
 
 static const struct platform_device_id max8997_battery_id[] = {
 	{ "max8997-battery", 0 },
+	{ }
 };
 
 static struct platform_driver max8997_battery_driver = {
diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
index cc21fa2..4ddacb4 100644
--- a/drivers/power/max8998_charger.c
+++ b/drivers/power/max8998_charger.c
@@ -188,6 +188,7 @@ static int __devexit max8998_battery_remove(struct platform_device *pdev)
 
 static const struct platform_device_id max8998_battery_id[] = {
 	{ "max8998-battery", TYPE_MAX8998 },
+	{ }
 };
 
 static struct platform_driver max8998_battery_driver = {
-- 
1.7.4.1




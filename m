Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1K1Ohq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:37:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58839 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1K1Ohp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:37:45 -0500
Message-ID: <1322491055.13921.1.camel@phoenix>
Subject: [PATCH] power_supply: wm97xx_battery: Use DEFINE_MUTEX() for
 work_lock
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Date: Mon, 28 Nov 2011 22:37:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

work_lock can be initialized automatically with
DEFINE_MUTEX() rather than explicitly calling mutex_init().

This patch also removes an unused bat_lock mutex.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/wm97xx_battery.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index cf8681c..eaa454b 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -25,9 +25,8 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 
-static DEFINE_MUTEX(bat_lock);
 static struct work_struct bat_work;
-static struct mutex work_lock;
+static DEFINE_MUTEX(work_lock);
 static int bat_status = POWER_SUPPLY_STATUS_UNKNOWN;
 static enum power_supply_property *prop;
 
@@ -181,8 +180,6 @@ static int __devinit wm97xx_bat_probe(struct platform_device *dev)
 	if (dev->id != -1)
 		return -EINVAL;
 
-	mutex_init(&work_lock);
-
 	if (!pdata) {
 		dev_err(&dev->dev, "No platform_data supplied\n");
 		return -EINVAL;
-- 
1.7.5.4




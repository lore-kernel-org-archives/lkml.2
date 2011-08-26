Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1HZDOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 23:14:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63377 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HZDOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 23:14:36 -0400
Subject: [PATCH] power_supply: collie_battery: simplify collie_bat_probe
 error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Kunze <thommycheck@gmx.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 11:14:29 +0800
Message-ID: <1314328469.4571.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this change is better in readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/collie_battery.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/power/collie_battery.c b/drivers/power/collie_battery.c
index 548d263..89d6fcd 100644
--- a/drivers/power/collie_battery.c
+++ b/drivers/power/collie_battery.c
@@ -322,10 +322,8 @@ static int __devinit collie_bat_probe(struct ucb1x00_dev *dev)
 
 	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
 		ret = gpio_request(gpios[i].gpio, gpios[i].name);
-		if (ret) {
-			i--;
+		if (ret)
 			goto err_gpio;
-		}
 
 		if (gpios[i].output)
 			ret = gpio_direction_output(gpios[i].gpio,
@@ -333,8 +331,10 @@ static int __devinit collie_bat_probe(struct ucb1x00_dev *dev)
 		else
 			ret = gpio_direction_input(gpios[i].gpio);
 
-		if (ret)
+		if (ret) {
+			gpio_free(gpios[i].gpio);
 			goto err_gpio;
+		}
 	}
 
 	mutex_init(&collie_bat_main.work_lock);
@@ -363,10 +363,8 @@ err_psy_reg_main:
 
 	/* see comment in collie_bat_remove */
 	cancel_work_sync(&bat_work);
-
-	i--;
 err_gpio:
-	for (; i >= 0; i--)
+	while (--i >= 0)
 		gpio_free(gpios[i].gpio);
 
 	return ret;
-- 
1.7.4.1




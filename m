Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1CURKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:10:40 -0400
Received: from smtp.nokia.com ([147.243.128.24]:38505 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab1CURKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:10:38 -0400
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: [PATCH] input: tsc2005: use relative jiffies to schedule the watchdog
Date: Mon, 21 Mar 2011 19:07:51 +0200
Message-Id: <1300727271-20120-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use relative jiffies to schedule the watchdog. Otherwise it will run
like a mad one.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 drivers/input/touchscreen/tsc2005.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 3a15587..ea7f436 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -358,7 +358,7 @@ static void __tsc2005_enable(struct tsc2005 *ts)
 	if (ts->esd_timeout && ts->set_reset) {
 		ts->last_valid_interrupt = jiffies;
 		schedule_delayed_work(&ts->esd_work,
-				round_jiffies(jiffies +
+				round_jiffies_relative(
 					msecs_to_jiffies(ts->esd_timeout)));
 	}
 
@@ -518,7 +518,7 @@ static void tsc2005_esd_work(struct work_struct *work)
 out:
 	/* re-arm the watchdog */
 	schedule_delayed_work(&ts->esd_work,
-			      round_jiffies(jiffies +
+			      round_jiffies_relative(
 					msecs_to_jiffies(ts->esd_timeout)));
 	mutex_unlock(&ts->mutex);
 }
-- 
1.5.6.5


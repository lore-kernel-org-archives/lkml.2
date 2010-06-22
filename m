Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0FVLlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:41:05 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:35793 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0FVLlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:41:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Jiri Slaby <jslaby@suse.cz>, Todd Fischer <todd.fischer@ridgerun.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org
Subject: [PATCH] INPUT: tps6507x-ts, remove unneeded NULL test
Date: Tue, 22 Jun 2010 13:41:02 +0200
Message-Id: <1277206862-27146-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that tsc is dereferenced earlier than checked for being
NULL in tps6507x_ts_remove. Remove the test because I see no way, how
tsc can be NULL there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/touchscreen/tps6507x-ts.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index 5b70a14..a644d18 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -355,9 +355,6 @@ static int __devexit tps6507x_ts_remove(struct platform_device *pdev)
 	struct tps6507x_ts *tsc = tps6507x_dev->ts;
 	struct input_dev *input_dev = tsc->input_dev;
 
-	if (!tsc)
-		return 0;
-
 	cancel_delayed_work_sync(&tsc->work);
 	destroy_workqueue(tsc->wq);
 
-- 
1.7.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2AKFhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 00:37:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33619 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2AKFhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 00:37:03 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <greg@kroah.com>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH RFC] drivers/misc/bh1770glc.c: Make suspend depend on CONFIG_PM_SLEEP.
Date: Wed, 11 Jan 2012 11:06:46 +0530
Message-ID: <1326260206-3603-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SET_SYSTEM_SLEEP_PM_OPS  depends CONFIG_PM_SLEEP. The patch
defines the suspend and resume functions for CONFIG_PM_SLEEP
instead of CONFIG_PM. Also the else part making NULL is unneeded
as the macro SET_SYSTEM_SLEEP_PM_OPS takes care of it.

Also delete the bh1770_shutdown reference as it is not used.

Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/misc/bh1770glc.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index d79a972..661e912 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -1310,7 +1310,7 @@ static int __devexit bh1770_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int bh1770_suspend(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
@@ -1347,10 +1347,6 @@ static int bh1770_resume(struct device *dev)
 	return ret;
 }
 
-#else
-#define bh1770_suspend	NULL
-#define bh1770_shutdown NULL
-#define bh1770_resume	NULL
 #endif
 
 #ifdef CONFIG_PM_RUNTIME
-- 
1.7.1


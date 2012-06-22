Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252Ab2FVFxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:53:00 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:41009 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2FVFw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:52:58 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 01:52:58 EDT
From: Sherwin Soltani <sherwin@wybc.com>
To: greg@kroah.com
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sherwin Soltani <sherwin@wybc.com>
Subject: [PATCH] Staging: android: logger.c: fixed some printk macros
Date: Fri, 22 Jun 2012 01:44:46 -0400
Message-Id: <1340343886-311-1-git-send-email-sherwin@wybc.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few printk messages in logger.c to make checkpatch.pl happy.

Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
---
 drivers/staging/android/logger.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index b2e71c6..b490c5c 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -621,13 +621,13 @@ static int __init create_log(char *log_name, int size)
 	/* finally, initialize the misc device for this log */
 	ret = misc_register(&log->misc);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "logger: failed to register misc "
-		       "device for log '%s'!\n", log->misc.name);
+		pr_err("logger: failed to register misc device for log '%s'!\n",
+			log->misc.name);
 		goto out_free_log;
 	}
 
-	printk(KERN_INFO "logger: created %luK log '%s'\n",
-	       (unsigned long) log->size >> 10, log->misc.name);
+	pr_info("logger: created %luK log '%s'\n",
+		(unsigned long) log->size >> 10, log->misc.name);
 
 	return 0;
 
-- 
1.7.9.5


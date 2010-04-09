Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0DIODE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:03:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab0DIOB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:26 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 07/12] rtc-m41t80: Use nonseekable_open()
Date: Fri,  9 Apr 2010 16:00:50 +0200
Message-Id: <1270821655-4368-8-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use nonseekable_open() for this since seeking is not supported anyway.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/rtc/rtc-m41t80.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 60fe266..1e2ed76 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -595,10 +595,6 @@ static void wdt_disable(void)
 static ssize_t wdt_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	/*  Can't seek (pwrite) on this device
-	if (ppos != &file->f_pos)
-	return -ESPIPE;
-	*/
 	if (count) {
 		wdt_ping();
 		return 1;
@@ -695,7 +691,7 @@ static int wdt_open(struct inode *inode, struct file *file)
 		 */
 		wdt_is_open = 1;
 		unlock_kernel();
-		return 0;
+		return nonseekable_open(inode, file);
 	}
 	return -ENODEV;
 }
-- 
1.6.4.2


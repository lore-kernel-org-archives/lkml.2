Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0E2Eae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 00:30:34 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:35540 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0E2EaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 00:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YdQpGSY+ijalwgw8diMbuK+AZgvjyeN2p3bbwWmOnUa490GGnJ/QcIaA1RtfLXMT1c
         Mx2qiI8BZbwnjDtUCDyq3twhiDY3D6NykIGsA+zvqkDtylqMgKzqgUONSc+CMrIQbzfS
         Hb8avFafpz7KqFh/3kQt+BAkwd2h1DljPcoVM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/2] s390: remove WARN_ON for misc_deregister() failures
Date: Sat, 29 May 2010 13:28:51 +0900
Message-Id: <1275107331-5045-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1275107331-5045-1-git-send-email-akinobu.mita@gmail.com>
References: <1275107331-5045-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous change added WARN_ON() in misc_deregister().
So it is not necessary to WARN_ON() misc_deregister() failure by
callers.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/block/dasd_eer.c |    2 +-
 drivers/s390/char/monreader.c |    2 +-
 drivers/s390/char/monwriter.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index dd88803..7158f95 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -701,7 +701,7 @@ int __init dasd_eer_init(void)
 void dasd_eer_exit(void)
 {
 	if (dasd_eer_dev) {
-		WARN_ON(misc_deregister(dasd_eer_dev) != 0);
+		misc_deregister(dasd_eer_dev);
 		kfree(dasd_eer_dev);
 		dasd_eer_dev = NULL;
 	}
diff --git a/drivers/s390/char/monreader.c b/drivers/s390/char/monreader.c
index 2ed3f82..e021ec6 100644
--- a/drivers/s390/char/monreader.c
+++ b/drivers/s390/char/monreader.c
@@ -627,7 +627,7 @@ out_iucv:
 static void __exit mon_exit(void)
 {
 	segment_unload(mon_dcss_name);
-	WARN_ON(misc_deregister(&mon_dev) != 0);
+	misc_deregister(&mon_dev);
 	device_unregister(monreader_device);
 	driver_unregister(&monreader_driver);
 	iucv_unregister(&monreader_iucv_handler, 1);
diff --git a/drivers/s390/char/monwriter.c b/drivers/s390/char/monwriter.c
index 98a49df..572a1e7 100644
--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -380,7 +380,7 @@ out_driver:
 
 static void __exit mon_exit(void)
 {
-	WARN_ON(misc_deregister(&mon_dev) != 0);
+	misc_deregister(&mon_dev);
 	platform_device_unregister(monwriter_pdev);
 	platform_driver_unregister(&monwriter_pdrv);
 }
-- 
1.6.0.6


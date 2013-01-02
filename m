Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3ABFYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:24:21 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:32379 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3ABFYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:24:19 -0500
Message-ID: <1357104253.2182.4.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 1/3] staging: zram: simplify num_devices paramater
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Date: Tue, 01 Jan 2013 21:24:13 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify dealing with num_devices when initializing zram.
Also cleanup some of the output messages.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 drivers/staging/zram/zram_drv.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index fb4a7c9..8115be9 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -40,7 +40,7 @@ static int zram_major;
 struct zram *zram_devices;
 
 /* Module params (documentation at end) */
-static unsigned int num_devices;
+static unsigned int num_devices = 1;
 
 static void zram_stat_inc(u32 *v)
 {
@@ -715,13 +715,7 @@ static int __init zram_init(void)
 		goto out;
 	}
 
-	if (!num_devices) {
-		pr_info("num_devices not specified. Using default: 1\n");
-		num_devices = 1;
-	}
-
 	/* Allocate the device array and initialize each one */
-	pr_info("Creating %u devices ...\n", num_devices);
 	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
 	if (!zram_devices) {
 		ret = -ENOMEM;
@@ -734,6 +728,8 @@ static int __init zram_init(void)
 			goto free_devices;
 	}
 
+	pr_info("Created %u device(s) ...\n", num_devices);
+
 	return 0;
 
 free_devices:
-- 
1.7.11.7





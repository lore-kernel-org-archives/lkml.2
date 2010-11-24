Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0KXI6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:58:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57866 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0KXI6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:58:03 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] block: add some KERN_CONT markers to continuation lines
Date: Wed, 24 Nov 2010 09:57:46 +0100
Message-Id: <1290589070-854-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101124085645.GW4693@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 block/genhd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5fa2b44..9437048 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -665,19 +665,19 @@ void __init printk_all_partitions(void)
 			if (part->info)
 				part_unpack_uuid(part->info->uuid, uuid);
 
-			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
+			printk(KERN_CONT "%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
 			       disk_name(disk, part->partno, name_buf), uuid);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
-					printk(" driver: %s\n",
+					printk(KERN_CONT " driver: %s\n",
 					      disk->driverfs_dev->driver->name);
 				else
-					printk(" (driver?)\n");
+					printk(KERN_CONT " (driver?)\n");
 			} else
-				printk("\n");
+				printk(KERN_CONT "\n");
 		}
 		disk_part_iter_exit(&piter);
 	}
-- 
1.7.2.3


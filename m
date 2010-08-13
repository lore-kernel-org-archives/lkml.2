Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499Ab0HMKpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761456Ab0HMKpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:45:13 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH] blk-fs: put dev->kobj in blk_register_queue fail path
Date: Fri, 13 Aug 2010 18:44:52 +0800
Message-Id: <1281696292-5746-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel needs to kobject_put on dev->kobj if elv_register_queue fails.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: David Teigland <teigland@redhat.com>
---
 block/blk-sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 001ab18..0749b89 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -511,6 +511,7 @@ int blk_register_queue(struct gendisk *disk)
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
 		blk_trace_remove_sysfs(disk_to_dev(disk));
+		kobject_put(&dev->kobj);
 		return ret;
 	}
 
-- 
1.7.2.1


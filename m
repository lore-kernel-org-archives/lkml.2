Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1HQJXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab1HQJXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:23:39 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        WANG Cong <amwang@redhat.com>,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 2/5] nbd: replace sysfs_create_file() with device_create_file()
Date: Wed, 17 Aug 2011 17:22:40 +0800
Message-Id: <1313572963-3440-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1313572963-3440-1-git-send-email-amwang@redhat.com>
References: <1313572963-3440-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <amwang@redhat.com>


Signed-off-by: WANG Cong <amwang@redhat.com>
---
 drivers/block/nbd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a928287..da98360 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -406,9 +406,9 @@ static int nbd_do_it(struct nbd_device *lo)
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = task_pid_nr(current);
-	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
 	if (ret) {
-		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		printk(KERN_ERR "nbd: device_create_file failed!");
 		lo->pid = 0;
 		return ret;
 	}
@@ -416,7 +416,7 @@ static int nbd_do_it(struct nbd_device *lo)
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
-	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	device_remove_file(disk_to_dev(lo->disk), &pid_attr);
 	lo->pid = 0;
 	return 0;
 }
-- 
1.7.4.4


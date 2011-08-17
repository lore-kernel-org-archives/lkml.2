Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1HQJXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:23:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1HQJX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:23:29 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        WANG Cong <amwang@redhat.com>,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 1/5] nbd: use task_pid_nr() to get current pid
Date: Wed, 17 Aug 2011 17:22:39 +0800
Message-Id: <1313572963-3440-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <amwang@redhat.com>


Signed-off-by: WANG Cong <amwang@redhat.com>
---
 drivers/block/nbd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index f533f33..a928287 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -405,7 +405,7 @@ static int nbd_do_it(struct nbd_device *lo)
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
-	lo->pid = current->pid;
+	lo->pid = task_pid_nr(current);
 	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
-- 
1.7.4.4


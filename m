Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0DETHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:07:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1382 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab0DETF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:05:56 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] drivers/char/mem.c: Rename dev_info to bdi
Date: Mon,  5 Apr 2010 12:05:40 -0700
Message-Id: <7838b5aa00b0d48ca0c5970f2d973693dee16be6.1270493677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
In-Reply-To: <cover.1270493677.git.joe@perches.com>
References: <cover.1270493677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro called dev_info that prints struct device specific
information.  Having variables with the same name can be confusing and
prevents conversion of the macro to a function.

Rename the existing dev_info variables to something else in preparation
to converting the dev_info macro to a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/mem.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1f3215a..cb1d642 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -839,7 +839,7 @@ static const struct memdev {
 	const char *name;
 	mode_t mode;
 	const struct file_operations *fops;
-	struct backing_dev_info *dev_info;
+	struct backing_dev_info *bdi;
 } devlist[] = {
 	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
 #ifdef CONFIG_DEVKMEM
@@ -873,8 +873,8 @@ static int memory_open(struct inode *inode, struct file *filp)
 		return -ENXIO;
 
 	filp->f_op = dev->fops;
-	if (dev->dev_info)
-		filp->f_mapping->backing_dev_info = dev->dev_info;
+	if (dev->bdi)
+		filp->f_mapping->backing_dev_info = dev->bdi;
 
 	if (dev->fops->open)
 		return dev->fops->open(inode, filp);
-- 
1.7.0.3.311.g6a6955


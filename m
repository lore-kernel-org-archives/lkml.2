Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2KIPhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:37:32 -0500
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42184 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2KIPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:37:30 -0500
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>, Ezequiel Garcia <elezegarcia@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] mtd_blkdev: Use a different name for block_device_operations variable
Date: Fri,  9 Nov 2012 12:36:35 -0300
Message-Id: <1352475395-11917-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct mtd_blktrans_ops is a type, and mtd_blktrans_ops is a variable.
To improve code clarity it's better to not use the same names,
so we just change the latter.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index f1f0671..26ef2a7 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -325,7 +325,7 @@ unlock:
 	return ret;
 }
 
-static const struct block_device_operations mtd_blktrans_ops = {
+static const struct block_device_operations mtd_block_ops = {
 	.owner		= THIS_MODULE,
 	.open		= blktrans_open,
 	.release	= blktrans_release,
@@ -401,7 +401,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	gd->private_data = new;
 	gd->major = tr->major;
 	gd->first_minor = (new->devnum) << tr->part_bits;
-	gd->fops = &mtd_blktrans_ops;
+	gd->fops = &mtd_block_ops;
 
 	if (tr->part_bits)
 		if (new->devnum < 26)
-- 
1.7.8.6


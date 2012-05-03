Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2ECB6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 21:58:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2ECB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 21:58:41 -0400
Message-ID: <1336009851.3590.4.camel@phoenix>
Subject: [PATCH] IIO: industrialio-core: Use simple_open
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 03 May 2012 09:50:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use simple_open to replace iio_debugfs_open.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/iio/industrialio-core.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 72e33b8..52aa44a 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -152,14 +152,6 @@ static void __exit iio_exit(void)
 }
 
 #if defined(CONFIG_DEBUG_FS)
-static int iio_debugfs_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t iio_debugfs_read_reg(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos)
 {
@@ -218,7 +210,7 @@ static ssize_t iio_debugfs_write_reg(struct file *file,
 }
 
 static const struct file_operations iio_debugfs_reg_fops = {
-	.open = iio_debugfs_open,
+	.open = simple_open,
 	.read = iio_debugfs_read_reg,
 	.write = iio_debugfs_write_reg,
 };
-- 
1.7.5.4




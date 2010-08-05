Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864Ab0HEWZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:25:42 -0400
Received: from kroah.org ([198.145.64.141]:37744 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab0HEWYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/67] tty_io: remove casts from void*
Date: Thu,  5 Aug 2010 15:23:16 -0700
Message-Id: <1281047014-23429-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 6bf6d36..0906c15 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -893,7 +893,7 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	struct inode *inode;
 	struct tty_ldisc *ld;
 
-	tty = (struct tty_struct *)file->private_data;
+	tty = file->private_data;
 	inode = file->f_path.dentry->d_inode;
 	if (tty_paranoia_check(tty, inode, "tty_read"))
 		return -EIO;
@@ -1070,7 +1070,7 @@ static ssize_t tty_write(struct file *file, const char __user *buf,
 	ssize_t ret;
 	struct tty_ldisc *ld;
 
-	tty = (struct tty_struct *)file->private_data;
+	tty = file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_write"))
 		return -EIO;
 	if (!tty || !tty->ops->write ||
@@ -1513,7 +1513,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	int	idx;
 	char	buf[64];
 
-	tty = (struct tty_struct *)filp->private_data;
+	tty = filp->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return 0;
 
@@ -1920,7 +1920,7 @@ static unsigned int tty_poll(struct file *filp, poll_table *wait)
 	struct tty_ldisc *ld;
 	int ret = 0;
 
-	tty = (struct tty_struct *)filp->private_data;
+	tty = filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_poll"))
 		return 0;
 
@@ -1937,7 +1937,7 @@ static int __tty_fasync(int fd, struct file *filp, int on)
 	unsigned long flags;
 	int retval = 0;
 
-	tty = (struct tty_struct *)filp->private_data;
+	tty = filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		goto out;
 
@@ -2497,7 +2497,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct tty_ldisc *ld;
 	struct inode *inode = file->f_dentry->d_inode;
 
-	tty = (struct tty_struct *)file->private_data;
+	tty = file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 
-- 
1.7.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab0F2KPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0F2KPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D+24A+Ver5tBfYh3Cbxu9mNyfqoMmXSfN7DIAWaRoENJCSbuaE5kgTULLeUK2bQlEG
         zeTy3kEVROdOZ4Tgan4p9F6lhRNpkY76Hio5n1n7V0VfTc5mh8JWYM0Ara+LPdj+ZKii
         J8FyCiEQEEX73oqAZqaoMY/hkrkGtxZBU3dtQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Young <hidave.darkstar@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/25] tty_io: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:09 +0400
Message-Id: <1277806510-30840-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/tty_io.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d71f0fc..6ff6266 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -879,7 +879,7 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	struct inode *inode;
 	struct tty_ldisc *ld;
 
-	tty = (struct tty_struct *)file->private_data;
+	tty = file->private_data;
 	inode = file->f_path.dentry->d_inode;
 	if (tty_paranoia_check(tty, inode, "tty_read"))
 		return -EIO;
@@ -1056,7 +1056,7 @@ static ssize_t tty_write(struct file *file, const char __user *buf,
 	ssize_t ret;
 	struct tty_ldisc *ld;
 
-	tty = (struct tty_struct *)file->private_data;
+	tty = file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_write"))
 		return -EIO;
 	if (!tty || !tty->ops->write ||
@@ -1508,7 +1508,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	int	idx;
 	char	buf[64];
 
-	tty = (struct tty_struct *)filp->private_data;
+	tty = filp->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return 0;
 
@@ -1915,7 +1915,7 @@ static unsigned int tty_poll(struct file *filp, poll_table *wait)
 	struct tty_ldisc *ld;
 	int ret = 0;
 
-	tty = (struct tty_struct *)filp->private_data;
+	tty = filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_poll"))
 		return 0;
 
@@ -1933,7 +1933,7 @@ static int tty_fasync(int fd, struct file *filp, int on)
 	int retval = 0;
 
 	lock_kernel();
-	tty = (struct tty_struct *)filp->private_data;
+	tty = filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		goto out;
 
@@ -2485,7 +2485,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct tty_ldisc *ld;
 	struct inode *inode = file->f_dentry->d_inode;
 
-	tty = (struct tty_struct *)file->private_data;
+	tty = file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 
-- 
1.7.0.4


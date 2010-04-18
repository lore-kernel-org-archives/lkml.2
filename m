Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0DRSkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:40:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:32985 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0DRSkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PGrAjObSkM2IErHzgVc5LPWxrA2FlVoeg5gX3fonWcX/gDeC5ETKMt85wvMAuw9ey6
         0QhDq2V/nn0hTk66pgxc6OMXSOg9LznOEY4W7lfqTrxb/HJG3mv2vJT8kqE7EGYfkuwb
         uYBAca5EF/vYeftQ0QhqF7m+SQkr+Sf8TLOKY=
From: Farid Hammane <farid.hammane@gmail.com>
To: khali@linux-fr.org
Cc: ben-linux@fluff.org, tglx@linutronix.de, vince@simtec.co.uk,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Farid Hammane <farid.hammane@gmail.com>
Subject: [PATCH] i2c-dev: fix all coding style issues in i2c-dev.c
Date: Sun, 18 Apr 2010 20:38:19 +0200
Message-Id: <1271615899-5894-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all coding style issues found by checkpatch.pl.

Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
---
 drivers/i2c/i2c-dev.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index f4110aa..a22b16c 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -35,7 +35,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-dev.h>
 #include <linux/jiffies.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static struct i2c_driver i2cdev_driver;
 
@@ -132,8 +132,8 @@ static DEVICE_ATTR(name, S_IRUGO, show_adapter_name, NULL);
  * needed by those system calls and by this SMBus interface.
  */
 
-static ssize_t i2cdev_read (struct file *file, char __user *buf, size_t count,
-                            loff_t *offset)
+static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
+		loff_t *offset)
 {
 	char *tmp;
 	int ret;
@@ -143,22 +143,22 @@ static ssize_t i2cdev_read (struct file *file, char __user *buf, size_t count,
 	if (count > 8192)
 		count = 8192;
 
-	tmp = kmalloc(count,GFP_KERNEL);
-	if (tmp==NULL)
+	tmp = kmalloc(count, GFP_KERNEL);
+	if (tmp == NULL)
 		return -ENOMEM;
 
 	pr_debug("i2c-dev: i2c-%d reading %zu bytes.\n",
 		iminor(file->f_path.dentry->d_inode), count);
 
-	ret = i2c_master_recv(client,tmp,count);
+	ret = i2c_master_recv(client, tmp, count);
 	if (ret >= 0)
-		ret = copy_to_user(buf,tmp,count)?-EFAULT:ret;
+		ret = copy_to_user(buf, tmp, count) ? -EFAULT : ret;
 	kfree(tmp);
 	return ret;
 }
 
-static ssize_t i2cdev_write (struct file *file, const char __user *buf, size_t count,
-                             loff_t *offset)
+static ssize_t i2cdev_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *offset)
 {
 	int ret;
 	char *tmp;
@@ -167,10 +167,10 @@ static ssize_t i2cdev_write (struct file *file, const char __user *buf, size_t c
 	if (count > 8192)
 		count = 8192;
 
-	tmp = kmalloc(count,GFP_KERNEL);
-	if (tmp==NULL)
+	tmp = kmalloc(count, GFP_KERNEL);
+	if (tmp == NULL)
 		return -ENOMEM;
-	if (copy_from_user(tmp,buf,count)) {
+	if (copy_from_user(tmp, buf, count)) {
 		kfree(tmp);
 		return -EFAULT;
 	}
@@ -178,7 +178,7 @@ static ssize_t i2cdev_write (struct file *file, const char __user *buf, size_t c
 	pr_debug("i2c-dev: i2c-%d writing %zu bytes.\n",
 		iminor(file->f_path.dentry->d_inode), count);
 
-	ret = i2c_master_send(client,tmp,count);
+	ret = i2c_master_send(client, tmp, count);
 	kfree(tmp);
 	return ret;
 }
@@ -375,7 +375,7 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	dev_dbg(&client->adapter->dev, "ioctl, cmd=0x%02x, arg=0x%02lx\n",
 		cmd, arg);
 
-	switch ( cmd ) {
+	switch (cmd) {
 	case I2C_SLAVE:
 	case I2C_SLAVE_FORCE:
 		/* NOTE:  devices set up to work with "new style" drivers
@@ -601,7 +601,7 @@ static void __exit i2c_dev_exit(void)
 {
 	i2c_del_driver(&i2cdev_driver);
 	class_destroy(i2c_dev_class);
-	unregister_chrdev(I2C_MAJOR,"i2c");
+	unregister_chrdev(I2C_MAJOR, "i2c");
 }
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
-- 
1.7.0


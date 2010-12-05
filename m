Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab0LER4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:56:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab0LERut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i1QcgIuGnrhWiMk6gKfnsRt9obP3U+9BeQyvAcK5uEeWiwH5n7zHFOEqym6bCqdnMA
         PLJCN4i+HkUBhK63czq4CjHVQyZUU3TbeJe//reKJUtSk6kgi8yymkfcF23iGLKVl3lE
         6Va1JhoG1gjQWnFEpEsEY4IOhv45YBP8JzvhE=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 16/45] kstrtox: convert drivers/bluetooth/
Date: Sun,  5 Dec 2010 19:49:13 +0200
Message-Id: <1291571382-2719-16-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/bluetooth/btmrvl_debugfs.c |   50 +++++++++++++++++------------------
 1 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_debugfs.c b/drivers/bluetooth/btmrvl_debugfs.c
index fd6305b..ffc4324 100644
--- a/drivers/bluetooth/btmrvl_debugfs.c
+++ b/drivers/bluetooth/btmrvl_debugfs.c
@@ -56,16 +56,16 @@ static ssize_t btmrvl_hscfgcmd_write(struct file *file,
 {
 	struct btmrvl_private *priv = file->private_data;
 	char buf[16];
-	long result, ret;
+	int ret;
 
 	memset(buf, 0, sizeof(buf));
 
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	ret = strict_strtol(buf, 10, &result);
-
-	priv->btmrvl_dev.hscfgcmd = result;
+	ret = kstrtou8(buf, 10, &priv->btmrvl_dev.hscfgcmd);
+	if (ret < 0)
+		return ret;
 
 	if (priv->btmrvl_dev.hscfgcmd) {
 		btmrvl_prepare_command(priv);
@@ -100,17 +100,16 @@ static ssize_t btmrvl_psmode_write(struct file *file, const char __user *ubuf,
 {
 	struct btmrvl_private *priv = file->private_data;
 	char buf[16];
-	long result, ret;
+	int ret;
 
 	memset(buf, 0, sizeof(buf));
 
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	ret = strict_strtol(buf, 10, &result);
-
-	priv->btmrvl_dev.psmode = result;
-
+	ret = kstrtou8(buf, 10, &priv->btmrvl_dev.psmode);
+	if (ret < 0)
+		return ret;
 	return count;
 }
 
@@ -139,16 +138,16 @@ static ssize_t btmrvl_pscmd_write(struct file *file, const char __user *ubuf,
 {
 	struct btmrvl_private *priv = file->private_data;
 	char buf[16];
-	long result, ret;
+	int ret;
 
 	memset(buf, 0, sizeof(buf));
 
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	ret = strict_strtol(buf, 10, &result);
-
-	priv->btmrvl_dev.pscmd = result;
+	ret = kstrtou8(buf, 10, &priv->btmrvl_dev.pscmd);
+	if (ret < 0)
+		return ret;
 
 	if (priv->btmrvl_dev.pscmd) {
 		btmrvl_prepare_command(priv);
@@ -183,17 +182,16 @@ static ssize_t btmrvl_gpiogap_write(struct file *file, const char __user *ubuf,
 {
 	struct btmrvl_private *priv = file->private_data;
 	char buf[16];
-	long result, ret;
+	int ret;
 
 	memset(buf, 0, sizeof(buf));
 
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	ret = strict_strtol(buf, 16, &result);
-
-	priv->btmrvl_dev.gpio_gap = result;
-
+	ret = kstrtou16(buf, 16, &priv->btmrvl_dev.gpio_gap);
+	if (ret < 0)
+		return ret;
 	return count;
 }
 
@@ -222,16 +220,17 @@ static ssize_t btmrvl_hscmd_write(struct file *file, const char __user *ubuf,
 {
 	struct btmrvl_private *priv = file->private_data;
 	char buf[16];
-	long result, ret;
+	int ret;
 
 	memset(buf, 0, sizeof(buf));
 
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	ret = strict_strtol(buf, 10, &result);
+	ret = kstrtou8(buf, 10, &priv->btmrvl_dev.hscmd);
+	if (ret < 0)
+		return ret;
 
-	priv->btmrvl_dev.hscmd = result;
 	if (priv->btmrvl_dev.hscmd) {
 		btmrvl_prepare_command(priv);
 		wake_up_interruptible(&priv->main_thread.wait_q);
@@ -264,17 +263,16 @@ static ssize_t btmrvl_hsmode_write(struct file *file, const char __user *ubuf,
 {
 	struct btmrvl_private *priv = file->private_data;
 	char buf[16];
-	long result, ret;
+	int ret;
 
 	memset(buf, 0, sizeof(buf));
 
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	ret = strict_strtol(buf, 10, &result);
-
-	priv->btmrvl_dev.hsmode = result;
-
+	ret = kstrtou8(buf, 10, &priv->btmrvl_dev.hsmode);
+	if (ret < 0)
+		return ret;
 	return count;
 }
 
-- 
1.7.2.2


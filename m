Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1BEOVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1BEOVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rNXB85DpYbHwIUd4F77lsFX/xRF5qBXnHaf8HLRLWoOJVRyHhwNMtQNOwZBpX0+1l4
         IUVQVCcxgc7737eNM6tTLK3N+0FMCaXbGodO9OoOFYAimPhYEd3TNoa7B5bncmK4EuEI
         bpNeGyS18XNx0PWAvQT5teNLedNJ6ipLtfiSQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 14/52] kstrtox: convert drivers/bluetooth/
Date: Sat,  5 Feb 2011 16:20:17 +0200
Message-Id: <1296915654-7458-14-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
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
1.7.3.4


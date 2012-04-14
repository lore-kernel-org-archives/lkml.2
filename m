Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2DNXZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 19:25:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33582 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754925Ab2DNXZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 19:25:12 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+DnCETjkmDVF+PtEK+o0kKwuAW2QAjWraLH5ibN5
	ykL+jEEaefQcYH
From: Peter Huewe <peterhuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] video/via: Convert to kstrtou8_from_user
Date: Sun, 15 Apr 2012 01:24:46 +0200
Message-Id: <1334445886-32448-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an number from a
userspace buffer by a simple call to kstrou8_from_user.
This makes it easier to read and less error prone.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/video/via/viafbdev.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 0c88375..5b0d524 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1276,17 +1276,14 @@ static int viafb_dfph_proc_open(struct inode *inode, struct file *file)
 static ssize_t viafb_dfph_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
-	char buf[20];
+	int err;
 	u8 reg_val = 0;
-	unsigned long length;
 	if (count < 1)
 		return -EINVAL;
-	length = count > 20 ? 20 : count;
-	if (copy_from_user(&buf[0], buffer, length))
-		return -EFAULT;
-	buf[length - 1] = '\0';	/*Ensure end string */
-	if (kstrtou8(buf, 0, &reg_val) < 0)
-		return -EINVAL;
+	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
+	if (err)
+		return err;
+
 	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1316,17 +1313,14 @@ static int viafb_dfpl_proc_open(struct inode *inode, struct file *file)
 static ssize_t viafb_dfpl_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
-	char buf[20];
+	int err;
 	u8 reg_val = 0;
-	unsigned long length;
 	if (count < 1)
 		return -EINVAL;
-	length = count > 20 ? 20 : count;
-	if (copy_from_user(&buf[0], buffer, length))
-		return -EFAULT;
-	buf[length - 1] = '\0';	/*Ensure end string */
-	if (kstrtou8(buf, 0, &reg_val) < 0)
-		return -EINVAL;
+	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
+	if (err)
+		return err;
+
 	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
 	return count;
 }
-- 
1.7.3.4


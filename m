Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0GKCQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:16:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36794 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab0GKCP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=ngx7vS2g++oP7Bhh+pfyCXO+xOoOiSf8pN2zsuCMXok6uG5YxfGSTz8Ub6x5FzN+K5
         Y1/7pgT10RvJpqibrkQi4sBcbDlH4dNqXS/UziaNjHfPv+shFhv4PkgYJaDv1ItSBk5S
         6Of2ZZ5gJH2Xv1bnZVXtwtaOdAi4CCNyAQLXQ=
Date: Sun, 11 Jul 2010 10:16:04 +0800
From: "crosslonelyover" <crosslonelyover@gmail.com>
To: "kernel-janitors" <kernel-janitors@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ext4" <linux-ext4@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "kernel-janitors" <kernel-janitors@vger.kernel.org>,
       "error27" <error27@gmail.com>
Subject: [PATCH & RESEND] avoid NULL deference in ext2_xattr_get
Message-ID: <201007111016021569718@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan Carpenter,

     Thanks for your instructions. I regenerated the patch.
Please check it.

>From 3149865e0d118b939c27659a4e4c884eaa6b3a4c Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <crosslonelyover@gmail.com>
Date: Sat, 10 Jul 2010 22:07:37 -0400
Subject: [PATCH] avoid NULL deference in ext2_xattr_get


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..81ec1c6 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -156,11 +156,12 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
 	char *end;
 	int error;
 
+	if (name == NULL)
+		return -EINVAL;
+
 	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
 		  name_index, name, buffer, (long)buffer_size);
 
-	if (name == NULL)
-		return -EINVAL;
 	down_read(&EXT2_I(inode)->xattr_sem);
 	error = -ENODATA;
 	if (!EXT2_I(inode)->i_file_acl)
-- 
1.7.1.1



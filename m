Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2DOAUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 20:20:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41426 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755158Ab2DOAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 20:20:33 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+jROQkBcujNHSVOYI5lvCyrJQKGctZxczwi3dAua
	LsVDgp4K6n6g9y
From: Peter Huewe <peterhuewe@gmx.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] fs/fuse: Convert to kstrtoul_from_user
Date: Sun, 15 Apr 2012 02:20:27 +0200
Message-Id: <1334449227-12011-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an number from a
userspace buffer by a simple call to kstroul_from_user.
This makes it easier to read and less error prone.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 fs/fuse/control.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 42593c5..03ff5b1 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -75,19 +75,13 @@ static ssize_t fuse_conn_limit_write(struct file *file, const char __user *buf,
 				     unsigned global_limit)
 {
 	unsigned long t;
-	char tmp[32];
 	unsigned limit = (1 << 16) - 1;
 	int err;
 
-	if (*ppos || count >= sizeof(tmp) - 1)
-		return -EINVAL;
-
-	if (copy_from_user(tmp, buf, count))
+	if (*ppos)
 		return -EINVAL;
 
-	tmp[count] = '\0';
-
-	err = strict_strtoul(tmp, 0, &t);
+	err = kstrtoul_from_user(buf, count, 0, &t);
 	if (err)
 		return err;
 
-- 
1.7.3.4


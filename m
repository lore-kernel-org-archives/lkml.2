Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1AQGqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:46:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59005 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1AQGqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NgWNvkDRie1KaaQhg18w2cMM0pfgLEUlsaI2hYuKAWdLqPUmL2E/qnk/Ru6cw5mdw7
         cNTTQUqHVUyFH1iKW99Lxo8EHjdZbSewTfyrg9/yWVHYGi6nm+8B4pBeQSl9cbDDsIpV
         PRTYwQAEbcK3yGH3yAdENslli7I0wxcd84KEs=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] locks: use assign_type()
Date: Mon, 17 Jan 2011 15:45:59 +0900
Message-Id: <1295246759-5738-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/locks.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 0f3998291f78..2c2d3b804d62 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -415,17 +415,7 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_ops = NULL;
 	fl->fl_lmops = NULL;
 
-	switch (l->l_type) {
-	case F_RDLCK:
-	case F_WRLCK:
-	case F_UNLCK:
-		fl->fl_type = l->l_type;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return (0);
+	return assign_type(fl, l->l_type);
 }
 #endif
 
-- 
1.7.3.4.600.g982838b0


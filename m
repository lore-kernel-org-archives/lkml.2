Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab1GHEPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:15:14 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:32854 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab1GHEOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:14:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwHAIiCFk55LCkBgWdsb2JhbABTmE2OdBUBARYmJc0NhjgEmmyINg
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 01/14] dcache: fix __d_alloc prototype to use const
Date: Fri,  8 Jul 2011 14:14:33 +1000
Message-Id: <1310098486-6453-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310098486-6453-1-git-send-email-david@fromorbit.com>
References: <1310098486-6453-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/internal.h |    2 +-
 fs/libfs.c    |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 996862d..ae47c48 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -139,4 +139,4 @@ extern int invalidate_inodes(struct super_block *, bool);
 /*
  * dcache.c
  */
-extern struct dentry *__d_alloc(struct super_block *, struct qstr *);
+extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
diff --git a/fs/libfs.c b/fs/libfs.c
index 8cdcd1c..a4a0bdf 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -16,6 +16,8 @@
 
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 static inline int simple_positive(struct dentry *dentry)
 {
 	return dentry->d_inode && !d_unhashed(dentry);
-- 
1.7.5.1


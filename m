Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965448Ab1C3WCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:02:52 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43181 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281Ab1C3WB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:58 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 5/7] vfs: update dentry_unhash() comment
Date: Wed, 30 Mar 2011 15:09:26 -0700
Message-Id: <1301522968-4382-6-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1301522968-4382-1-git-send-email-sage@newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper is now only called by file systems, not the VFS.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 17de6ab..d376688 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2803,10 +2803,10 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
 }
 
 /*
- * We try to drop the dentry early: we should have
- * a usage count of 2 if we're the only user of this
- * dentry, and if that is true (possibly after pruning
- * the dcache), then we drop the dentry now.
+ * The dentry_unhash() helper will try to drop the dentry early: we
+ * should have a usage count of 1 if we're the only user of this
+ * dentry, and if that is true (possibly after pruning the dcache),
+ * then we drop the dentry now.
  *
  * A low-level filesystem can, if it choses, legally
  * do a
-- 
1.7.0


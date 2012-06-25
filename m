Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2FYUrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:47:51 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59362 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2FYUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:47:50 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ubifs: Fix build warning
Date: Mon, 25 Jun 2012 17:47:49 -0300
Message-Id: <1340657269-8588-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
fs/ubifs/dir.c: In function 'ubifs_rename':
fs/ubifs/dir.c:972:15: warning: 'saved_nlink' may be used uninitialized
in this function

Use gcc uninitialized_var macro to avoid bogus warning

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
Applies to v3.5-rc4

Changes since v1:
Use uninitialized_var macro

 fs/ubifs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index a6d42ef..40c2d04 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -41,6 +41,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/compiler.h>
 
 /**
  * inherit_flags - inherit flags of the parent inode.
@@ -969,7 +970,7 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
 	struct timespec time;
-	unsigned int saved_nlink;
+	unsigned int uninitialized_var(saved_nlink);
 
 	/*
 	 * Budget request settings: deletion direntry, new direntry, removing
-- 
1.7.10


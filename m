Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2FYPTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:19:42 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59071 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2FYPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:19:39 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ubifs: Fix build warning
Date: Mon, 25 Jun 2012 12:19:40 -0300
Message-Id: <1340637580-12711-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
fs/ubifs/dir.c: In function 'ubifs_rename':
fs/ubifs/dir.c:972:15: warning: 'saved_nlink' may be used uninitialized
in this function

Initilize saved_nlink to 0

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 fs/ubifs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index a6d42ef..d5b8cb1e 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -969,7 +969,7 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
 	struct timespec time;
-	unsigned int saved_nlink;
+	unsigned int saved_nlink = 0;
 
 	/*
 	 * Budget request settings: deletion direntry, new direntry, removing
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2CMBAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:00:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:47682 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab2CMAW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 057/196] UBIFS: restrict world-writable debugfs files
Date: Mon, 12 Mar 2012 20:19:30 -0400
Message-Id: <1331598109-31424-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8c559d30b4e59cf6994215ada1fe744928f494bf upstream.

Don't allow everybody to dump sensitive information about filesystems.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ubifs/debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 923d697..a0c09fc 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2687,19 +2687,19 @@ int dbg_debugfs_init_fs(struct ubifs_info *c)
 	}
 
 	fname = "dump_lprops";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_lprops = dent;
 
 	fname = "dump_budg";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_budg = dent;
 
 	fname = "dump_tnc";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_tnc = dent;
-- 
1.7.9.3


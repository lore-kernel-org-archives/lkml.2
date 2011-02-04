Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1BDMY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:24:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1BDMYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:24:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Vj/fl+YN5rtBUgeSy72/XuKPdnW1vjcll1JSpl55roTUYFcV9wEgPVf/Bc8UbnSIlL
         gNzoC5ldT/2PLpDfEnYvE6TmzR1VwYUDaJC3+noYCcrnSNc4p/kgnlPspJYldnw2ybIr
         GpguzJXlTH/vey8IohnbifOiBuD5H4NKchDUc=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org
Subject: [PATCH 20/20] fs: ubifs: world-writable debugfs dump_* files
Date: Fri,  4 Feb 2011 15:24:19 +0300
Message-Id: <cd575609cc07581a71ba925308d9d69c6e0c6d79.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to dump sensitive information about filesystems.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 fs/ubifs/debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 0bee4db..bcb1acb 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2813,19 +2813,19 @@ int dbg_debugfs_init_fs(struct ubifs_info *c)
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
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0IFAwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:52:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:50974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab0IFAwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:52:00 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:29 +1000
Subject: [PATCH 08/10] VFS: tiny optimisation in open_other handling.
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005029.20775.19530.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If IS_ERR(ret), then ret != NULL, so if we are performing the second
test we don't need the first.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/open.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 89e4f34..b986ca1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -687,7 +687,7 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	if (!open && f->f_op && f->f_op->open_other) {
 		/* NULL means keep f, non-error non-null means replace */
 		ret = f->f_op->open_other(f);
-		if (IS_ERR(ret) || ret != NULL)
+		if (ret)
 			goto cleanup_all;
 	} else {
 		if (!open && f->f_op)



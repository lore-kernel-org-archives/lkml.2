Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0IPWOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab0IPWOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:34 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Blunck <jblunck@suse.de>, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 16/34] union-mount: Create IS_MNT_UNION()
Date: Thu, 16 Sep 2010 15:12:07 -0700
Message-Id: <1284675145-4391-17-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

IS_MNT_UNION() tests whether a vfsmount is a union.  Note that a
directory in a union mounted file system is not necessarily unioned.
Use IS_DIR_UNIONED() to test that.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/union.h b/fs/union.h
index 1692803..c496823 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -49,6 +49,7 @@ struct union_stack {
 	struct path u_dirs[0];
 };
 
+#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
 #define IS_DIR_UNIONED(dentry)	((dentry)->d_union_stack)
 
 extern void d_free_unions(struct dentry *);
@@ -64,6 +65,7 @@ static inline struct path *union_find_dir(struct dentry *dentry,
 
 #else /* CONFIG_UNION_MOUNT */
 
+#define IS_MNT_UNION(x)			(0)
 #define IS_DIR_UNIONED(x)		(0)
 
 #define d_free_unions(x)		do { } while (0)
-- 
1.6.3.3


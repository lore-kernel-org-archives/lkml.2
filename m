Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0J3VJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:09:46 -0400
Received: from mail.perches.com ([173.55.12.10]:3787 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0J3VJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:43 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/39] fs: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:45 -0700
Message-Id: <79733904005b2732d054989308a46a5ce2016ac5.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/bio.c    |    2 +-
 fs/buffer.c |    2 +-
 fs/super.c  |    5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 8abb2df..c2837c4 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -134,7 +134,7 @@ static void bio_put_slab(struct bio_set *bs)
 		}
 	}
 
-	if (WARN(!bslab, KERN_ERR "bio: unable to find slab!\n"))
+	if (WARN(!bslab, "bio: unable to find slab!\n"))
 		goto out;
 
 	WARN_ON(!bslab->slab_ref);
diff --git a/fs/buffer.c b/fs/buffer.c
index 5930e38..8d0319b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1186,7 +1186,7 @@ void __brelse(struct buffer_head * buf)
 		put_bh(buf);
 		return;
 	}
-	WARN(1, KERN_ERR "VFS: brelse: Trying to free free buffer\n");
+	WARN(1, "VFS: brelse: Trying to free free buffer\n");
 }
 EXPORT_SYMBOL(__brelse);
 
diff --git a/fs/super.c b/fs/super.c
index ca69615..ade7cd2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1009,8 +1009,9 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	 * violate this rule. This warning should be either removed or
 	 * converted to a BUG() in 2.6.34.
 	 */
-	WARN((mnt->mnt_sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
-		"negative value (%lld)\n", type->name, mnt->mnt_sb->s_maxbytes);
+	WARN((mnt->mnt_sb->s_maxbytes < 0),
+	     "%s set sb->s_maxbytes to negative value (%lld)\n",
+	     type->name, mnt->mnt_sb->s_maxbytes);
 
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
-- 
1.7.3.1.g432b3.dirty


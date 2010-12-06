Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0LFWHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:44 -0500
Received: from mail.perches.com ([173.55.12.10]:2341 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/29] fs: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:10 -0800
Message-Id: <e8dd1ca94f24f2b1df3556040a542c701fa13ca4.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
index 4bd454f..d366f05 100644
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
index 3a70821..7e060fd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1191,7 +1191,7 @@ void __brelse(struct buffer_head * buf)
 		put_bh(buf);
 		return;
 	}
-	WARN(1, KERN_ERR "VFS: brelse: Trying to free free buffer\n");
+	WARN(1, "VFS: brelse: Trying to free free buffer\n");
 }
 EXPORT_SYMBOL(__brelse);
 
diff --git a/fs/super.c b/fs/super.c
index ca51b70..7920ab9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1012,8 +1012,9 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
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
1.7.3.2.245.g03276.dirty


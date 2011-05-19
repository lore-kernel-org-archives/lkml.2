Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab1ESJKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab1ESJKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:39 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 26/32] GFS2: Move final part of inode.c into super.c
Date: Thu, 19 May 2011 09:47:21 +0100
Message-Id: <1305794847-3291-27-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now inode.c is empty.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index b95ee5d..9076fbe 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -36,39 +36,3 @@
 #include "util.h"
 
 
-void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
-{
-	struct gfs2_dinode *str = buf;
-
-	str->di_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
-	str->di_header.mh_type = cpu_to_be32(GFS2_METATYPE_DI);
-	str->di_header.mh_format = cpu_to_be32(GFS2_FORMAT_DI);
-	str->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
-	str->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
-	str->di_mode = cpu_to_be32(ip->i_inode.i_mode);
-	str->di_uid = cpu_to_be32(ip->i_inode.i_uid);
-	str->di_gid = cpu_to_be32(ip->i_inode.i_gid);
-	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
-	str->di_size = cpu_to_be64(i_size_read(&ip->i_inode));
-	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
-	str->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
-	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
-	str->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
-
-	str->di_goal_meta = cpu_to_be64(ip->i_goal);
-	str->di_goal_data = cpu_to_be64(ip->i_goal);
-	str->di_generation = cpu_to_be64(ip->i_generation);
-
-	str->di_flags = cpu_to_be32(ip->i_diskflags);
-	str->di_height = cpu_to_be16(ip->i_height);
-	str->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) &&
-					     !(ip->i_diskflags & GFS2_DIF_EXHASH) ?
-					     GFS2_FORMAT_DE : 0);
-	str->di_depth = cpu_to_be16(ip->i_depth);
-	str->di_entries = cpu_to_be32(ip->i_entries);
-
-	str->di_eattr = cpu_to_be64(ip->i_eattr);
-	str->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
-	str->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
-	str->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
-}
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 3061ac6..ed540e7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -701,6 +701,42 @@ void gfs2_unfreeze_fs(struct gfs2_sbd *sdp)
 	mutex_unlock(&sdp->sd_freeze_lock);
 }
 
+void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
+{
+	struct gfs2_dinode *str = buf;
+
+	str->di_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
+	str->di_header.mh_type = cpu_to_be32(GFS2_METATYPE_DI);
+	str->di_header.mh_format = cpu_to_be32(GFS2_FORMAT_DI);
+	str->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
+	str->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
+	str->di_mode = cpu_to_be32(ip->i_inode.i_mode);
+	str->di_uid = cpu_to_be32(ip->i_inode.i_uid);
+	str->di_gid = cpu_to_be32(ip->i_inode.i_gid);
+	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
+	str->di_size = cpu_to_be64(i_size_read(&ip->i_inode));
+	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
+	str->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
+	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
+	str->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
+
+	str->di_goal_meta = cpu_to_be64(ip->i_goal);
+	str->di_goal_data = cpu_to_be64(ip->i_goal);
+	str->di_generation = cpu_to_be64(ip->i_generation);
+
+	str->di_flags = cpu_to_be32(ip->i_diskflags);
+	str->di_height = cpu_to_be16(ip->i_height);
+	str->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) &&
+					     !(ip->i_diskflags & GFS2_DIF_EXHASH) ?
+					     GFS2_FORMAT_DE : 0);
+	str->di_depth = cpu_to_be16(ip->i_depth);
+	str->di_entries = cpu_to_be32(ip->i_entries);
+
+	str->di_eattr = cpu_to_be64(ip->i_eattr);
+	str->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
+	str->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
+	str->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
+}
 
 /**
  * gfs2_write_inode - Make sure the inode is stable on the disk
-- 
1.7.4


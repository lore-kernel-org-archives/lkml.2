Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0JYAL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:11:28 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:46460 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495Ab0JYAL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:11:27 -0400
Message-ID: <4CC4CA18.7090102@lougher.demon.co.uk>
Date: Mon, 25 Oct 2010 01:06:48 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] Squashfs: fix function prototype
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The fourth argument should be unsigned.  Also add missing include
so that the function prototype is defined in xattr_id.c

This fixes a couple of sparse warnings.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/xattr.h    |    4 ++--
  fs/squashfs/xattr_id.c |    1 +
  2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/xattr.h b/fs/squashfs/xattr.h
index 49fe0d7..b634efc 100644
--- a/fs/squashfs/xattr.h
+++ b/fs/squashfs/xattr.h
@@ -25,7 +25,7 @@
  extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
  		u64 *, int *);
  extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
-		int *, unsigned long long *);
+		unsigned int *, unsigned long long *);
  #else
  static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
  		u64 start, u64 *xattr_table_start, int *xattr_ids)
@@ -35,7 +35,7 @@ static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
  }

  static inline int squashfs_xattr_lookup(struct super_block *sb,
-		unsigned int index, int *count, int *size,
+		unsigned int index, int *count, unsigned int *size,
  		unsigned long long *xattr)
  {
  	return 0;
diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index cfb4110..d33be5d 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -34,6 +34,7 @@
  #include "squashfs_fs_sb.h"
  #include "squashfs_fs_i.h"
  #include "squashfs.h"
+#include "xattr.h"

  /*
   * Map xattr id using the xattr id look up table
-- 
1.6.3.3


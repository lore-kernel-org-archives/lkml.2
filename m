Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab1HWASV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:18:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61704 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1HWAST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:18:19 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, chris.mason@oracle.com,
        Wanlong Gao <wanlong.gao@gmail.com>, t-itoh@jp.fujitsu.com
Subject: [PATCH v2] btrfs:make btrfs_init_compress() return void
Date: Tue, 23 Aug 2011 08:16:57 +0800
Message-Id: <1314058617-3283-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314022940-6717-1-git-send-email-wanlong.gao@gmail.com>
References: <1314022940-6717-1-git-send-email-wanlong.gao@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 08:17:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 08:17:13,
	Serialize complete at 2011-08-23 08:17:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make btrfs_init_compress() return void, since it always return 0,
and no need to check return value.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/btrfs/compression.c |    3 +--
 fs/btrfs/compression.h |    2 +-
 fs/btrfs/super.c       |    7 +++----
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8ec5d86..b2dbefa 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -731,7 +731,7 @@ struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_lzo_compress,
 };
 
-int __init btrfs_init_compress(void)
+void __init btrfs_init_compress(void)
 {
 	int i;
 
@@ -741,7 +741,6 @@ int __init btrfs_init_compress(void)
 		atomic_set(&comp_alloc_workspace[i], 0);
 		init_waitqueue_head(&comp_workspace_wait[i]);
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index a12059f..9afb0a6 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -19,7 +19,7 @@
 #ifndef __BTRFS_COMPRESSION_
 #define __BTRFS_COMPRESSION_
 
-int btrfs_init_compress(void);
+void btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
 int btrfs_compress_pages(int type, struct address_space *mapping,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..ece8d9f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1238,9 +1238,7 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		return err;
 
-	err = btrfs_init_compress();
-	if (err)
-		goto free_sysfs;
+	btrfs_init_compress();
 
 	err = btrfs_init_cachep();
 	if (err)
@@ -1281,8 +1279,9 @@ free_cachep:
 	btrfs_destroy_cachep();
 free_compress:
 	btrfs_exit_compress();
-free_sysfs:
+
 	btrfs_exit_sysfs();
+
 	return err;
 }
 
-- 
1.7.6


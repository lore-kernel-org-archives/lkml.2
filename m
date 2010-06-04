Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0FDLzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:55:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49417 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0FDLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:55:41 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: remove unused MNT_STRICTATIME
Message-Id: <E1OKVUr-0002cV-Te@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Jun 2010 13:55:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Commit d0adde574b8487ef30f69e2d08bba769e4be513f added MNT_STRICTATIME
but it isn't actually used (MS_STRICTATIME clears MNT_RELATIME and
MNT_NOATIME rather than setting any mount flag).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |    1 -
 include/linux/mount.h |    1 -
 2 files changed, 2 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-05-25 16:18:55.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-05-28 14:21:57.000000000 +0200
@@ -783,7 +783,6 @@ static void show_mnt_opts(struct seq_fil
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
-		{ MNT_STRICTATIME, ",strictatime" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2010-05-25 16:18:56.000000000 +0200
+++ linux-2.6/include/linux/mount.h	2010-05-28 14:21:57.000000000 +0200
@@ -27,7 +27,6 @@ struct mnt_namespace;
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
 #define MNT_READONLY	0x40	/* does the user want this to be r/o? */
-#define MNT_STRICTATIME 0x80
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200

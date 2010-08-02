Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0HBLrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:47:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47585 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0HBLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:46:59 -0400
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: remove unused MNT_STRICTATIME
Message-Id: <E1OftTs-0003Lw-OG@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Aug 2010 13:46:56 +0200
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
--- linux-2.6.orig/fs/namespace.c	2010-07-06 18:08:06.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-07-06 18:08:25.000000000 +0200
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
--- linux-2.6.orig/include/linux/mount.h	2010-07-06 17:59:04.000000000 +0200
+++ linux-2.6/include/linux/mount.h	2010-07-06 18:08:25.000000000 +0200
@@ -27,7 +27,6 @@ struct mnt_namespace;
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
 #define MNT_READONLY	0x40	/* does the user want this to be r/o? */
-#define MNT_STRICTATIME 0x80
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200

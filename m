Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1K3CPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:15:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49568 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:15:15 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/28] libfs: Use current logging styles
Date: Tue, 29 Nov 2011 18:14:02 -0800
Message-Id: <f25bca2930e72788c865ca5db98a8e54d60ee8c3.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>.
Coalesce long format strings.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/libfs.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index f6d411e..ad1532f 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -3,6 +3,8 @@
  *	Library for filesystems writers.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -502,9 +504,8 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
 
 		/* warn if it tries to conflict with the root inode */
 		if (unlikely(i == 1))
-			printk(KERN_WARNING "%s: %s passed in a files array"
-				"with an index of 1!\n", __func__,
-				s->s_type->name);
+			pr_warn("%s: %s passed in a files array with an index of 1!\n",
+				__func__, s->s_type->name);
 
 		dentry = d_alloc_name(root, files->name);
 		if (!dentry)
-- 
1.7.6.405.gc1be0


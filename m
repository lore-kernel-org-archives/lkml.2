Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855Ab2CKFKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 00:10:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45604 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2CKFKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 00:10:00 -0500
MIME-Version: 1.0
Date: Sun, 11 Mar 2012 13:09:59 +0800
Message-ID: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com>
Subject: [PATCH] hugetlbfs: add err code in initializing module
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error code is added if fail to create inode kmem cache, and newly registered
hugetlb FS is unregistered if fail to mount, both for unlikely corner cases.

--- a/fs/hugetlbfs/inode.c	Sun Mar 11 12:46:38 2012
+++ b/fs/hugetlbfs/inode.c	Sun Mar 11 12:49:28 2012
@@ -1000,6 +1000,7 @@ static int __init init_hugetlbfs_fs(void
 	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
 					sizeof(struct hugetlbfs_inode_info),
 					0, 0, init_once);
+	error = -ENOMEM;
 	if (hugetlbfs_inode_cachep == NULL)
 		goto out2;

@@ -1015,6 +1016,7 @@ static int __init init_hugetlbfs_fs(void
 	}

 	error = PTR_ERR(vfsmount);
+	unregister_filesystem(&hugetlbfs_fs_type);

  out:
 	if (error)
--

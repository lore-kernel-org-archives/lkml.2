Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1DDDg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 23:36:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52101 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1DDDg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 23:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hUP+AqWnBJqiQoN3H3kjrYyq6UHPXKhxjVjrbyYbTJIINKPQy/lPzAtnBchmtP6uw9
         HZ8DpHWf9zYtb7BLoXO+bcx8lSDYKAQATvPBI4bZhFXd4LLHVkYmzqBq6aUu8Zk2EBga
         mve4Wj2T92oqeF0WLgM7fES5eU7Ncgb/RpLOg=
MIME-Version: 1.0
Date: Mon, 4 Apr 2011 11:36:56 +0800
Message-ID: <BANLkTins3c6r0z-WR8PWrVvYa5OdOZ1BGg@mail.gmail.com>
Subject: [PATCH] hugetlbfs: simplify destroying inode
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: William Irwin <wli@holomorphy.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just before reclaimed by the hugetlbfs inode cache, little difference
could be made by initializing the list head of the dentry member of
vfs inode, thus the operation of initialization could be removed to
simplify the destroy of hugetlbfs inode.

Signed-off-by: Hillf Danton <gmail.com>
---

--- a/fs/hugetlbfs/inode.c	2011-03-30 03:09:48.000000000 +0800
+++ b/fs/hugetlbfs/inode.c	2011-04-04 11:27:30.000000000 +0800
@@ -665,7 +665,6 @@ static struct inode *hugetlbfs_alloc_ino
 static void hugetlbfs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
-	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
 }

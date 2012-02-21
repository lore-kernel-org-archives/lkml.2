Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2BUTyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab2BUTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/73] VFS: Comment mount following code [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com> (Original author),
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:57:44 +0000
Message-ID: <20120221175744.25235.42690.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments describing what the directions "up" and "down" mean and ref count
handling to the VFS mount following family of functions.

Signed-off-by: Valerie Aurora <vaurora@redhat.com> (Original author)
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c     |   10 ++++++++++
 fs/namespace.c |   16 ++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a780ea5..4dc0e1d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -688,6 +688,16 @@ static int follow_up_rcu(struct path *path)
 	return 1;
 }
 
+/*
+ * follow_up - Find the mountpoint of path's vfsmount
+ *
+ * Given a path, find the mountpoint of its source file system.
+ * Replace @path with the path of the mountpoint in the parent mount.
+ * Up is towards /.
+ *
+ * Return 1 if we went up a level and 0 if we were already at the
+ * root.
+ */
 int follow_up(struct path *path)
 {
 	struct mount *mnt = real_mount(path->mnt);
diff --git a/fs/namespace.c b/fs/namespace.c
index baedd0b..35c3b80 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -515,8 +515,20 @@ struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry,
 }
 
 /*
- * lookup_mnt increments the ref count before returning
- * the vfsmount struct.
+ * lookup_mnt - Return the first child mount mounted at path
+ *
+ * "First" means first mounted chronologically.  If you create the
+ * following mounts:
+ *
+ * mount /dev/sda1 /mnt
+ * mount /dev/sda2 /mnt
+ * mount /dev/sda3 /mnt
+ *
+ * Then lookup_mnt() on the base /mnt dentry in the root mount will
+ * return successively the root dentry and vfsmount of /dev/sda1, then
+ * /dev/sda2, then /dev/sda3, then NULL.
+ *
+ * lookup_mnt takes a reference to the found vfsmount.
  */
 struct vfsmount *lookup_mnt(struct path *path)
 {


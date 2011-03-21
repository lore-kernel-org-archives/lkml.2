Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1CUO3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1CUO3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:29:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS: lookup_mnt() is only used in the core fs routines now
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Mon, 21 Mar 2011 14:28:58 +0000
Message-ID: <20110321142858.19914.74627.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lookup_mnt() is only used in the core fs routines now, so it doesn't need to
be globally declared anymore.  It isn't exported to modules at the moment, so
nothing that can be modularised seems to be using it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/internal.h          |    1 +
 include/linux/dcache.h |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 1719154..8318059 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -64,6 +64,7 @@ extern int copy_mount_string(const void __user *, char **);
 
 extern unsigned int mnt_get_count(struct vfsmount *mnt);
 extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
+extern struct vfsmount *lookup_mnt(struct path *);
 extern void mnt_set_mountpoint(struct vfsmount *, struct dentry *,
 				struct vfsmount *);
 extern void release_mounts(struct list_head *);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1a87760..f2afed4 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -416,7 +416,6 @@ static inline bool d_mountpoint(struct dentry *dentry)
 	return dentry->d_flags & DCACHE_MOUNTED;
 }
 
-extern struct vfsmount *lookup_mnt(struct path *);
 extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
 
 extern int sysctl_vfs_cache_pressure;


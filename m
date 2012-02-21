Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2BUTyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab2BUTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/73] union-mount: Create IS_MNT_UNION() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:11 +0000
Message-ID: <20120221180110.25235.77904.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

IS_MNT_UNION() tests whether a vfsmount is a union.  Note that a
directory in a union mounted file system is not necessarily unioned.
Use IS_DIR_UNIONED() to test that.

Original-author: Jan Blunck <jblunck@suse.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/union.h b/fs/union.h
index e918a04..990dd16 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -51,6 +51,11 @@ struct union_stack {
 	struct path u_dirs[0];
 };
 
+static inline bool IS_MNT_UNION(struct vfsmount *mnt)
+{
+	return mnt->mnt_flags & MNT_UNION;
+}
+
 static inline bool IS_DIR_UNIONED(struct dentry *dentry)
 {
 	return !!dentry->d_union_stack;
@@ -77,6 +82,7 @@ struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
 	return NULL;
 }
 
+static inline bool IS_MNT_UNION(struct vfsmount *mnt) { return false; }
 static inline bool IS_DIR_UNIONED(struct dentry *dentry) { return false; }
 static inline void d_free_unions(struct dentry *dentry) {}
 


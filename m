Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2BUSRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:17:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab2BUSRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/73] union-mount: Add union_find_dir() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:33 +0000
Message-ID: <20120221180033.25235.81897.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

union_find_dir() returns the path of the directory at the specified
layer in a unioned directory.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/union.h b/fs/union.h
index d42dc09..f90d037 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/dcache.h>
 #include <linux/path.h>
+#include <linux/bug.h>
 
 /*
  * WARNING! Confusing terminology alert.
@@ -50,4 +51,20 @@ struct union_stack {
 	struct path u_dirs[0];
 };
 
+static inline
+struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
+{
+	BUG_ON(layer >= dentry->d_sb->s_union_count);
+	return &dentry->d_union_stack->u_dirs[layer];
+}
+
+#else /* CONFIG_UNION_MOUNT */
+
+static inline
+struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
+{
+	BUG();
+	return NULL;
+}
+
 #endif	/* CONFIG_UNION_MOUNT */


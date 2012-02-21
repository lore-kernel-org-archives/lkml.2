Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2BUTyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab2BUTyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/73] VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 21 Feb 2012 17:58:32 +0000
Message-ID: <20120221175832.25235.96909.stgit@warthog.procyon.org.uk>
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

Passing the CL_NO_SLAVE flag to clone_mnt() causes the clone
to fail if the source mnt is a slave.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Ram Pai <linuxram@us.ibm.com>
---

 fs/namespace.c |    3 +++
 fs/pnode.h     |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f92f574..96f43f2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -743,6 +743,9 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	if ((flag & CL_NO_SHARED) && IS_MNT_SHARED(old))
 		return ERR_PTR(-EINVAL);
 
+	if ((flag & CL_NO_SLAVE) && IS_MNT_SLAVE(old))
+		return ERR_PTR(-EINVAL);
+
 	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/pnode.h b/fs/pnode.h
index c7089dd..f7ae149 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -23,6 +23,7 @@
 #define CL_MAKE_SHARED 		0x08
 #define CL_PRIVATE 		0x10
 #define CL_NO_SHARED 		0x20
+#define CL_NO_SLAVE 		0x40
 
 static inline void set_mnt_shared(struct mount *mnt)
 {


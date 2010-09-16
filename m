Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0IPWXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:23:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab0IPWOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:18 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 03/34] VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
Date: Thu, 16 Sep 2010 15:11:54 -0700
Message-Id: <1284675145-4391-4-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing the CL_NO_SLAVE flag to clone_mnt() causes the clone
to fail if the source mnt is a slave.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |    3 +++
 fs/pnode.h     |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index eeb4c22..6956062 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -565,6 +565,9 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 	if ((flag & CL_NO_SHARED) && (IS_MNT_SHARED(old)))
 		return ERR_PTR(-EINVAL);
 
+	if ((flag & CL_NO_SLAVE) && (IS_MNT_SLAVE(old)))
+		return ERR_PTR(-EINVAL);
+
 	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/pnode.h b/fs/pnode.h
index bcb3c47..8920e47 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -23,6 +23,7 @@
 #define CL_MAKE_SHARED 		0x08
 #define CL_PRIVATE 		0x10
 #define CL_NO_SHARED 		0x20
+#define CL_NO_SLAVE 		0x40
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
-- 
1.6.3.3


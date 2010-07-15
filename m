Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab0GOCVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170Ab0GOCRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:17:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/18] xstat: eCryptFS: Return extended attributes [ver #6]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org
Date: Thu, 15 Jul 2010 03:17:15 +0100
Message-ID: <20100715021715.5544.83732.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return extended attributes from the eCryptFS filesystem, dredged up from the
lower filesystem.

Possibly eCryptFS should also set FS_COMPR_FL on its compressed files.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ecryptfs/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 31ef525..41bc407 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -994,8 +994,10 @@ int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct kstat lower_stat;
 	int rc;
 
-	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
-			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
+	lower_stat.query_flags = stat->query_flags;
+	lower_stat.request_mask = stat->request_mask | XSTAT_REQUEST_BLOCKS;
+	rc = vfs_xgetattr(ecryptfs_dentry_to_lower_mnt(dentry),
+			  ecryptfs_dentry_to_lower(dentry), &lower_stat);
 	if (!rc) {
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blocks = lower_stat.blocks;


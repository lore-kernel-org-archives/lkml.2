Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1JWRoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:44:55 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46625 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1JWRow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:44:52 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -V8 10/26] vfs: Make the inode passed to inode_change_ok non-const
Date: Sun, 23 Oct 2011 23:13:39 +0530
Message-Id: <1319391835-5829-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319391835-5829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1319391835-5829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@kernel.org>

We will need to call iop->permission and iop->get_acl from
inode_change_ok() for additional permission checks, and both take a
non-const inode.

Acked-by: J. Bruce Fields <bfields@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/attr.c          |    2 +-
 include/linux/fs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 538e279..f15e9e3 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -26,7 +26,7 @@
  * Should be called as the first thing in ->setattr implementations,
  * possibly after taking additional locks.
  */
-int inode_change_ok(const struct inode *inode, struct iattr *attr)
+int inode_change_ok(struct inode *inode, struct iattr *attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ccece40..724a4f4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2566,7 +2566,7 @@ extern int buffer_migrate_page(struct address_space *,
 #define buffer_migrate_page NULL
 #endif
 
-extern int inode_change_ok(const struct inode *, struct iattr *);
+extern int inode_change_ok(struct inode *, struct iattr *);
 extern int inode_newsize_ok(const struct inode *, loff_t offset);
 extern void setattr_copy(struct inode *inode, const struct iattr *attr);
 
-- 
1.7.5.4


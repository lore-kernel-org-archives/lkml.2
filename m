Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0IXMvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:51:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42517 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0IXMse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:48:34 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
        sandeen@redhat.com, tytso@mit.edu, bfields@citi.umich.edu,
        jlayton@redhat.com
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
        nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -V4 01/11] vfs: Indicate that the permission functions take all the MAY_* flags
Date: Fri, 24 Sep 2010 18:18:04 +0530
Message-Id: <1285332494-12756-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 24896e8..c5920b5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -200,7 +200,7 @@ static int acl_permission_check(struct inode *inode, int mask,
 /**
  * generic_permission  -  check for access rights on a Posix-like filesystem
  * @inode:	inode to check access rights for
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
  * @check_acl:	optional callback to check for Posix ACLs
  *
  * Used to check for read/write/execute permissions on a file.
@@ -242,7 +242,7 @@ int generic_permission(struct inode *inode, int mask,
 /**
  * inode_permission  -  check for access rights to a given inode
  * @inode:	inode to check permission on
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
  *
  * Used to check for read/write/execute permissions on an inode.
  * We use "fsuid" for this, letting us set arbitrary permissions
@@ -288,7 +288,7 @@ int inode_permission(struct inode *inode, int mask)
 /**
  * file_permission  -  check for additional access rights to a given file
  * @file:	file to check access rights for
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
  *
  * Used to check for read/write/execute permissions on an already opened
  * file.
-- 
1.7.0.4


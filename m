Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0JERBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:01:43 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:35269 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0JERBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:01:42 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] fs/9p: Add missing iput in v9fs_vfs_lookup
Date: Tue,  5 Oct 2010 22:31:29 +0530
Message-Id: <1286298090-2422-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we drop inode reference in the error path

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 1ec9075..1ac9229 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1028,7 +1028,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	result = v9fs_fid_add(dentry, fid);
 	if (result < 0)
-		goto error;
+		goto error_iput;
 
 inst_out:
 	if (v9ses->cache)
@@ -1039,6 +1039,8 @@ inst_out:
 	d_add(dentry, inode);
 	return NULL;
 
+error_iput:
+	iput(inode);
 error:
 	p9_client_clunk(fid);
 
-- 
1.7.0.4


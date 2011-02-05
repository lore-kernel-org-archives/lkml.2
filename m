Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1BERrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:21 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51319 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1BERrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:18 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 12/17] fs/9p: We need not writeback dirty pages during close
Date: Sat,  5 Feb 2011 23:16:40 +0530
Message-Id: <1296928005-9529-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_dir.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index b84ebe8..9c2bdda 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -295,7 +295,6 @@ int v9fs_dir_release(struct inode *inode, struct file *filp)
 	P9_DPRINTK(P9_DEBUG_VFS,
 			"v9fs_dir_release: inode: %p filp: %p fid: %d\n",
 			inode, filp, fid ? fid->fid : -1);
-	filemap_write_and_wait(inode->i_mapping);
 	if (fid)
 		p9_client_clunk(fid);
 	return 0;
-- 
1.7.1


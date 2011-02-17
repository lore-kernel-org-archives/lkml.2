Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1BQSDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:03:55 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36079 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab1BQSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:36 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 10/14] fs/9p: Add . and .. dentry revalidation flag
Date: Thu, 17 Feb 2011 23:32:01 +0530
Message-Id: <1297965725-25603-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to revalidate . and .. entries also

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 6e04cf3..ffc8090 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -332,5 +332,5 @@ struct file_system_type v9fs_fs_type = {
 	.mount = v9fs_mount,
 	.kill_sb = v9fs_kill_super,
 	.owner = THIS_MODULE,
-	.fs_flags = FS_RENAME_DOES_D_MOVE,
+	.fs_flags = FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT,
 };
-- 
1.7.1


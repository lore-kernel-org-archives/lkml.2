Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1CPFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:09:28 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49583 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1CPFJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:09:20 -0400
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/9p: Use updated offset for writing
Date: Wed, 16 Mar 2011 10:39:16 +0530
Message-Id: <1300252156-5002-1-git-send-email-mohan@in.ibm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the updated offset given by generic_write_checks. Without this fix,
even if a file is opened in O_APPEND mode, data will be written at current
file position instead of end of file.

Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
---
 fs/9p/vfs_file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 6997eb6..51049cd 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -510,7 +510,7 @@ v9fs_file_write(struct file *filp, const char __user * data,
 
 	return v9fs_file_write_internal(filp->f_path.dentry->d_inode,
 					filp->private_data,
-					data, count, offset, 1);
+					data, count, &origin, 1);
 out:
 	return retval;
 }
-- 
1.7.3.4


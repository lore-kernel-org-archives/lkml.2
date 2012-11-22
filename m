Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab2KVTPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:15:54 -0500
Received: from mga10.intel.com ([192.55.52.92]:38255 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754426Ab2KVTPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:15:47 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: viro@zeniv.linux.org.uk, fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vfs: new super block feature flags attribute
Date: Thu, 22 Nov 2012 14:49:42 +0200
Message-Id: <a88c4edfd91ba518cd1094b94a7a5cd59a003c78.1353588575.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new super block attribute flag s_feature_flags
and SF_IMA_DISABLED flag. This flag will be used by Integrity Measurement
Architecture (IMA). Name suggested by Bruce Fields.

Certain file system types and partitions will never be measured or
appraised by IMA depending on the policy. For example, pseudo file
systems are never measured and appraised. In current implementation
policy will be checked again and again. It happens thousands times
per second. That is absolute waste of CPU and may be battery resources.

IMA will set the SF_IMA_DISABLED flag when file system will not be measured
and appraised and test this flag during subsequent calls to skip policy search.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 include/linux/fs.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..0bef2b2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1321,6 +1321,8 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	unsigned long s_feature_flags;
 };
 
 /* superblock cache pruning functions */
@@ -1746,6 +1748,8 @@ struct super_operations {
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
+#define SF_IMA_DISABLED		0x0001
+
 extern void __mark_inode_dirty(struct inode *, int);
 static inline void mark_inode_dirty(struct inode *inode)
 {
-- 
1.7.10.4


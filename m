Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab1HKEXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 00:23:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51787 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1HKEXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 00:23:06 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 1/2] evm: building without EVM enabled fixes
Date: Thu, 11 Aug 2011 00:22:51 -0400
Message-Id: <1313036572-27122-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Missing 'inline' on evm_inode_setattr() definition.
Introduced by commit 817b54aa45db ("evm: add evm_inode_setattr to prevent
updating an invalid security.evm").

- Missing security_old_inode_init_security() stub function definition.
Caused by commit 9d8f13ba3f48 ("security: new security_inode_init_security
API adds function callback").

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/evm.h      |    2 +-
 include/linux/security.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index db5556d..62deb65 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -45,7 +45,7 @@ static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
 }
 #endif
 
-static int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
+static inline int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	return 0;
 }
diff --git a/include/linux/security.h b/include/linux/security.h
index 1c528b1..f399cf1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2048,6 +2048,13 @@ static inline int security_inode_init_security(struct inode *inode,
 	return -EOPNOTSUPP;
 }
 
+int security_old_inode_init_security(struct inode *inode, struct inode *dir,
+				     const struct qstr *qstr, char **name,
+				     void **value, size_t *len)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int security_inode_create(struct inode *dir,
 					 struct dentry *dentry,
 					 int mode)
-- 
1.7.3.4


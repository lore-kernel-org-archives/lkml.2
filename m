Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0GATIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:08:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57780 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0GATIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:08:19 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] security: move LSM xattrnames to xattr.h
Date: Thu,  1 Jul 2010 15:07:43 -0400
Message-Id: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the security extended attributes names global. Updated to move
the remaining Smack xattrs.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |    3 ---
 include/linux/xattr.h      |   14 ++++++++++++++
 security/selinux/hooks.c   |    3 ---
 security/smack/smack.h     |   10 ----------
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 39e5ff5..90012b9 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -49,9 +49,6 @@ typedef struct __user_cap_data_struct {
 } __user *cap_user_data_t;
 
 
-#define XATTR_CAPS_SUFFIX "capability"
-#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
-
 #define VFS_CAP_REVISION_MASK	0xFF000000
 #define VFS_CAP_REVISION_SHIFT	24
 #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 0cfa1e9..f1e5bde 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -33,6 +33,20 @@
 #define XATTR_USER_PREFIX "user."
 #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
 
+/* Security namespace */
+#define XATTR_SELINUX_SUFFIX "selinux"
+#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
+
+#define XATTR_SMACK_SUFFIX "SMACK64"
+#define XATTR_SMACK_IPIN "SMACK64IPIN"
+#define XATTR_SMACK_IPOUT "SMACK64IPOUT"
+#define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
+#define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
+#define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
+
+#define XATTR_CAPS_SUFFIX "capability"
+#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
+
 struct inode;
 struct dentry;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0f524b7..85338f0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -87,9 +87,6 @@
 #include "netlabel.h"
 #include "audit.h"
 
-#define XATTR_SELINUX_SUFFIX "selinux"
-#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
-
 #define NUM_SEL_MNT_OPTS 5
 
 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
diff --git a/security/smack/smack.h b/security/smack/smack.h
index c6e9aca..43ae747 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -123,16 +123,6 @@ struct smack_known {
 #define SMK_FSHAT	"smackfshat="
 #define SMK_FSROOT	"smackfsroot="
 
-/*
- * xattr names
- */
-#define XATTR_SMACK_SUFFIX	"SMACK64"
-#define XATTR_SMACK_IPIN	"SMACK64IPIN"
-#define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
-#define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
-#define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
-#define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
-
 #define SMACK_CIPSO_OPTION 	"-CIPSO"
 
 /*
-- 
1.6.6.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0DUVul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:50:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58763 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab0DUVuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:50:39 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 02/14] security: move LSM xattrnames to xattr.h
Date: Wed, 21 Apr 2010 17:49:42 -0400
Message-Id: <1271886594-3719-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the security extended attributes names global.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

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
index fb9b7e6..d079bec 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -33,6 +33,16 @@
 #define XATTR_USER_PREFIX "user."
 #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
 
+/* Security namespace */
+#define XATTR_SELINUX_SUFFIX "selinux"
+#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
+
+#define XATTR_SMACK_SUFFIX "SMACK64"
+#define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
+
+#define XATTR_CAPS_SUFFIX "capability"
+#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
+
 struct inode;
 struct dentry;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ebee467..1973abe 100644
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
index c6e9aca..9c773e3 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -126,10 +126,8 @@ struct smack_known {
 /*
  * xattr names
  */
-#define XATTR_SMACK_SUFFIX	"SMACK64"
 #define XATTR_SMACK_IPIN	"SMACK64IPIN"
 #define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
-#define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
 #define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
 #define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
 
-- 
1.6.6.1


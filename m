Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab0KCTpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab0KCTpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:45:17 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] xattr.h: expose string defines to userspace
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, ozan@pardus.org.tr, jmorris@namei.org,
        casey@schaufler-ca.com, sgrubb@redhat.com
Date: Wed, 03 Nov 2010 15:45:05 -0400
Message-ID: <20101103194505.3412.26614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit af4f136056c9 moved the XATTR_CAPS_SUFFIX define from capability.h to
xattr.h.  This makes sense except it was previously exports to userspace
but xattr.h does not export it to userspace.  This patch exports these
headers to userspace to fix the ABI regression.

There is some slight possibility that this will cause problems in other
applications which used these #defines differently (wrongly) and I could JUST
export the capabilities xattr name that we broke.  Does anyonehave an idea how
exposing these headers could cause a problem?

Below is what is being exposed to userspace, included here since it isn't
clear exactly what is going to be made available from the patch.

/* Namespaces */
#define XATTR_OS2_PREFIX "os2."
#define XATTR_OS2_PREFIX_LEN (sizeof (XATTR_OS2_PREFIX) - 1)

#define XATTR_SECURITY_PREFIX   "security."
#define XATTR_SECURITY_PREFIX_LEN (sizeof (XATTR_SECURITY_PREFIX) - 1)

#define XATTR_SYSTEM_PREFIX "system."
#define XATTR_SYSTEM_PREFIX_LEN (sizeof (XATTR_SYSTEM_PREFIX) - 1)

#define XATTR_TRUSTED_PREFIX "trusted."
#define XATTR_TRUSTED_PREFIX_LEN (sizeof (XATTR_TRUSTED_PREFIX) - 1)

#define XATTR_USER_PREFIX "user."
#define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)

/* Security namespace */
#define XATTR_SELINUX_SUFFIX "selinux"
#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX

#define XATTR_SMACK_SUFFIX "SMACK64"
#define XATTR_SMACK_IPIN "SMACK64IPIN"
#define XATTR_SMACK_IPOUT "SMACK64IPOUT"
#define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
#define XATTR_NAME_SMACKIPIN    XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
#define XATTR_NAME_SMACKIPOUT   XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT

#define XATTR_CAPS_SUFFIX "capability"
#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX

Reported-by: Ozan Çağlayan <ozan@pardus.org.tr>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/xattr.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index f1e5bde..d7bb5e0 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -13,10 +13,6 @@
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
 #define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
 
-#ifdef  __KERNEL__
-
-#include <linux/types.h>
-
 /* Namespaces */
 #define XATTR_OS2_PREFIX "os2."
 #define XATTR_OS2_PREFIX_LEN (sizeof (XATTR_OS2_PREFIX) - 1)
@@ -47,6 +43,10 @@
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
+#ifdef  __KERNEL__
+
+#include <linux/types.h>
+
 struct inode;
 struct dentry;
 


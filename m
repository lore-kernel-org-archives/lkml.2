Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2KHSIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:08:40 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:61350 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab2KHSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:08:37 -0500
From: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
To: casey@schaufler-ca.com
Cc: james.l.morris@oracle.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Subject: [PATCH] smack: SMACK_MAGIC to include/uapi/linux/magic.h
Date: Thu,  8 Nov 2012 20:08:14 +0200
Message-Id: <1352398094-1862-1-git-send-email-jarkko.sakkinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMACK_MAGIC moved to a proper place for easy user space access
(i.e. libsmack).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
---
 include/uapi/linux/magic.h |    1 +
 security/smack/smack.h     |    6 +-----
 security/smack/smack_lsm.c |    1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index e15192c..12735ad 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -11,6 +11,7 @@
 #define DEBUGFS_MAGIC          0x64626720
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
+#define SMACK_MAGIC		0x43415d53	/* "SMAC" */
 #define RAMFS_MAGIC		0x858458f6	/* some random number */
 #define TMPFS_MAGIC		0x01021994
 #define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 99b3612..e3e7a4f 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/lsm_audit.h>
+#include <linux/magic.h>
 
 /*
  * Smack labels were limited to 23 characters for a long time.
@@ -149,11 +150,6 @@ struct smack_known {
 #define SMACK_CIPSO_SOCKET	1
 
 /*
- * smackfs magic number
- */
-#define SMACK_MAGIC	0x43415d53 /* "SMAC" */
-
-/*
  * CIPSO defaults.
  */
 #define SMACK_CIPSO_DOI_DEFAULT		3	/* Historical */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 38be92c..6e8fa99 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -32,7 +32,6 @@
 #include <linux/pipe_fs_i.h>
 #include <net/cipso_ipv4.h>
 #include <linux/audit.h>
-#include <linux/magic.h>
 #include <linux/dcache.h>
 #include <linux/personality.h>
 #include <linux/msg.h>
-- 
1.7.10.4


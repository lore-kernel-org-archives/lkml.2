Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1I1BP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:15:56 -0400
Received: from nm30-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.238]:38260 "HELO
	nm30-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752336Ab1I1BPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:15:54 -0400
X-Yahoo-Newman-Id: 472931.25287.bm@omp1047.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: c0A8ZOcVM1nTmtNp6bax.CiSFXsUO2.1aag12_wqaEa2AF.
 .Pi3sfVuIK1i_NMzIJUD7IgbajkB3I_KWdmMDn9uhiQJIPVfXUSZ77nkDhtl
 XuoSCsLcf0k0F_2bNUGScQYlVGn7m72ff9M4HlYYJIn2Jr3fw9dDtVgfIaJq
 XX_lFyE02dzRr.dF8LOomfN1TVimMa.otMHPuuHi7_T520DRrT7oEeXWyXLM
 nfJfKsZB6bqu6o4TNJNTRY8bhkEUSLbtpN8i8KxQe9kpCKq7DJUYZhhksjV5
 wpZTXfbGSBKBWf4iKdYoFRUsUGBO8aLWAZnm0dQlxjB9LfGpUS5Od7.MndQe
 sCSsW6ZbCWpGKNIoFJnMd0q_oauv6Qzff4pkSFERt0ztH2bc4NhcN5ipI3C4
 gRnv66tuJm0p0bB4AAGIE8xJ0K75oS.D7rDcCSsx9adsokkBnmnowsovOHA-
 -
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E82754A.7070906@schaufler-ca.com>
Date: Tue, 27 Sep 2011 18:15:54 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: Clean up comments
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is targeted for the smack-next tree.

There are a number of comments in the Smack code that
are either malformed or include code. This patch cleans
them up.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---

 security/smack/smack.h     |    5 ++---
 security/smack/smack_lsm.c |   10 ++++++++--
 security/smack/smackfs.c   |    7 -------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 174d3be..68c0b51 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -155,7 +155,6 @@ struct smack_known {
 #define SMACK_CIPSO_SOCKET	1
 
 /*
- * smackfs magic number
  * smackfs macic number
  */
 #define SMACK_MAGIC	0x43415d53 /* "SMAC" */
@@ -182,9 +181,9 @@ struct smack_known {
 #define MAY_NOT		0
 
 /*
- * Number of access types used by Smack (rwxa)
+ * Number of access types used by Smack (rwxat)
  */
-#define SMK_NUM_ACCESS_TYPE 4
+#define SMK_NUM_ACCESS_TYPE 5
 
 /*
  * Smack audit data; is empty if CONFIG_AUDIT not set
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2e71c3f..6a82265 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -441,6 +441,12 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
  * BPRM hooks
  */
 
+/**
+ * smack_bprm_set_creds - set creds for exec
+ * @bprm: the exec information
+ *
+ * Returns 0 if it gets a blob, -ENOMEM otherwise
+ */
 static int smack_bprm_set_creds(struct linux_binprm *bprm)
 {
 	struct task_smack *tsp = bprm->cred->security;
@@ -844,7 +850,7 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 	return;
 }
 
-/*
+/**
  * smack_inode_getxattr - Smack check on getxattr
  * @dentry: the object
  * @name: unused
@@ -861,7 +867,7 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ, &ad);
 }
 
-/*
+/**
  * smack_inode_removexattr - Smack check on removexattr
  * @dentry: the object
  * @name: name of the attribute
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 76e520b..54f6e18 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -104,9 +104,6 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
 
 
 #define	SEQ_READ_FINISHED	((loff_t)-1)
-/*
-#define	SEQ_READ_FINISHED	1
-*/
 
 /*
  * Values for parsing cipso rules
@@ -475,10 +472,6 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
-/*
-	return smk_write_load_list(file, buf, count, ppos, &smack_rule_list,
-					&smack_list_lock);
-*/
 	return smk_write_load_list(file, buf, count, ppos, NULL, NULL);
 }
 


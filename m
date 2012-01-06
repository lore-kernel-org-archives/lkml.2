Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2AFWNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 17:13:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38905 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227Ab2AFWNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 17:13:43 -0500
Date: Fri, 6 Jan 2012 14:07:10 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] audit: no leading space in audit_log_d_path prefix
Message-ID: <20120106220710.GA20444@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_log_d_path() injects an additional space before the prefix,
which serves no purpose and doesn't mix well with other audit_log*()
functions that do not sneak extra characters into the log.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/audit.c       |    2 +-
 kernel/auditsc.c     |    4 ++--
 security/lsm_audit.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 09fae26..9149149 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1422,7 +1422,7 @@ void audit_log_d_path(struct audit_buffer *ab, const char *prefix,
 	char *p, *pathname;
 
 	if (prefix)
-		audit_log_format(ab, " %s", prefix);
+		audit_log_format(ab, "%s", prefix);
 
 	/* We will allow 11 spaces for ' (deleted)' to be appended */
 	pathname = kmalloc(PATH_MAX+11, ab->gfp_mask);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 47b7fc1..c9b1af5 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -975,7 +975,7 @@ static void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk
 		while (vma) {
 			if ((vma->vm_flags & VM_EXECUTABLE) &&
 			    vma->vm_file) {
-				audit_log_d_path(ab, "exe=",
+				audit_log_d_path(ab, " exe=",
 						 &vma->vm_file->f_path);
 				break;
 			}
@@ -1489,7 +1489,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			case 0:
 				/* name was specified as a relative path and the
 				 * directory component is the cwd */
-				audit_log_d_path(ab, "name=", &context->pwd);
+				audit_log_d_path(ab, " name=", &context->pwd);
 				break;
 			default:
 				/* log the name's directory component */
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 893af8a..db7bf14 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -231,7 +231,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	case LSM_AUDIT_DATA_PATH: {
 		struct inode *inode;
 
-		audit_log_d_path(ab, "path=", &a->u.path);
+		audit_log_d_path(ab, " path=", &a->u.path);
 
 		inode = a->u.path.dentry->d_inode;
 		if (inode)
@@ -314,7 +314,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 						.dentry = u->dentry,
 						.mnt = u->mnt
 					};
-					audit_log_d_path(ab, "path=", &path);
+					audit_log_d_path(ab, " path=", &path);
 					break;
 				}
 				if (!u->addr)
-- 
1.7.0.4


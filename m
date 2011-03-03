Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1CCC4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:56:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43445 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1CCC4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:56:12 -0500
Date: Wed, 2 Mar 2011 20:56:03 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>, Nathan Lynch <ntl@pobox.com>,
        lkml <linux-kernel@vger.kernel.org>, serge.hallyn@canonical.com
Subject: [PATCH mmotm 1/3] userns: remove unneeded extra argument in
 selinux's task_has_capability
Message-ID: <20110303025603.GA10071@peq.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user_namespace argument is not used by task_has_capability, so get
rid of it.  Note that it was spuriously added by the user namespace
patchset, so we're just cleaning up our own mess.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 security/selinux/hooks.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2011-03-03 01:47:01.113745084 +0000
+++ linux-2.6/security/selinux/hooks.c	2011-03-03 01:47:48.017090039 +0000
@@ -1419,7 +1419,6 @@
 /* Check whether a task is allowed to use a capability. */
 static int task_has_capability(struct task_struct *tsk,
 			       const struct cred *cred,
-			       struct user_namespace *ns,
 			       int cap, int audit)
 {
 	struct common_audit_data ad;
@@ -1856,7 +1855,7 @@
 	if (rc)
 		return rc;
 
-	return task_has_capability(tsk, cred, ns, cap, audit);
+	return task_has_capability(tsk, cred, cap, audit);
 }
 
 static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
@@ -2886,8 +2885,8 @@
 
 	case KDSKBENT:
 	case KDSKBSENT:
-		error = task_has_capability(current, cred, &init_user_ns,
-					CAP_SYS_TTY_CONFIG, SECURITY_CAP_AUDIT);
+		error = task_has_capability(current, cred, CAP_SYS_TTY_CONFIG,
+					SECURITY_CAP_AUDIT);
 		break;
 
 	/* default case assumes that the command will go

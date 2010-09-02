Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0IBPrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:47:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33315 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab0IBPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O6gXZmhOTOp7y+Pcl8qKYiFSQVaHHdj/auwbcxDHzmLJf7KU2NZ892CijKn22n7WIp
         NAlXgzQYjT26KzVpN9msohyW8z417UCHOpoqA6Dq6cxtb0mmrJtlYXl3PvXWtblezqSD
         8sUqOt3d9xzLsY6B/x76XSbDlHkAOhC+nOxX8=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH v2 11/24] ptrace: cleanup arch_ptrace() on m32r
Date: Fri,  3 Sep 2010 00:46:18 +0900
Message-Id: <1283442391-23612-12-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'datap' variable in order to remove duplicated castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/ptrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index 69bbf7a..fc93e8d 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -625,6 +625,7 @@ arch_ptrace(struct task_struct *child, long request,
 	    unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/*
@@ -639,8 +640,7 @@ arch_ptrace(struct task_struct *child, long request,
 	 * read the word at location addr in the USER area.
 	 */
 	case PTRACE_PEEKUSR:
-		ret = ptrace_read_user(child, addr,
-				       (unsigned long __user *)data);
+		ret = ptrace_read_user(child, addr, datap);
 		break;
 
 	/*
@@ -661,11 +661,11 @@ arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)data);
+		ret = ptrace_getregs(child, datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *)data);
+		ret = ptrace_setregs(child, datap);
 		break;
 
 	default:
-- 
1.7.2.2


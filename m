Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750830Ab1AUFAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 00:00:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63684 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab1AUFAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 00:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EaQMoPK4Mmebrn1Gz418zLkP3FCAHzVewRiwxEqhwwXP+VBmbPInz/iSZBTR+rXoEi
         MAs04W0jbRGv0Rcfy+AScN+o6KPTja969Kn+LA2GTR5Mucapgq0F3qzl1mJwCCM44ly6
         3xWPEXhU2TBVCq3MWuCgci4JbgO7/KbQax6AQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] select: remove unused MAX_SELECT_SECONDS
Date: Fri, 21 Jan 2011 13:59:59 +0900
Message-Id: <1295585999-3044-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the leftover from the commit 8ff3e8e85fa6 ("select:
switch select() and poll() over to hrtimers").

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/compat.c |    3 ---
 fs/select.c |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index f6fd0a00e6cc..002595083ae5 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1695,9 +1695,6 @@ int compat_set_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
  * Update: ERESTARTSYS breaks at least the xview clock binary, so
  * I'm trying ERESTARTNOHAND which restart only when you want to.
  */
-#define MAX_SELECT_SECONDS \
-	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
-
 int compat_core_sys_select(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 	struct timespec *end_time)
diff --git a/fs/select.c b/fs/select.c
index e56560d2b08a..d33418fdc858 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -517,9 +517,6 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
  * Update: ERESTARTSYS breaks at least the xview clock binary, so
  * I'm trying ERESTARTNOHAND which restart only when you want to.
  */
-#define MAX_SELECT_SECONDS \
-	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
-
 int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			   fd_set __user *exp, struct timespec *end_time)
 {
-- 
1.7.3.4.600.g982838b0


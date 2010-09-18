Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0IRKW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 06:22:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:42779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab0IRKW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 06:22:56 -0400
Date: Sat, 18 Sep 2010 10:22:03 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        namhyung@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
References: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex: Change 3rd arg of fetch_robust_entry() to unsigned int*
Message-ID: <tip-1dcc41bb037533839753df983d31778b30b67d93@git.kernel.org>
Git-Commit-ID: 1dcc41bb037533839753df983d31778b30b67d93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Sep 2010 10:22:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dcc41bb037533839753df983d31778b30b67d93
Gitweb:     http://git.kernel.org/tip/1dcc41bb037533839753df983d31778b30b67d93
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 14 Sep 2010 21:43:46 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 18 Sep 2010 12:19:21 +0200

futex: Change 3rd arg of fetch_robust_entry() to unsigned int*

Sparse complains:
 kernel/futex.c:2495:59: warning: incorrect type in argument 3 (different signedness)

Make 3rd argument of fetch_robust_entry() 'unsigned int'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c        |    2 +-
 kernel/futex_compat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6a3a5fa..464de27 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2458,7 +2458,7 @@ retry:
  */
 static inline int fetch_robust_entry(struct robust_list __user **entry,
 				     struct robust_list __user * __user *head,
-				     int *pi)
+				     unsigned int *pi)
 {
 	unsigned long uentry;
 
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index d49afb2..06da4df 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -19,7 +19,7 @@
  */
 static inline int
 fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
-		   compat_uptr_t __user *head, int *pi)
+		   compat_uptr_t __user *head, unsigned int *pi)
 {
 	if (get_user(*uentry, head))
 		return -EFAULT;

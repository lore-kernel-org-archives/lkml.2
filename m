Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0INMoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:44:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48642 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab0INMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Lfdt0SXw4gHekZ+VpF9DnGn9q7rVjMh0veZzg7839ESszna3hkxFXGoF4iKCFxSCRe
         zTalQAvaFAD+rH+A0UQoHwiyQo5SmB58eFgucoblMFQ6C4nrZ6g8lFZivDez8aR4myw0
         jcv5bTNhi474dGbKFesEpX+TaFcZa3+Ej28KQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Darren Hart <dvhltc@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] futex: change signature of fetch_robust_entry()
Date: Tue, 14 Sep 2010 21:43:46 +0900
Message-Id: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make 3rd argument of fetch_robust_entry() 'unsigned int' in order to
remove following warnings from sparse:

 kernel/futex.c:2495:59: warning: incorrect type in argument 3 (different signedness)
 kernel/futex.c:2495:59:    expected int *pi
 kernel/futex.c:2495:59:    got unsigned int *<noident>
 kernel/futex.c:2506:67: warning: incorrect type in argument 3 (different signedness)
 kernel/futex.c:2506:67:    expected int *pi
 kernel/futex.c:2506:67:    got unsigned int *<noident>
 kernel/futex.c:2515:69: warning: incorrect type in argument 3 (different signedness)
 kernel/futex.c:2515:69:    expected int *pi
 kernel/futex.c:2515:69:    got unsigned int *<noident>

Since all of its users were using 'unsigned int' already, it could
be changed safely.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
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
-- 
1.7.2.2


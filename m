Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2IFXwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:52:32 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:51246 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751194Ab2IFXwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:52:31 -0400
Message-ID: <1346975548.2410.2.camel@offbook>
Subject: [PATCH] kernel/sys: initialize return codes when  declaring
 variables
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 01:52:28 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivially initialize return codes with default values when
the variable is declared.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 kernel/sys.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 241507f..b3b2ef7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1364,7 +1364,7 @@ SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
 
 SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 {
-	int errno;
+	int errno = -EFAULT;
 	char tmp[__NEW_UTS_LEN];
 
 	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
@@ -1373,7 +1373,6 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
 	down_write(&uts_sem);
-	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
 		struct new_utsname *u = utsname();
 
@@ -1390,7 +1389,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 
 SYSCALL_DEFINE2(gethostname, char __user *, name, int, len)
 {
-	int i, errno;
+	int i, errno = 0;
 	struct new_utsname *u;
 
 	if (len < 0)
@@ -1400,7 +1399,6 @@ SYSCALL_DEFINE2(gethostname, char __user *, name, int, len)
 	i = 1 + strlen(u->nodename);
 	if (i > len)
 		i = len;
-	errno = 0;
 	if (copy_to_user(name, u->nodename, i))
 		errno = -EFAULT;
 	up_read(&uts_sem);
@@ -1415,7 +1413,7 @@ SYSCALL_DEFINE2(gethostname, char __user *, name, int, len)
  */
 SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 {
-	int errno;
+	int errno = -EFAULT;
 	char tmp[__NEW_UTS_LEN];
 
 	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
@@ -1424,7 +1422,6 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 		return -EINVAL;
 
 	down_write(&uts_sem);
-	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
 		struct new_utsname *u = utsname();
 
-- 
1.7.5.4




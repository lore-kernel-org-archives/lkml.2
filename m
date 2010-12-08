Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab0LHHWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:22:12 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:60059 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0LHHWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:22:11 -0500
X-Greylist: delayed 1207 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 02:22:11 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T4rJagqmqQnjKNqw52kL+y3GUY/pscnMOhuxtptt8XxzZwiqs6eKoT+Ny6NHrrYxwq
         NyqKEVtKbUVQD/Yiasfhp1C2Oe38ATihWCtyAUMz/24iI6POu3k2NVRG4p+64o75PAjm
         0Mnl1DbC6yR5lWmd0eEPPk353Sdm8vibEaEJs=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] select: remove unused MAX_SELECT_SECONDS
Date: Wed,  8 Dec 2010 15:53:39 +0900
Message-Id: <1291791219-6500-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the leftover from the commit 8ff3e8e85fa6 ("select:
switch select() and poll() over to hrtimers").

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/compat.c |    3 ---
 fs/select.c |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index eb1740a..4376e07 100644
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
index b7b10aa..3ecb12a 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -515,9 +515,6 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
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
1.7.3.3.398.g0b0cd.dirty


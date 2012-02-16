Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2BPUDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:03:19 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60880 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2BPUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:03:13 -0500
MIME-Version: 1.0
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.org, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, keescook@chromium.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH v8 2/8] seccomp: kill the seccomp_t typedef
Date: Thu, 16 Feb 2012 14:02:23 -0600
Message-Id: <1329422549-16407-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329422549-16407-1-git-send-email-wad@chromium.org>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces the seccomp_t typedef with struct seccomp to match modern
kernel style.

v7: struct seccomp_struct -> struct seccomp
v6: original inclusion in this series.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/sched.h   |    2 +-
 include/linux/seccomp.h |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..c30526f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1418,7 +1418,7 @@ struct task_struct {
 	uid_t loginuid;
 	unsigned int sessionid;
 #endif
-	seccomp_t seccomp;
+	struct seccomp seccomp;
 
 /* Thread group tracking */
    	u32 parent_exec_id;
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index cc7a4e9..d61f27f 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -7,7 +7,9 @@
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
 
-typedef struct { int mode; } seccomp_t;
+struct seccomp {
+	int mode;
+};
 
 extern void __secure_computing(int);
 static inline void secure_computing(int this_syscall)
@@ -19,7 +21,7 @@ static inline void secure_computing(int this_syscall)
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long);
 
-static inline int seccomp_mode(seccomp_t *s)
+static inline int seccomp_mode(struct seccomp *s)
 {
 	return s->mode;
 }
@@ -28,7 +30,7 @@ static inline int seccomp_mode(seccomp_t *s)
 
 #include <linux/errno.h>
 
-typedef struct { } seccomp_t;
+struct seccomp { };
 
 #define secure_computing(x) do { } while (0)
 
@@ -42,7 +44,7 @@ static inline long prctl_set_seccomp(unsigned long arg2)
 	return -EINVAL;
 }
 
-static inline int seccomp_mode(seccomp_t *s)
+static inline int seccomp_mode(struct seccomp *s)
 {
 	return 0;
 }
-- 
1.7.5.4


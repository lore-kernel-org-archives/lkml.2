Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab2CWT1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:27:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46940 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab2CWT1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:27:44 -0400
Date: Fri, 23 Mar 2012 12:08:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        spender@grsecurity.net
Subject: [PATCH v2] futex: mark get_robust_list as deprecated
Message-ID: <20120323190855.GA27213@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203231926000.2542@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notify get_robust_list users that the syscall is going away.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - add note to feature-removal-schedule.txt.
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 kernel/futex.c                             |    2 ++
 kernel/futex_compat.c                      |    2 ++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4bfd982..e3bf119 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -543,3 +543,13 @@ When:	3.5
 Why:	The old kmap_atomic() with two arguments is deprecated, we only
 	keep it for backward compatibility for few cycles and then drop it.
 Who:	Cong Wang <amwang@redhat.com>
+
+----------------------------
+
+What:	get_robust_list syscall
+When:	2013
+Why:	There appear to be no production users of the get_robust_list syscall,
+	and it runs the risk of leaking address locations, allowing the bypass
+	of ASLR. It was only ever intended for debugging, so it should be
+	removed.
+Who:	Kees Cook <keescook@chromium.org>
diff --git a/kernel/futex.c b/kernel/futex.c
index d701be5..e2b0fb9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2449,6 +2449,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+
 	rcu_read_lock();
 
 	ret = -ESRCH;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index a9642d5..83e368b 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -142,6 +142,8 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+
 	rcu_read_lock();
 
 	ret = -ESRCH;
-- 
1.7.0.4


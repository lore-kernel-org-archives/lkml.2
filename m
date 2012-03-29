Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2C2J51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:57:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2C2J5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:57:21 -0400
Date: Thu, 29 Mar 2012 02:56:03 -0700
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-ec0c4274e33c0373e476b73e01995c53128f1257@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        serge.hallyn@canonical.com, a.p.zijlstra@chello.nl,
        dvhart@linux.intel.com, jkosina@suse.cz, rdunlap@xenotime.net,
        ebiederm@xmission.com, dhowells@redhat.com, keescook@chromium.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        serge.hallyn@canonical.com, dvhart@linux.intel.com,
        a.p.zijlstra@chello.nl, rdunlap@xenotime.net, jkosina@suse.cz,
        ebiederm@xmission.com, keescook@chromium.org, dhowells@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20120323190855.GA27213@www.outflux.net>
References: <20120323190855.GA27213@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futex: Mark get_robust_list as deprecated
Git-Commit-ID: ec0c4274e33c0373e476b73e01995c53128f1257
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Mar 2012 02:56:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec0c4274e33c0373e476b73e01995c53128f1257
Gitweb:     http://git.kernel.org/tip/ec0c4274e33c0373e476b73e01995c53128f1257
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri, 23 Mar 2012 12:08:55 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Mar 2012 11:37:17 +0200

futex: Mark get_robust_list as deprecated

Notify get_robust_list users that the syscall is going away.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: kernel-hardening@lists.openwall.com
Cc: spender@grsecurity.net
Link: http://lkml.kernel.org/r/20120323190855.GA27213@www.outflux.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 kernel/futex.c                             |    2 ++
 kernel/futex_compat.c                      |    2 ++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..c1be806 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -529,3 +529,13 @@ When:	3.5
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

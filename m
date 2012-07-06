Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2GFL1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:27:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab2GFL1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:27:31 -0400
Date: Fri, 6 Jul 2012 04:27:15 -0700
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-47fbc518a4b5c9a949f7cab8b14a00d3549bf138@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, jbaron@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <199332c47eef8005d5a5bf1018a80d25929a5746.1340909155.git.jbaron@redhat.com>
References: <199332c47eef8005d5a5bf1018a80d25929a5746.1340909155.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Remove static_branch()
Git-Commit-ID: 47fbc518a4b5c9a949f7cab8b14a00d3549bf138
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:27:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47fbc518a4b5c9a949f7cab8b14a00d3549bf138
Gitweb:     http://git.kernel.org/tip/47fbc518a4b5c9a949f7cab8b14a00d3549bf138
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Thu, 28 Jun 2012 15:05:02 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 10:53:49 +0200

jump label: Remove static_branch()

Remove the obsolete static_branch() interface, since the supported interface
is now static_key_false()/true() - which is used by all in-tree code.

See commit:

  c5905afb0e ("static keys: Introduce 'struct static_key', static_key_true()/false()
  and static_key_slow_[inc|dec]()").

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/199332c47eef8005d5a5bf1018a80d25929a5746.1340909155.git.jbaron@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/jump_label.h |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index c513a40..0976fc4 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -42,8 +42,7 @@
  * allowed.
  *
  * Not initializing the key (static data is initialized to 0s anyway) is the
- * same as using STATIC_KEY_INIT_FALSE and static_key_false() is
- * equivalent with static_branch().
+ * same as using STATIC_KEY_INIT_FALSE.
  *
 */
 
@@ -107,12 +106,6 @@ static __always_inline bool static_key_true(struct static_key *key)
 	return !static_key_false(key);
 }
 
-/* Deprecated. Please use 'static_key_false() instead. */
-static __always_inline bool static_branch(struct static_key *key)
-{
-	return arch_static_branch(key);
-}
-
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
@@ -166,14 +159,6 @@ static __always_inline bool static_key_true(struct static_key *key)
 	return false;
 }
 
-/* Deprecated. Please use 'static_key_false() instead. */
-static __always_inline bool static_branch(struct static_key *key)
-{
-	if (unlikely(atomic_read(&key->enabled)) > 0)
-		return true;
-	return false;
-}
-
 static inline void static_key_slow_inc(struct static_key *key)
 {
 	atomic_inc(&key->enabled);

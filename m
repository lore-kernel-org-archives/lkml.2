Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2F1TGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab2F1TFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:05:08 -0400
Date: Thu, 28 Jun 2012 15:05:02 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        a.p.zijlstra@chello.nl, hpa@zytor.com, linux-kernel@vger.kernel.org
Message-Id: <199332c47eef8005d5a5bf1018a80d25929a5746.1340909155.git.jbaron@redhat.com>
In-Reply-To: <cover.1340909155.git.jbaron@redhat.com>
References: <cover.1340909155.git.jbaron@redhat.com>
Subject: [PATCH 2/2] jump label: remove static_branch()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static_branch(), since interface is now static_key_false()/true().
See commit:

c5905afb0ee6550b42c49213da1c22d67316c194 static keys: Introduce
'struct static_key', static_key_true()/false() and
static_key_slow_[inc|dec]()

Signed-off-by: Jason Baron <jbaron@redhat.com>
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
-- 
1.7.1


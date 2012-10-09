Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2JIDoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:44:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48134 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab2JIDoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:44:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,558,1344182400"; 
   d="scan'208";a="5964969"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] lglock: remove unused DEFINE_LGLOCK_LOCKDEP()
Date: Tue, 9 Oct 2012 11:46:38 +0800
Message-Id: <1349754403-4798-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 11:44:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 11:44:09,
	Serialize complete at 2012/10/09 11:44:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct lglocks use their own lock_key/lock_dep_map which are defined
in struct lglock. DEFINE_LGLOCK_LOCKDEP() is unused now, so we remove it
and save a small piece of memory.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/lglock.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f01e5f6..45eff71 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -36,16 +36,8 @@
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
-
-#define DEFINE_LGLOCK_LOCKDEP(name)					\
- struct lock_class_key name##_lock_key;					\
- struct lockdep_map name##_lock_dep_map;				\
- EXPORT_SYMBOL(name##_lock_dep_map)
-
 #else
 #define LOCKDEP_INIT_MAP(a, b, c, d)
-
-#define DEFINE_LGLOCK_LOCKDEP(name)
 #endif
 
 struct lglock {
@@ -57,7 +49,6 @@ struct lglock {
 };
 
 #define DEFINE_LGLOCK(name)						\
-	DEFINE_LGLOCK_LOCKDEP(name);					\
 	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)			\
 	= __ARCH_SPIN_LOCK_UNLOCKED;					\
 	struct lglock name = { .lock = &name ## _lock }
-- 
1.7.4.4


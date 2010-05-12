Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab0ELVhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:37:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45247 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075Ab0ELVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>
Subject: [PATCH RFC tip/core/rcu 02/23] rcu: add __rcu API for later sparse checking
Date: Wed, 12 May 2010 14:33:21 -0700
Message-Id: <1273700022-16523-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit defines an __rcu API, but provides only vacuous definitions
for it.  This breaks dependencies among most of the subsequent patches,
allowing them to reach mainline asynchronously via whatever trees are
appropriate.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/compiler.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index a5a472b..c1a62c5 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -16,6 +16,7 @@
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 # define __percpu	__attribute__((noderef, address_space(3)))
+# define __rcu
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
@@ -34,6 +35,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __release(x) (void)0
 # define __cond_lock(x,c) (c)
 # define __percpu
+# define __rcu
 #endif
 
 #ifdef __KERNEL__
-- 
1.7.0.6


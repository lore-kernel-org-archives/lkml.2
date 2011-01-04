Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1ADIml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:42:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab1ADImk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:42:40 -0500
Message-ID: <4D22DD95.7050308@cn.fujitsu.com>
Date: Tue, 04 Jan 2011 16:43:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: remove SPARSE_RCU_POINTER
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:42:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:42:20,
	Serialize complete at 2011-01-04 16:42:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As I known, __rcu annotations do not effect the result compiled kernel.

They work only when we use spare("make C=1" or "make C=2"),
So we don't need another new switch for it since we have one
for debugging(use spare or not).

signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 320d6c9..0ab21c2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -16,11 +16,7 @@
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 # define __percpu	__attribute__((noderef, address_space(3)))
-#ifdef CONFIG_SPARSE_RCU_POINTER
 # define __rcu		__attribute__((noderef, address_space(4)))
-#else
-# define __rcu
-#endif
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8be18e5..bf9c5d3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -563,21 +563,6 @@ config PROVE_RCU_REPEATEDLY
 
 	 Say N if you are unsure.
 
-config SPARSE_RCU_POINTER
-	bool "RCU debugging: sparse-based checks for pointer usage"
-	default n
-	help
-	 This feature enables the __rcu sparse annotation for
-	 RCU-protected pointers.  This annotation will cause sparse
-	 to flag any non-RCU used of annotated pointers.  This can be
-	 helpful when debugging RCU usage.  Please note that this feature
-	 is not intended to enforce code cleanliness; it is instead merely
-	 a debugging aid.
-
-	 Say Y to make sparse flag questionable use of RCU-protected pointers
-
-	 Say N if you are unsure.
-
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT

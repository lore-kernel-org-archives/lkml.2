Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938180Ab0CPRsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:48:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938057Ab0CPRrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:47:08 -0400
Date: Tue, 16 Mar 2010 13:46:51 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <8db06ff1a3320235a5795cbe69904d8f63df1b09.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 09/14] syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add COMPAT_SYSCALL_DEFINE#N() macro define common compat syscalls that
are not arch specific. Prepends "compat_sys_" to the syscall name to identify
it.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 14ecfcc..4cbc370 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -230,6 +230,13 @@ struct perf_event_attr;
 #define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, sys32_##name, name, __VA_ARGS__)
 #define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, sys32_##name, name, __VA_ARGS__)
 
+#define COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, compat_sys_##name, name, __VA_ARGS__)
+
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)		\
 	static const char *types_compat_sys_##sname[] = {	\
-- 
1.6.5.1


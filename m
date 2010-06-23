Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0FWKE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:28 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59787 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0FWKEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:20 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 13/40] syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
Date: Wed, 23 Jun 2010 20:02:54 +1000
Message-Id: <1277287401-28571-14-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add COMPAT_SYSCALL_DEFINE#N() macro define common compat syscalls that
are not arch specific. Prepends "compat_sys_" to the syscall name to identify
it.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/syscalls.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d7096ab..a7d1114 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -213,6 +213,13 @@ extern struct trace_event_functions exit_syscall_print_funcs;
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
1.7.1


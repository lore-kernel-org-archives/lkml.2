Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0FWKEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:39 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55566 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0FWKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:32 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 27/40] trace syscalls: Add COMPAT_SYSCALL_DEFINE0 macro
Date: Wed, 23 Jun 2010 20:03:08 +1000
Message-Id: <1277287401-28571-28-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patchs adds the COMPAT_SYSCALL_DEFINE0 macros for compat syscalls
that do not take any arguments.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/syscalls.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a608565..1076ae8 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -220,6 +220,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_METADATAx(syscall, compat_sys_##sname, x, compat_syscall, __VA_ARGS__);\
 	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
 
+#define COMPAT_SYSCALL_DEFINE0(name)					\
+	SYSCALL_METADATA0(compat_sys_##name, name, compat_syscall)	\
+	asmlinkage long compat_sys_##name()
+
 #endif /* CONFIG_COMPAT */
 
 
-- 
1.7.1


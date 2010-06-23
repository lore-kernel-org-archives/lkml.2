Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0FWKKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:10:50 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51559 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab0FWKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:23 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Michal Marek <mmarek@suse.cz>,
       WANG Cong <xiyou.wangcong@gmail.com>, John Kacur <jkacur@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 16/40] tags: recognize compat syscalls
Date: Wed, 23 Jun 2010 20:02:57 +1000
Message-Id: <1277287401-28571-17-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

make tags.sh recognize the new syscall macros:

COMPAT_SYSCALL_DEFINE#N()
ARCH_COMPAT_SYSCALL_DEFINE#N()

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 scripts/tags.sh |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 8509bb5..1c015eb 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -125,7 +125,9 @@ exuberant()
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=-px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
-	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	--regex-c='/^COMPAT_SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/compat_sys_\1/' \
+	--regex-c='/^ARCH_COMPAT_SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys32_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -145,7 +147,9 @@ emacs()
 {
 	all_sources | xargs $1 -a                               \
 	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
-	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'
+	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
+	--regex='/^COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/compat_sys_\1/' \
+	--regex='/^ARCH_COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys32_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
1.7.1


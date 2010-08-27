Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0H0LEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:04:31 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44776 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab0H0LE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:04:27 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 11/15] x86: Add new syscalls for x86_64
Date: Fri, 27 Aug 2010 16:32:58 +0530
Message-Id: <1282906982-26918-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new syscalls to x86_64

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/x86/ia32/ia32entry.S        |   11 +++++++++++
 arch/x86/include/asm/unistd_64.h |   24 ++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index b86feab..7b6c67d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -845,4 +845,15 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad sys_name_to_handle_at
+	.quad compat_sys_open_by_handle_at
+	.quad sys_handle_readlink
+	.quad sys32_handle_stat64
+	.quad sys_handle_link		/* 345 */
+	.quad sys_handle_chown
+	.quad sys_handle_setxattr
+	.quad sys_handle_getxattr
+	.quad sys_handle_listxattr
+	.quad sys_handle_removexattr	/* 350 */
+	.quad compat_sys_handle_utimes
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 363e9b8..09ee835 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,30 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_name_to_handle_at			303
+__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
+#define __NR_open_by_handle_at			304
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+#define __NR_readlink_by_handle			305
+__SYSCALL(__NR_readlink_by_handle, sys_handle_readlink)
+#define __NR_stat_by_handle			306
+__SYSCALL(__NR_stat_by_handle, sys_handle_stat)
+#define __NR_link_by_handle			307
+__SYSCALL(__NR_link_by_handle, sys_handle_link)
+#define __NR_chown_by_handle			308
+__SYSCALL(__NR_chown_by_handle, sys_handle_chown)
+#define __NR_setxattr_by_handle			309
+__SYSCALL(__NR_setxattr_by_handle, sys_handle_setxattr)
+#define __NR_getxattr_by_handle			310
+__SYSCALL(__NR_getxattr_by_handle, sys_handle_getxattr)
+#define __NR_listxattr_by_handle		311
+__SYSCALL(__NR_listxattr_by_handle, sys_handle_listxattr)
+#define __NR_removexattr_by_handle		312
+__SYSCALL(__NR_removexattr_by_handle, sys_handle_removexattr)
+#define __NR_utimes_by_handle			313
+__SYSCALL(__NR_utimes_by_handle, sys_handle_utimes)
+
+
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0H0LET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:04:19 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59542 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0H0LEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:04:16 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 10/15] x86: Add new syscalls for x86_32
Date: Fri, 27 Aug 2010 16:32:57 +0530
Message-Id: <1282906982-26918-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new syscalls to x86_32

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/x86/include/asm/unistd_32.h   |   14 +++++++++++++-
 arch/x86/kernel/syscall_table_32.S |   11 +++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index b766a5e..75c26e7 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,22 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_name_to_handle_at	341
+#define __NR_open_by_handle_at  342
+#define __NR_readlink_by_handle 343
+#define __NR_stat64_by_handle   344
+#define __NR_link_by_handle     345
+#define __NR_chown_by_handle    346
+#define __NR_setxattr_by_handle 347
+#define __NR_getxattr_by_handle 348
+#define __NR_listxattr_by_handle	349
+#define __NR_removexattr_by_handle	350
+#define __NR_utimes_by_handle	351
+
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 341
+#define NR_syscalls 352
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index b35786d..e8721fe 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,14 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long sys_name_to_handle_at
+	.long sys_open_by_handle_at
+	.long sys_handle_readlink
+	.long sys_handle_stat64
+	.long sys_handle_link		/* 345 */
+	.long sys_handle_chown
+	.long sys_handle_setxattr
+	.long sys_handle_getxattr
+	.long sys_handle_listxattr
+	.long sys_handle_removexattr	/* 350 */
+	.long sys_handle_utimes
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0HTBw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:52:28 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40268 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0HTBwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:52:25 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V18 09/13] x86: Add new syscalls for x86_64
Date: Fri, 20 Aug 2010 07:21:33 +0530
Message-Id: <1282269097-26166-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sys_name_to_handle_at and sys_open_by_handle_at syscalls
for x86_64

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/x86/ia32/ia32entry.S        |    2 ++
 arch/x86/include/asm/unistd_64.h |    5 +++++
 fs/compat.c                      |   11 +++++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index b86feab..d93cd0d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -845,4 +845,6 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad sys_name_to_handle_at
+	.quad compat_sys_open_by_handle_at
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 363e9b8..24d8a38 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,11 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_name_to_handle_at			303
+__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
+#define __NR_open_by_handle_at			304
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/fs/compat.c b/fs/compat.c
index 718c706..c4037fd 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -2334,3 +2334,14 @@ asmlinkage long compat_sys_timerfd_gettime(int ufd,
 }
 
 #endif /* CONFIG_TIMERFD */
+
+/*
+ * Exactly like fs/open.c:sys_open_by_handle_at(), except that it
+ * doesn't set the O_LARGEFILE flag.
+ */
+asmlinkage long
+compat_sys_open_by_handle_at(int mountdirfd,
+			     struct file_handle __user *handle, int flags)
+{
+	return do_handle_open(mountdirfd, handle, flags);
+}
-- 
1.7.0.4


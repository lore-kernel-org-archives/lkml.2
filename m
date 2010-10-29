Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804Ab0J2J65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:58:57 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43031 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab0J2J6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:58:53 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V22 10/14] x86: Add new syscalls for x86_64
Date: Fri, 29 Oct 2010 15:27:19 +0530
Message-Id: <1288346243-12211-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new syscalls to x86_64

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/x86/ia32/ia32entry.S        |    5 +++++
 arch/x86/include/asm/unistd_64.h |   10 ++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..4649908 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -851,4 +851,9 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad sys_name_to_handle_at
+	.quad compat_sys_open_by_handle_at
+	.quad sys_handle_readlink
+	.quad sys32_handle_stat64
+	.quad sys_handle_link		/* 345 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 363e9b8..4e13e76 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,16 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
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
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
-- 
1.7.1


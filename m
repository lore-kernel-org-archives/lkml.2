Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2GQRWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:22:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50675 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2GQRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:22:22 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] fs: Build sys_stat64() and friends if __ARCH_WANT_COMPAT_STAT64
Date: Tue, 17 Jul 2012 18:22:02 +0100
Message-Id: <1342545722-31688-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
X-OriginalArrivalTime: 17 Jul 2012 17:23:31.0337 (UTC) FILETIME=[E309D790:01CD6440]
X-MC-Unique: 112071718222002101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q6HHMTNO003460

On AArch64, we want the sys_stat64() and related functions for compat
support but do not need the generic struct stat64, enabled automatically
if __ARCH_WANT_STAT64.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/stat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index b6ff118..6126c5d 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -326,7 +326,7 @@ SYSCALL_DEFINE3(readlink, const char __user *, path, char __user *, buf,
 
 
 /* ---------- LFS-64 ----------- */
-#ifdef __ARCH_WANT_STAT64
+#if defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_COMPAT_STAT64)
 
 #ifndef INIT_STRUCT_STAT64_PADDING
 #  define INIT_STRUCT_STAT64_PADDING(st) memset(&st, 0, sizeof(st))
@@ -415,7 +415,7 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 		return error;
 	return cp_new_stat64(&stat, statbuf);
 }
-#endif /* __ARCH_WANT_STAT64 */
+#endif /* __ARCH_WANT_STAT64 || __ARCH_WANT_COMPAT_STAT64 */
 
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
 void __inode_add_bytes(struct inode *inode, loff_t bytes)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1IRIFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:05:10 -0400
Received: from www17.your-server.de ([213.133.104.17]:43399 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1IRIFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:05:02 -0400
Subject: [PATCH 2/3] ftruncate: off_t is signed
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Sep 2011 20:01:43 +0200
Message-ID: <1316282503.5814.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

truncate() and ftruncate() both have a off_t length argument as input.
make both function use long instead of unsigned long.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 fs/open.c                |    2 +-
 include/linux/syscalls.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f711921..2d607c7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -175,7 +175,7 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
+SYSCALL_DEFINE2(ftruncate, unsigned int, fd, long, length)
 {
 	long ret = do_sys_ftruncate(fd, length, 1);
 	/* avoid REGPARM breakage on x86: */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1ff0ec2..ae81e1f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -398,7 +398,7 @@ asmlinkage long sys_mount(char __user *dev_name, char __user *dir_name,
 asmlinkage long sys_umount(char __user *name, int flags);
 asmlinkage long sys_oldumount(char __user *name);
 asmlinkage long sys_truncate(const char __user *path, long length);
-asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length);
+asmlinkage long sys_ftruncate(unsigned int fd, long length);
 asmlinkage long sys_stat(const char __user *filename,
 			struct __old_kernel_stat __user *statbuf);
 asmlinkage long sys_statfs(const char __user * path,
-- 
1.7.6




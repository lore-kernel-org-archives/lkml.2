Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab0HSDi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:38:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64820 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0HSDh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R7/MoYijk7NmuE9uwYDiK9j5Ypwts5PoP9zOOykLQnR9yVic6Dn8lH8GIsWA9of4Ve
         KEx9yk7DGVHuLMCeqx1qULGL7Qf3TBeVFDk7VvhcmdLCsf/3YyXN/mIYuqIL/i2/AaiS
         5BFJCMDBooiu+627kgkE+c8PvqGZhmXsEt9O4=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] initramfs: add missing __user markup
Date: Thu, 19 Aug 2010 12:37:44 +0900
Message-Id: <1282189064-3904-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_utime(), sys_write() require their arg to be a user pointer but were
missing __user markups. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/initramfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 2aa8c96..993ebab 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -109,7 +109,7 @@ static void __init dir_utime(void)
 	struct dir_entry *de, *tmp;
 	list_for_each_entry_safe(de, tmp, &dir_list, list) {
 		list_del(&de->list);
-		do_utime(de->name, de->mtime);
+		do_utime((char __user __force *)de->name, de->mtime);
 		kfree(de->name);
 		kfree(de);
 	}
@@ -602,7 +602,7 @@ static int __init populate_rootfs(void)
 		fd = sys_open((const char __user __force *) "/initrd.image",
 			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
-			sys_write(fd, (char *)initrd_start,
+			sys_write(fd, (char __user *)initrd_start,
 					initrd_end - initrd_start);
 			sys_close(fd);
 			free_initrd();
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab1EABv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:51:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1EABhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vIwGHm8bso4JVonJpjPjkwLw+YR0iOKLw8FJDG8IHJAa7lTGMr9IQ+1jYSyzLgCnVa
         Z2hxCn7nUr5vR8Sew0tYsk9RzGm0ELRie5ycYPiyvrX/VOD4IglPSeeEOZEcq7GhjvDf
         eqK5ppeu8YXXWH6spP2u2OMJFz3kXYy5/XsnE=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 24/69] sysctl: remove .child from fs/ntfs-debug
Date: Sun,  1 May 2011 03:35:54 +0200
Message-Id: <1304213799-10257-25-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/ntfs/sysctl.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
index 79a8918..da1293d 100644
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -34,7 +34,7 @@
 #include "debug.h"
 
 /* Definition of the ntfs sysctl. */
-static ctl_table ntfs_sysctls[] = {
+static ctl_table ntfs_table[] = {
 	{
 		.procname	= "ntfs-debug",
 		.data		= &debug_msgs,		/* Data pointer and size. */
@@ -45,14 +45,9 @@ static ctl_table ntfs_sysctls[] = {
 	{}
 };
 
-/* Define the parent directory /proc/sys/fs. */
-static ctl_table sysctls_root[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= ntfs_sysctls
-	},
-	{}
+static const __initdata struct ctl_path ntfs_path[] = {
+	{ .procname = "fs" },
+	{ }
 };
 
 /* Storage for the sysctls header. */
@@ -68,7 +63,7 @@ int ntfs_sysctl(int add)
 {
 	if (add) {
 		BUG_ON(sysctls_root_table);
-		sysctls_root_table = register_sysctl_table(sysctls_root);
+		sysctls_root_table = register_sysctl_paths(ntfs_path, ntfs_table);
 		if (!sysctls_root_table)
 			return -ENOMEM;
 	} else {
-- 
1.7.5.134.g1c08b


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069Ab1EABik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1EABh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U4EXwezxt9MZo9ii02ttCxdv3EZz0i3BTM33cBTtvpIiZJJt6N2qJpO2/en4pFMSBU
         2lkU1/65Od+u2lwEN1gfP0fG/1VTofHSOw+shcmWwZNwzLhhrzJvUK8xOyrAlKM5mPYX
         qPWpd6cI9j7aUQYIuXx5HZGMj9BRsf+PDQ+B4=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 21/69] sysctl: remove .child from fscache/
Date: Sun,  1 May 2011 03:35:51 +0200
Message-Id: <1304213799-10257-22-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/fscache/main.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index f9d8567..7f9c055 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-ctl_table fscache_sysctls[] = {
+static ctl_table fscache_table[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,14 +87,11 @@ ctl_table fscache_sysctls[] = {
 	{}
 };
 
-ctl_table fscache_sysctls_root[] = {
-	{
-		.procname	= "fscache",
-		.mode		= 0555,
-		.child		= fscache_sysctls,
-	},
-	{}
+static const __initdata struct ctl_path fscache_path[] = {
+	{ .procname = "fscache" },
+	{ }
 };
+
 #endif
 
 /*
@@ -135,7 +132,7 @@ static int __init fscache_init(void)
 
 #ifdef CONFIG_SYSCTL
 	ret = -ENOMEM;
-	fscache_sysctl_header = register_sysctl_table(fscache_sysctls_root);
+	fscache_sysctl_header = register_sysctl_paths(fscache_path, fscache_table);
 	if (!fscache_sysctl_header)
 		goto error_sysctl;
 #endif
-- 
1.7.5.134.g1c08b


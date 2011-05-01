Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab1EABs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:48:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab1EABhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BWJOYucH3N4XsmnuQGriP8C2ITFEpyrxdFkDw2junR1ph7h0YiLIr5YOBPk7Euk/f1
         1QdypQasJ8tKWqpg1dupzi3U6uQ2Z/eYzQjtRYlp9wBuhPmyZHHCYrikCqbbkU884ScW
         OtTzuqGpz1XYPdhJAt62NBVXMcK/KfcL4vA4M=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 41/69] sysctl: remove .child from s390dbf/
Date: Sun,  1 May 2011 03:36:11 +0200
Message-Id: <1304213799-10257-42-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/s390/kernel/debug.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 5ad6bc0..384f67b 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -902,7 +902,7 @@ static struct ctl_table s390dbf_table[] = {
 		.mode           = S_IRUGO | S_IWUSR,
 		.proc_handler   = proc_dointvec,
 	},
-	 {
+	{
 		.procname       = "debug_active",
 		.data		= &debug_active,
 		.maxlen		= sizeof(int),
@@ -912,13 +912,8 @@ static struct ctl_table s390dbf_table[] = {
 	{ }
 };
 
-static struct ctl_table s390dbf_dir_table[] = {
-	{
-		.procname       = "s390dbf",
-		.maxlen         = 0,
-		.mode           = S_IRUGO | S_IXUGO,
-		.child          = s390dbf_table,
-	},
+static const __initdata struct ctl_path s390dbf_path[] = {
+	{ .procname = "s390dbf" },
 	{ }
 };
 
@@ -1071,7 +1066,7 @@ __init debug_init(void)
 {
 	int rc = 0;
 
-	s390dbf_sysctl_header = register_sysctl_table(s390dbf_dir_table);
+	s390dbf_sysctl_header = register_sysctl_paths(s390dbf_path, s390dbf_table);
 	mutex_lock(&debug_mutex);
 	debug_debugfs_root_entry = debugfs_create_dir(DEBUG_DIR_ROOT,NULL);
 	initialized = 1;
-- 
1.7.5.134.g1c08b


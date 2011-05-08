Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab1EHWlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:41:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab1EHWlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qKy7/B9qSAIRbZi+y+hbCSQMIawzqdI8T0QQuPeoP3gi5DepeokuKDCUJNLRVYT3Ix
         qMYTAkW+MgUqfmXp3OjP/NEbQVoYZ1P965n7T+uiWz4/A6sipjrb8xo6l5OizJ3Hqgbx
         r+wEmR/6ita+2FQlv7cASrOMnNbwWkcbPxEzc=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 041/115] sysctl: remove .child from s390dbf/
Date: Mon,  9 May 2011 00:38:53 +0200
Message-Id: <1304894407-32201-42-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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


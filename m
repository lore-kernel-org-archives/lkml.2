Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1EHWlC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:41:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab1EHWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JME6Yy8aqQSQS7sZQa5bv8y5cojpqf3ywgA3MdLv9yCd9Rymc6E5hVIUrgWc7eFMdg
         +PkmwU4p3nLYgRWgHoSFG+MEa2OpWfrc/wod4RtMZVbnk6QYoYYnxjRjKTUloIYXrZsb
         mjZWGb/EqM0katIAn1K7FA3XrK1B4bnPnMy8Y=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 026/115] sysctl: remove .child from fs/quota/
Date: Mon,  9 May 2011 00:38:38 +0200
Message-Id: <1304894407-32201-27-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/quota/dquot.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index d3c032f..7837944 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2591,22 +2591,11 @@ static ctl_table fs_dqstats_table[] = {
 	{ },
 };
 
-static ctl_table fs_table[] = {
-	{
-		.procname	= "quota",
-		.mode		= 0555,
-		.child		= fs_dqstats_table,
-	},
-	{ },
-};
 
-static ctl_table sys_table[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= fs_table,
-	},
-	{ },
+static const __initdata struct ctl_path quota_path[] = {
+	{ .procname = "fs" },
+	{ .procname = "quota" },
+        { }
 };
 
 static int __init dquot_init(void)
@@ -2616,7 +2605,7 @@ static int __init dquot_init(void)
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
-	register_sysctl_table(sys_table);
+	register_sysctl_paths(quota_path, fs_dqstats_table);
 
 	dquot_cachep = kmem_cache_create("dquot",
 			sizeof(struct dquot), sizeof(unsigned long) * 4,
-- 
1.7.5.134.g1c08b


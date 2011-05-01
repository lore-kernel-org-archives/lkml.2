Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab1EABuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:50:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab1EABhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EjJf9ExkuBTWFyYq67ckPFxLu9NT3R9HKCjEM0ZSIozV+7iQt+g42F5/kcClbKwRi8
         vzthvQKIhPMEtMrWoEN6q7goVQjBidqDrb0kbAEd6aChdMzcf7DdJXrhbmLHMLCGRiDs
         PuG+gFCNspLUEiHQJq8evMPVuu4qPPnc+Pa/s=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 26/69] sysctl: remove .child from fs/quota/
Date: Sun,  1 May 2011 03:35:56 +0200
Message-Id: <1304213799-10257-27-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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


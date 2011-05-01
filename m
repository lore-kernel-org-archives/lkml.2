Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab1EABjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62471 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab1EABhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=INjzsjEB/SXqzTaZlsjrT9cfPobK9pCFJSLqCQagy9/zo4ogBHQGajz+Tn8mrcZaoa
         GZNQe4p3f95EOpvYtGViyPBrk0YK3e/wbc00Ce/MSO7k2dQhNingGkxHSrjcdZ5gqAo0
         uOBqzu9g2XFMLEZ6ShmPx6gdztJh7Ai9FLyYM=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 46/69] sysctl: remove .child from pm/ (frv)
Date: Sun,  1 May 2011 03:36:16 +0200
Message-Id: <1304213799-10257-47-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/frv/kernel/pm.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index 5fa3889..bcef945 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -329,13 +329,9 @@ static struct ctl_table pm_table[] =
 	{ }
 };
 
-static struct ctl_table pm_dir_table[] =
+static const __initdata struct ctl_path pm_path[] =
 {
-	{
-		.procname	= "pm",
-		.mode		= 0555,
-		.child		= pm_table,
-	},
+	{ .procname = "pm" },
 	{ }
 };
 
@@ -344,7 +340,7 @@ static struct ctl_table pm_dir_table[] =
  */
 static int __init pm_init(void)
 {
-	register_sysctl_table(pm_dir_table);
+	register_sysctl_paths(pm_path, pm_table);
 	return 0;
 }
 
-- 
1.7.5.134.g1c08b


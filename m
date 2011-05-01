Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1EABuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:50:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab1EABhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KZdkddXAc90CBO2OCIJ3Q4fv3SPuOrN7S4WRgMJLjdUPq9wAQT1Jq9ZJlYxl5a0Edf
         esTOqO6cgxw0YZs+n2VgmSqyEqAR7V+Df+/g2wbqrH9LOSXjc6SsOaHinzcMZiPJiQJq
         1wYJ0bhLObRHbajTWIlIw+dt9VWTjjzKlGIns=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 29/69] sysctl: remove .child from fs/mqueue
Date: Sun,  1 May 2011 03:35:59 +0200
Message-Id: <1304213799-10257-30-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 ipc/mq_sysctl.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 0c09366..007164b 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -62,7 +62,7 @@ static int msg_max_limit_max = MAX_MSGMAX;
 static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
 static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
 
-static ctl_table mq_sysctls[] = {
+static ctl_table mq_table[] = {
 	{
 		.procname	= "queues_max",
 		.data		= &init_ipc_ns.mq_queues_max,
@@ -91,25 +91,13 @@ static ctl_table mq_sysctls[] = {
 	{}
 };
 
-static ctl_table mq_sysctl_dir[] = {
-	{
-		.procname	= "mqueue",
-		.mode		= 0555,
-		.child		= mq_sysctls,
-	},
-	{}
-};
-
-static ctl_table mq_sysctl_root[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= mq_sysctl_dir,
-	},
-	{}
+static const struct ctl_path mq_path[] = {
+	{ .procname = "fs" },
+	{ .procname = "mqueue" },
+	{ }
 };
 
 struct ctl_table_header *mq_register_sysctl_table(void)
 {
-	return register_sysctl_table(mq_sysctl_root);
+	return register_sysctl_paths(mq_path, mq_table);
 }
-- 
1.7.5.134.g1c08b


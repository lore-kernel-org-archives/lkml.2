Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1EABis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1EABh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ez6gQO/oIOnvRThiU6UHZdnEIt4OUyWCDoOEG46eu4HwlM2+ir8VWEjBH8A0DHfvH3
         jIndoPcswEgdBD2HTPvZFcqEuY1X2SkCvpSBenX0bgPOb5mjuOetaXdrxRVEMX1GJLP8
         qf80Q7yyebaK7XQl7CuuhdzUdHn+7xV4TU6Sg=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 22/69] sysctl: remove .child from fs/nfs/ nlm_table table
Date: Sun,  1 May 2011 03:35:52 +0200
Message-Id: <1304213799-10257-23-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/lockd/svc.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index abfff9d..6ab5932 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -355,7 +355,7 @@ EXPORT_SYMBOL_GPL(lockd_down);
  * Sysctl parameters (same as module parameters, different interface).
  */
 
-static ctl_table nlm_sysctls[] = {
+static ctl_table nlm_table[] = {
 	{
 		.procname	= "nlm_grace_period",
 		.data		= &nlm_grace_period,
@@ -409,21 +409,9 @@ static ctl_table nlm_sysctls[] = {
 	{ }
 };
 
-static ctl_table nlm_sysctl_dir[] = {
-	{
-		.procname	= "nfs",
-		.mode		= 0555,
-		.child		= nlm_sysctls,
-	},
-	{ }
-};
-
-static ctl_table nlm_sysctl_root[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= nlm_sysctl_dir,
-	},
+static const __initdata struct ctl_path nlm_path[] = {
+	{ .procname = "fs" },
+	{ .procname = "nfs" },
 	{ }
 };
 
@@ -504,7 +492,7 @@ module_param(nlm_max_connections, uint, 0644);
 static int __init init_nlm(void)
 {
 #ifdef CONFIG_SYSCTL
-	nlm_sysctl_table = register_sysctl_table(nlm_sysctl_root);
+	nlm_sysctl_table = register_sysctl_paths(nlm_path, nlm_table);
 	return nlm_sysctl_table ? 0 : -ENOMEM;
 #else
 	return 0;
-- 
1.7.5.134.g1c08b


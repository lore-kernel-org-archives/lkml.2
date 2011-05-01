Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808Ab1EABiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab1EABhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JBhshS2/KPHyapEgNuJBg+8m9mQ3j4w3BaUEMAVTh+HS7IffnuNNw2fAduy9vpbFZm
         Ci408XXDlRbjgVcmjwIsJ00xTRNT2Pk5TgICUdGKJ8wohPEd8Za0rL3Gg57rAbE8YfCr
         PN/4dSMIxu91ReuCdT7hFQapik1ln80apt4EU=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 27/69] sysctl: remove .child from fs/xfs/
Date: Sun,  1 May 2011 03:35:57 +0200
Message-Id: <1304213799-10257-28-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/xfs/linux-2.6/xfs_sysctl.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sysctl.c b/fs/xfs/linux-2.6/xfs_sysctl.c
index ee2d2ad..95f803c 100644
--- a/fs/xfs/linux-2.6/xfs_sysctl.c
+++ b/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -218,28 +218,16 @@ static ctl_table xfs_table[] = {
 	{}
 };
 
-static ctl_table xfs_dir_table[] = {
-	{
-		.procname	= "xfs",
-		.mode		= 0555,
-		.child		= xfs_table
-	},
-	{}
-};
-
-static ctl_table xfs_root_table[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= xfs_dir_table
-	},
-	{}
+static const __initdata struct ctl_path xfs_path[] = {
+	{ .procname = "fs" },
+	{ .procname = "xfs" },
+	{ }
 };
 
 int
 xfs_sysctl_register(void)
 {
-	xfs_table_header = register_sysctl_table(xfs_root_table);
+	xfs_table_header = register_sysctl_paths(xfs_path, xfs_table);
 	if (!xfs_table_header)
 		return -ENOMEM;
 	return 0;
-- 
1.7.5.134.g1c08b


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1EHWlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:41:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab1EHWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y2opgShjXvPrFW7ko0dxCcEg9HIxPnx1jNXDcTuEMKfTLGbDImK5RrT8CFr8zhhYy7
         7GBxXcoC9H/t6DReFEOskEs23ugjog/8QiC2yW8rZm3Md7wjzDd+2TiO56ePFIefQ4W7
         uj89Pi2GDjlvPHWkMTOHB0kWnUTGgBnAPDUYQ=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 027/115] sysctl: remove .child from fs/xfs/
Date: Mon,  9 May 2011 00:38:39 +0200
Message-Id: <1304894407-32201-28-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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


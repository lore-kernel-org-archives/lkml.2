Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab1EHXDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:03:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab1EHWkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BWR8OVOeLWwi2ux7EuyMmjAKzU5mbboIRqxzckstDGWBRacRH9dUAdm/lZVBvR2nXg
         VSqhFuMyCfYmseOuDgIxT9K3LLC6DZZgUBXZIPfueSgtE9Vz3QoYpdZFH+EUc/0uVBa7
         LDs1lv+AgQQl4wZPRtGNnv8JEOfQTwOMMM5aU=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 018/115] sysctl: remove .child from dev/scsi
Date: Mon,  9 May 2011 00:38:30 +0200
Message-Id: <1304894407-32201-19-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/scsi/scsi_sysctl.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 2b6b93f..a28707f 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -13,25 +13,19 @@
 
 
 static ctl_table scsi_table[] = {
-	{ .procname	= "logging_level",
-	  .data		= &scsi_logging_level,
-	  .maxlen	= sizeof(scsi_logging_level),
-	  .mode		= 0644,
-	  .proc_handler	= proc_dointvec },
+	{
+		.procname	= "logging_level",
+		.data		= &scsi_logging_level,
+		.maxlen		= sizeof(scsi_logging_level),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-static ctl_table scsi_dir_table[] = {
-	{ .procname	= "scsi",
-	  .mode		= 0555,
-	  .child	= scsi_table },
-	{ }
-};
-
-static ctl_table scsi_root_table[] = {
-	{ .procname	= "dev",
-	  .mode		= 0555,
-	  .child	= scsi_dir_table },
+static const __initdata struct ctl_path scsi_path[] = {
+	{ .procname = "dev" },
+	{ .procname = "scsi" },
 	{ }
 };
 
@@ -39,7 +33,7 @@ static struct ctl_table_header *scsi_table_header;
 
 int __init scsi_init_sysctl(void)
 {
-	scsi_table_header = register_sysctl_table(scsi_root_table);
+	scsi_table_header = register_sysctl_paths(scsi_path, scsi_table);
 	if (!scsi_table_header)
 		return -ENOMEM;
 	return 0;
-- 
1.7.5.134.g1c08b


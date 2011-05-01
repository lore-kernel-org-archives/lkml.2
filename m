Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1EABiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1EABhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qsSQpJrkC2wT943DX3N9fx3VLPCd0N68VsOCpt6qxl1VIXO+wG7lnXPjksq7w3A1S7
         rTwYQqAv2cmyRsqQqoZPz4n9XKsFqGIP2ZpPD0qZpmgxqMS0xBKrfTdSDD/haQfW78kM
         kHEsKWOMVgwlXKkSxgkkVSjPsBzr4Tmzd4IJo=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 14/69] sysctl: remove .child from dev/raid/
Date: Sun,  1 May 2011 03:35:44 +0200
Message-Id: <1304213799-10257-15-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/md/md.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7d6f7f1..3b54374 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -125,26 +125,12 @@ static ctl_table raid_table[] = {
 	{ }
 };
 
-static ctl_table raid_dir_table[] = {
-	{
-		.procname	= "raid",
-		.maxlen		= 0,
-		.mode		= S_IRUGO|S_IXUGO,
-		.child		= raid_table,
-	},
+static const __initdata struct ctl_path raid_path[] = {
+	{ .procname = "dev" },
+	{ .procname = "raid" },
 	{ }
 };
 
-static ctl_table raid_root_table[] = {
-	{
-		.procname	= "dev",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= raid_dir_table,
-	},
-	{  }
-};
-
 static const struct block_device_operations md_fops;
 
 static int start_readonly;
@@ -7380,7 +7366,7 @@ static int __init md_init(void)
 			    md_probe, NULL, NULL);
 
 	register_reboot_notifier(&md_notifier);
-	raid_table_header = register_sysctl_table(raid_root_table);
+	raid_table_header = register_sysctl_paths(raid_path, raid_table);
 
 	md_geninit();
 	return 0;
-- 
1.7.5.134.g1c08b


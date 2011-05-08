Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab1EHWkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:40:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab1EHWkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JT5osxeWqhq75owWCg+A0oz7S3iWRdRDVNPnR7qUegXzjkyK4vllNiBa7xI5DpnMOb
         TtFrTy0DX0cBStScf4bhKy04bg9L0dBzHyCfTOgDrUYdTPzFqa5G3Jgd2688YW+2xRgg
         9n8J8XcXCsoWc7JLCA0e2u670Cm5N9XFlI1VI=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 009/115] sysctl: remove .child from dev/cdrom/
Date: Mon,  9 May 2011 00:38:21 +0200
Message-Id: <1304894407-32201-10-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/cdrom/cdrom.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 514dd8e..9560789 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3654,26 +3654,12 @@ static ctl_table cdrom_table[] = {
 	{ }
 };
 
-static ctl_table cdrom_cdrom_table[] = {
-	{
-		.procname	= "cdrom",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cdrom_table,
-	},
+static const struct ctl_path cdrom_root_path[] = {
+	{ .procname = "dev" },
+	{ .procname = "cdrom" },
 	{ }
 };
 
-/* Make sure that /proc/sys/dev is there */
-static ctl_table cdrom_root_table[] = {
-	{
-		.procname	= "dev",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cdrom_cdrom_table,
-	},
-	{ }
-};
 static struct ctl_table_header *cdrom_sysctl_header;
 
 static void cdrom_sysctl_register(void)
@@ -3683,7 +3669,7 @@ static void cdrom_sysctl_register(void)
 	if (initialized == 1)
 		return;
 
-	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table);
+	cdrom_sysctl_header = register_sysctl_paths(cdrom_root_path, cdrom_table);
 
 	/* set the defaults */
 	cdrom_sysctl_settings.autoclose = autoclose;
-- 
1.7.5.134.g1c08b


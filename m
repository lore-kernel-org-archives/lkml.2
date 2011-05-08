Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1EHWz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:55:57 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47696 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab1EHWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p5GmmETjKRP2lPlwxuORMEkq0kcaGFd46T03AZA0gFsTp7HVjlCNRWjIQLjMlffrWO
         fzEEHzAtzOSM9wL+ONl8x/qq13uD7/eel7a+Z24xmX0Z4a1v+UZzuDsvzojb0LxlfESL
         8G8pikzjm8PTM05umkh5mvI9VibL4JOqW+s3Y=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 048/115] sysctl: remove .child from sh64/unaligned_fixup/
Date: Mon,  9 May 2011 00:39:00 +0200
Message-Id: <1304894407-32201-49-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/sh/kernel/traps_64.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index 6713ca9..8b355b4 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -908,27 +908,16 @@ static ctl_table unaligned_table[] = {
 	{}
 };
 
-static ctl_table unaligned_root[] = {
-	{
-		.procname	= "unaligned_fixup",
-		.mode		= 0555,
-		.child		= unaligned_table
-	},
-	{}
+static const __initdata struct ctl_table unaligned_path[] = {
+	{ .procname = "sh64" },
+	{ .procname = "unaligned_fixup" },
+	{ }
 };
 
-static ctl_table sh64_root[] = {
-	{
-		.procname	= "sh64",
-		.mode		= 0555,
-		.child		= unaligned_root
-	},
-	{}
-};
 static struct ctl_table_header *sysctl_header;
 static int __init init_sysctl(void)
 {
-	sysctl_header = register_sysctl_table(sh64_root);
+	sysctl_header = register_sysctl_paths(unaligned_path, unaligned_table);
 	return 0;
 }
 
-- 
1.7.5.134.g1c08b


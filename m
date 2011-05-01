Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab1EABrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:47:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1EABhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IEEwhbANdRLHe3XfsYBtlCybSq6FUqfYWQOANP37Y++Baf0lJLKfpiuETMH90e9UZW
         Q7tjjeIM8APBPX7a0y76HapaavqPr6zuJMaMzQo9C4FHJEYqltZKN83dSq7/JZdrdyYX
         pbuKBlhweztvLQ7Gdh/GLuVM1vSJ9wID7VEU0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 48/69] sysctl: remove .child from sh64/unaligned_fixup/
Date: Sun,  1 May 2011 03:36:18 +0200
Message-Id: <1304213799-10257-49-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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


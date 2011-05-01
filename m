Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab1EABiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1EABhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s3qeAoTS0ygoXY1IK1ndFPD0sMpsKnQBaQ6nfCLZ9zmTi2w06nyliKLIwarLqcY5ef
         1dxrblAGaq2YC0tM+JXZgNQuv2SOP05OJ2yeFMPkKm9hnr0+Vjo05GU9yitQtJ0nm2ux
         i5NtK8syqJpMoPyToRphI7FQAgazKJRu1wPz8=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 12/69] sysctl: remove .child from dev/rtc/
Date: Sun,  1 May 2011 03:35:42 +0200
Message-Id: <1304213799-10257-13-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/char/rtc.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index dfa8b30..cc752f5 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -291,21 +291,9 @@ static ctl_table rtc_table[] = {
 	{ }
 };
 
-static ctl_table rtc_root[] = {
-	{
-		.procname	= "rtc",
-		.mode		= 0555,
-		.child		= rtc_table,
-	},
-	{ }
-};
-
-static ctl_table dev_root[] = {
-	{
-		.procname	= "dev",
-		.mode		= 0555,
-		.child		= rtc_root,
-	},
+static const __initdata struct ctl_path rtc_path[] = {
+	{ .procname = "dev" },
+	{ .procname = "rtc" },
 	{ }
 };
 
@@ -313,13 +301,13 @@ static struct ctl_table_header *sysctl_header;
 
 static int __init init_sysctl(void)
 {
-    sysctl_header = register_sysctl_table(dev_root);
-    return 0;
+	sysctl_header = register_sysctl_paths(rtc_path, rtc_table);
+	return 0;
 }
 
 static void __exit cleanup_sysctl(void)
 {
-    unregister_sysctl_table(sysctl_header);
+	unregister_sysctl_table(sysctl_header);
 }
 
 /*
-- 
1.7.5.134.g1c08b


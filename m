Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1EHXEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:04:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab1EHWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Eo2KeSpV7GhERAwTTkx5f08no+LkU6SHBG0Lamd0ygs9MDV233FguheJ/hAGzjVM1+
         SYxKFcsjCS/zjH7wuRfu5t4pEKx0fznTAh5kenCESh4YB0kH0Xquru3lBHpbHR6TS87Z
         Nf86Gvy31JRTmSPRtVNFOAbPuCcuJnguWfRrY=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 012/115] sysctl: remove .child from dev/rtc/
Date: Mon,  9 May 2011 00:38:24 +0200
Message-Id: <1304894407-32201-13-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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


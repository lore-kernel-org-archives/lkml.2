Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1EHW4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:56:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab1EHWlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s2sZgJGiYYHvkN0mos41baaaNG2HxS8GmBHHqeToPiLFBTDHPcHka/l+IGjrOHfrvU
         FLG1DpGRYMfMQtBKOELJTgbec/qetjEiTl/ouk1ejqexdvpRRv2dPgzL9HEcbb2x3OEj
         M3Wn0y56UHfqtVeWBDCy/4ojbkeHQP1LECtoo=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 047/115] sysctl: remove .child from frv/
Date: Mon,  9 May 2011 00:38:59 +0200
Message-Id: <1304894407-32201-48-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/frv/kernel/sysctl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/frv/kernel/sysctl.c b/arch/frv/kernel/sysctl.c
index 6c155d6..e5c20a2 100644
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -199,14 +199,10 @@ static struct ctl_table frv_table[] =
  * Use a temporary sysctl number. Horrid, but will be cleaned up in 2.6
  * when all the PM interfaces exist nicely.
  */
-static struct ctl_table frv_dir_table[] =
+static const __initdata struct ctl_path frv_path[] =
 {
-	{
-		.procname	= "frv",
-		.mode 		= 0555,
-		.child		= frv_table
-	},
-	{}
+	{ .procname = "frv" },
+	{ }
 };
 
 /*
@@ -214,7 +210,7 @@ static struct ctl_table frv_dir_table[] =
  */
 static int __init frv_sysctl_init(void)
 {
-	register_sysctl_table(frv_dir_table);
+	register_sysctl_paths(frv_path, frv_table);
 	return 0;
 }
 
-- 
1.7.5.134.g1c08b


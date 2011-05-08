Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1EHW5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:57:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab1EHWlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mINw8kpWtzyIe2lvt1mGffTliafb10APmctJLy7NsU80FijPMhPw3ZIE/YThiyM5im
         a+bWLe15C+bmUZQcX4LENBGNCFDL2BFitgvIyFiLkfHX8TrFm/JdHxpBrc6+qCLypmCf
         n6zwYoXDPVsunJ06Eczg0ut3yGtemqyUofdSs=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 044/115] sysctl: remove .child from kernel/ (ia64/kdump)
Date: Mon,  9 May 2011 00:38:56 +0200
Message-Id: <1304894407-32201-45-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/ia64/kernel/crash.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index b942f40..e54aea5 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -255,17 +255,14 @@ static ctl_table kdump_ctl_table[] = {
 	{ }
 };
 
-static ctl_table sys_table[] = {
-	{
-	  .procname = "kernel",
-	  .mode = 0555,
-	  .child = kdump_ctl_table,
-	},
+static const __initdata struct ctl_path kdump_path[] = {
+	{ .procname = "kernel" },
 	{ }
 };
+
 #endif
 
-static int
+static __init int
 machine_crash_setup(void)
 {
 	/* be notified before default_monarch_init_process */
@@ -277,7 +274,7 @@ machine_crash_setup(void)
 	if((ret = register_die_notifier(&kdump_init_notifier_nb)) != 0)
 		return ret;
 #ifdef CONFIG_SYSCTL
-	register_sysctl_table(sys_table);
+	register_sysctl_paths(kdump_path, kdump_ctl_table);
 #endif
 	return 0;
 }
-- 
1.7.5.134.g1c08b


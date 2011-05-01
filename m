Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab1EABrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:47:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab1EABhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eSH4QKeje1PKzHu/3CdzgsMHu3gpzsaEVMM70vb0Om2N57s66FG1hsJm/JOt5bMNm7
         kTLs3fuKk/2d5T1S5WVRqDbMeFzFtQ4ocGnNZ5VhwRo6CsukmG888JZgllmVB09HjfcT
         GT8w2spS+DxEymQUaJw8v4wDXACbsIdPbnT+s=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 44/69] sysctl: remove .child from kernel/ (ia64/kdump)
Date: Sun,  1 May 2011 03:36:14 +0200
Message-Id: <1304213799-10257-45-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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


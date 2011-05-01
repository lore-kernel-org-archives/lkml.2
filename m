Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab1EABht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:37:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1EABhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Mzh0jzQ43BLgTZf8+Nzl5c7AN44s/F3WI7nDyid9AKBIRYMDPEuz2VkFQ1kk59tXUV
         n8or7WgTWCuQainG74ZsYTV7vynbymwtnl+fnjpiO7mfvVcnKebsa0YecHSiPjpP4bWW
         AEzIQyOISogVV5DF1AkKLYhVBQ2bzly/slWwY=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 06/69] sysctl: remove .child from kernel/vsyscall64 (x86)
Date: Sun,  1 May 2011 03:35:36 +0200
Message-Id: <1304213799-10257-7-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/x86/kernel/vsyscall_64.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index dcbb28c..7d8b83d 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -234,18 +234,21 @@ static long __vsyscall(3) venosys_1(void)
 }
 
 #ifdef CONFIG_SYSCTL
-static ctl_table kernel_table2[] = {
-	{ .procname = "vsyscall64",
-	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
-	  .mode = 0644,
-	  .proc_handler = proc_dointvec },
-	{}
+static ctl_table vsyscall64_table[] = {
+	{
+		.procname = "vsyscall64",
+		.data     = &vsyscall_gtod_data.sysctl_enabled,
+		.maxlen   = sizeof(int),
+		.mode     = 0644,
+		.proc_handler = proc_dointvec,
+	},
+	{ }
 };
 
-static ctl_table kernel_root_table2[] = {
-	{ .procname = "kernel", .mode = 0555,
-	  .child = kernel_table2 },
-	{}
+
+static struct ctl_path kernel_root_path[] = {
+	{ .procname = "kernel" },
+	{ }
 };
 #endif
 
@@ -303,7 +306,7 @@ static int __init vsyscall_init(void)
 	BUG_ON((VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE)));
 	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
 #ifdef CONFIG_SYSCTL
-	register_sysctl_table(kernel_root_table2);
+	register_sysctl_paths(kernel_root_path, vsyscall64_table);
 #endif
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
-- 
1.7.5.134.g1c08b


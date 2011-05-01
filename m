Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab1EABhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:37:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab1EABhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QpUrgxmnZyU86xRjcKyg/CjxjWpvhy126ANfLENG85RxhV/Tu63Yd4PNa+YIvEA9/P
         kzjD5P5SLFZDBz5zBtOC8GkJt6q9LxCurofjm1DthP8MwRxiYqAtq6F+2ZwSdZpLJuPR
         uFZrbr0yVhdWX6cCARcRaU/GBtbzWTSx6Qf6c=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 07/69] sysctl: remove .child from abi/vsyscall32 (x86)
Date: Sun,  1 May 2011 03:35:37 +0200
Message-Id: <1304213799-10257-8-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/x86/vdso/vdso32-setup.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 468d591..e6ef3b4 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -380,7 +380,7 @@ subsys_initcall(sysenter_setup);
 /* Register vsyscall32 into the ABI table */
 #include <linux/sysctl.h>
 
-static ctl_table abi_table2[] = {
+static ctl_table abi_table[] = {
 	{
 		.procname	= "vsyscall32",
 		.data		= &sysctl_vsyscall32,
@@ -391,18 +391,14 @@ static ctl_table abi_table2[] = {
 	{}
 };
 
-static ctl_table abi_root_table2[] = {
-	{
-		.procname = "abi",
-		.mode = 0555,
-		.child = abi_table2
-	},
-	{}
+static const struct ctl_path abi_root_path[] = {
+	{ .procname = "abi" },
+	{ }
 };
 
 static __init int ia32_binfmt_init(void)
 {
-	register_sysctl_table(abi_root_table2);
+	register_sysctl_paths(abi_root_path, abi_table);
 	return 0;
 }
 __initcall(ia32_binfmt_init);
-- 
1.7.5.134.g1c08b


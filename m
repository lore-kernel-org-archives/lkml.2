Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1EHXGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:06:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1EHWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nkNROJQoTtqJaC5XqsF96WHf51JVctu7aNX5Y3poHQO4PKfYyBie2JzT8VpCzUTNDy
         F6vnS8borS9THV0797AVGmrpHmHiA/spXykFMhNSM61qdqc7lk8Xfa4M+egETsUqfynk
         6rzYXi5YqxtuAXPItAYsB/EwNilvLDBeWrNwU=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 007/115] sysctl: remove .child from abi/vsyscall32 (x86)
Date: Mon,  9 May 2011 00:38:19 +0200
Message-Id: <1304894407-32201-8-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab1EHW6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:58:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab1EHWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EQeY32bGoIOMMfR4xk1gjTMyb2kiwpXW6v/7XP0kY3qPjP21ThzqYYEJaDBNo28q1y
         N2x6yRi+vefZMcbKDib3zzG29Iy+OSppoCktBbv5pHBDGPjj734dAzN3mkBKxbUEKrob
         NjB0vkOssrbpkTKJ8j5M5osJY5OZ33PgI0OEA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 037/115] sysctl: remove .child from bus/isa/ (arm)
Date: Mon,  9 May 2011 00:38:49 +0200
Message-Id: <1304894407-32201-38-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/arm/kernel/isa.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
index 3464859..0236609 100644
--- a/arch/arm/kernel/isa.c
+++ b/arch/arm/kernel/isa.c
@@ -20,44 +20,37 @@
 
 static unsigned int isa_membase, isa_portbase, isa_portshift;
 
-static ctl_table ctl_isa_vars[4] = {
+static ctl_table isa_table[] = {
 	{
 		.procname	= "membase",
 		.data		= &isa_membase, 
 		.maxlen		= sizeof(isa_membase),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
-	}, {
+	},
+	{
 		.procname	= "portbase",
 		.data		= &isa_portbase, 
 		.maxlen		= sizeof(isa_portbase),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
-	}, {
+	},
+	{
 		.procname	= "portshift",
 		.data		= &isa_portshift, 
 		.maxlen		= sizeof(isa_portshift),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
-	}, {}
+	},
+	{ }
 };
 
 static struct ctl_table_header *isa_sysctl_header;
 
-static ctl_table ctl_isa[2] = {
-	{
-		.procname	= "isa",
-		.mode		= 0555,
-		.child		= ctl_isa_vars,
-	}, {}
-};
-
-static ctl_table ctl_bus[2] = {
-	{
-		.procname	= "bus",
-		.mode		= 0555,
-		.child		= ctl_isa,
-	}, {}
+static const __initdata struct ctl_path isa_path[] = {
+	{ .procname = "bus" },
+	{ .procname = "isa" },
+	{  }
 };
 
 void __init
@@ -66,5 +59,5 @@ register_isa_ports(unsigned int membase, unsigned int portbase, unsigned int por
 	isa_membase = membase;
 	isa_portbase = portbase;
 	isa_portshift = portshift;
-	isa_sysctl_header = register_sysctl_table(ctl_bus);
+	isa_sysctl_header = register_sysctl_paths(isa_path, isa_table);
 }
-- 
1.7.5.134.g1c08b


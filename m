Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab1EABs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:48:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab1EABhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h4pZ913153hrQVcM5zWvQHQJLGP+gQBo9UvrWM3Y13g3E9FBbEIl58Of4fjDGOndEG
         zbtkcmwTeXJkHSnJzxtHwRpsFkm835wvbb/XIxlB9Gz6fgEQpofBzxppaHvV+YfTUemZ
         dtsSOtUq2dQ4N5FArF7nOQCdo8Kqmq4VHghWI=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 37/69] sysctl: remove .child from bus/isa/ (arm)
Date: Sun,  1 May 2011 03:36:07 +0200
Message-Id: <1304213799-10257-38-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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


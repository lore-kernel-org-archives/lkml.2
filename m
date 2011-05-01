Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057Ab1EABjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1EABhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M2iBnzI7yHsqraudOJPMtBjw5r21QHej31HzHiLXrL2uj/069FM7H2EzwK8zfLKHed
         Gk6uLRPiwpioOmu/dw9Gyv+H7Ntu1pBQuNS7nAlcM5k7ZlwrA3hm23+z1IBbbtL4DHh3
         ORNkTK9YnV5mBFJBwsfeTb+B4wDzmzUQb6suQ=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 38/69] sysctl: remove .child from reboot/warm (arm)
Date: Sun,  1 May 2011 03:36:08 +0200
Message-Id: <1304213799-10257-39-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/arm/mach-bcmring/arch.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
index 73eb066..33c10fd 100644
--- a/arch/arm/mach-bcmring/arch.c
+++ b/arch/arm/mach-bcmring/arch.c
@@ -55,20 +55,18 @@ static struct ctl_table_header *bcmring_sysctl_header;
 
 static struct ctl_table bcmring_sysctl_warm_reboot[] = {
 	{
-	 .procname = "warm",
-	 .data = &bcmring_arch_warm_reboot,
-	 .maxlen = sizeof(int),
-	 .mode = 0644,
-	 .proc_handler = proc_dointvec},
-	{}
+		.procname = "warm",
+		.data     = &bcmring_arch_warm_reboot,
+		.maxlen   = sizeof(int),
+		.mode     = 0644,
+		.proc_handler = proc_dointvec,
+	},
+	{ }
 };
 
-static struct ctl_table bcmring_sysctl_reboot[] = {
-	{
-	 .procname = "reboot",
-	 .mode = 0555,
-	 .child = bcmring_sysctl_warm_reboot},
-	{}
+static const __initdata struct ctl_path bcmring_sysctl_path[] = {
+	{ .procname = "reboot" },
+	{ }
 };
 
 static struct resource nand_resource[] = {
@@ -117,7 +115,8 @@ static struct platform_device *devices[] __initdata = {
 static void __init bcmring_init_machine(void)
 {
 
-	bcmring_sysctl_header = register_sysctl_table(bcmring_sysctl_reboot);
+	bcmring_sysctl_header = register_sysctl_paths(bcmring_sysctl_path,
+						      bcmring_sysctl_warm_reboot);
 
 	/* Enable spread spectrum */
 	chipcHw_enableSpreadSpectrum();
-- 
1.7.5.134.g1c08b


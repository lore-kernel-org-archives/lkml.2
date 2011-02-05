Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1BEOVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1BEOVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vFLRUB2Z5KFUIK2Yn9m0EzHvxB4J+SEqBoLJb5bkYaP54cnr5k/fMlvmehrAiTt2sV
         9fmDBrahAl5BshxkMwC7dXJSvMAEQZrFR2T2CuS7IxRv8SnG1Cr04xzb+77JHV64pe/2
         xOzUw8lxE9QnUk6y0dRb/aMNbOYYKaDAoNRbA=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 15/52] kstrtox: convert drivers/clocksource/
Date: Sat,  5 Feb 2011 16:20:18 +0200
Message-Id: <1296915654-7458-15-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/clocksource/acpi_pm.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index effe797..79643d5 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -233,15 +233,13 @@ fs_initcall(init_acpi_pm_clocksource);
  */
 static int __init parse_pmtmr(char *arg)
 {
-	unsigned long base;
+	u32 base;
+	int rv;
 
-	if (strict_strtoul(arg, 16, &base))
-		return -EINVAL;
-#ifdef CONFIG_X86_64
-	if (base > UINT_MAX)
-		return -ERANGE;
-#endif
-	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04lx\n",
+	rv = kstrtou32(arg, 16, &base);
+	if (rv < 0)
+		return rv;
+	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04x\n",
 	       pmtmr_ioport, base);
 	pmtmr_ioport = base;
 
-- 
1.7.3.4


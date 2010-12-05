Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0LERu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab0LERuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NNAZ/3d9PeslUZuQcwoPExXTmSPudbw8255YKW3zg4AeKJCQP2PYX3C07OgJTqBNvs
         BPxO6gaQHwRPyq5LQ1YXXz/v7w3cCfYO3OLdVmUXxznNurQyKQ79nbfUf7sAHrWb0OsH
         9luawdswzO87sgReIz12tnMiUNszRcdAlEkU4=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 17/45] kstrtox: convert drivers/clocksource/
Date: Sun,  5 Dec 2010 19:49:14 +0200
Message-Id: <1291571382-2719-17-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/clocksource/acpi_pm.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index cfb0f52..2e77b1d 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -229,15 +229,13 @@ fs_initcall(init_acpi_pm_clocksource);
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
1.7.2.2


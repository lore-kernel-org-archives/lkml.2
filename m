Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1GGArN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:47:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1GGArL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:47:11 -0400
Date: Thu, 7 Jul 2011 00:47:05 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-7a0d4fcf6d4b80b30503fd2701eeef1883e11404@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1309019658-1712-3-git-send-email-dsd@laptop.org>
References: <1309019658-1712-3-git-send-email-dsd@laptop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Move CS5536-related constants to cs5535.h
Git-Commit-ID: 7a0d4fcf6d4b80b30503fd2701eeef1883e11404
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Jul 2011 00:47:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a0d4fcf6d4b80b30503fd2701eeef1883e11404
Gitweb:     http://git.kernel.org/tip/7a0d4fcf6d4b80b30503fd2701eeef1883e11404
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Sat, 25 Jun 2011 17:34:09 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Jul 2011 14:44:23 -0700

x86, olpc: Move CS5536-related constants to cs5535.h

Move these definitions into the relevant header file.
This was requested in the review of the upcoming XO-1 suspend/resume code.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/1309019658-1712-3-git-send-email-dsd@laptop.org
Acked-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/olpc/olpc-xo1.c |   26 ++++++++------------------
 include/linux/cs5535.h            |   21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index ab81fb2..a63e948 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -12,6 +12,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/cs5535.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -22,17 +23,6 @@
 
 #define DRV_NAME "olpc-xo1"
 
-/* PMC registers (PMS block) */
-#define PM_SCLK		0x10
-#define PM_IN_SLPCTL	0x20
-#define PM_WKXD		0x34
-#define PM_WKD		0x30
-#define PM_SSC		0x54
-
-/* PM registers (ACPI block) */
-#define PM1_CNT		0x08
-#define PM_GPE0_STS	0x18
-
 static unsigned long acpi_base;
 static unsigned long pms_base;
 
@@ -41,17 +31,17 @@ static void xo1_power_off(void)
 	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
 
 	/* Enable all of these controls with 0 delay */
-	outl(0x40000000, pms_base + PM_SCLK);
-	outl(0x40000000, pms_base + PM_IN_SLPCTL);
-	outl(0x40000000, pms_base + PM_WKXD);
-	outl(0x40000000, pms_base + PM_WKD);
+	outl(0x40000000, pms_base + CS5536_PM_SCLK);
+	outl(0x40000000, pms_base + CS5536_PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + CS5536_PM_WKXD);
+	outl(0x40000000, pms_base + CS5536_PM_WKD);
 
 	/* Clear status bits (possibly unnecessary) */
-	outl(0x0002ffff, pms_base  + PM_SSC);
-	outl(0xffffffff, acpi_base + PM_GPE0_STS);
+	outl(0x0002ffff, pms_base  + CS5536_PM_SSC);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
 
 	/* Write SLP_EN bit to start the machinery */
-	outl(0x00002000, acpi_base + PM1_CNT);
+	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
 }
 
 static int __devinit olpc_xo1_probe(struct platform_device *pdev)
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 6fe2114..e46b8b0 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -49,6 +49,27 @@
 #define LBAR_ACPI_SIZE		0x40
 #define LBAR_PMS_SIZE		0x80
 
+/*
+ * PMC registers (PMS block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM_SCLK		0x10
+#define CS5536_PM_IN_SLPCTL	0x20
+#define CS5536_PM_WKXD		0x34
+#define CS5536_PM_WKD		0x30
+#define CS5536_PM_SSC		0x54
+
+/*
+ * PM registers (ACPI block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM1_STS		0x00
+#define CS5536_PM1_EN		0x02
+#define CS5536_PM1_CNT		0x08
+#define CS5536_PM_GPE0_STS	0x18
+
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
 #define VSA_VRC_DATA		0xAC1E

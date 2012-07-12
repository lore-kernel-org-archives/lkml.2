Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108Ab2GLKXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:23:51 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2GLKXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:23:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Drake <dsd@laptop.org>
Subject: [PATCH] olpc-xo15-sci: Use struct dev_pm_ops for power management
Date: Thu, 12 Jul 2012 12:29:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207121229.24872.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the OLPC XO15 SCI driver define its resume callback through
a struct dev_pm_ops object rather than by using a legacy PM hook
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

This patch was missing from my patchset converting ACPI do the PM handling
based on struct dev_pm_ops.

If there are no objections, I'll add it to the pm-acpi branch of the
linux-pm.git tree so that it goes in along with the other changes in that
area.

Thanks,
Rafael

---
 arch/x86/platform/olpc/olpc-xo15-sci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/arch/x86/platform/olpc/olpc-xo15-sci.c
===================================================================
--- linux.orig/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ linux/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -203,7 +203,7 @@ static int xo15_sci_remove(struct acpi_d
 	return 0;
 }
 
-static int xo15_sci_resume(struct acpi_device *device)
+static int xo15_sci_resume(struct device *dev)
 {
 	/* Enable all EC events */
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
@@ -215,6 +215,8 @@ static int xo15_sci_resume(struct acpi_d
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(xo15_sci_pm, NULL, xo15_sci_resume);
+
 static const struct acpi_device_id xo15_sci_device_ids[] = {
 	{"XO15EC", 0},
 	{"", 0},
@@ -227,8 +229,8 @@ static struct acpi_driver xo15_sci_drv =
 	.ops = {
 		.add = xo15_sci_add,
 		.remove = xo15_sci_remove,
-		.resume = xo15_sci_resume,
 	},
+	.drv.pm = &xo15_sci_pm,
 };
 
 static int __init xo15_sci_init(void)

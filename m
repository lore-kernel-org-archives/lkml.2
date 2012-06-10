Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2FJLWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:22:39 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48325 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756387Ab2FJLWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:22:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKKA1E9bdWOb/2dsb2JhbABFtFqBB4IYAQEFeRAgMTwbBxKID7dPkRADlR6Pe4Ji
X-IronPort-AV: E=Sophos;i="4.77,384,1336341600"; 
   d="scan'208";a="918717975"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, teddy.wang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 2/3] staging: sm7xx: update comments and clarify supported chips
Date: Sun, 10 Jun 2012 13:12:23 +0200
Message-Id: <1339326744-17507-3-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339326744-17507-1-git-send-email-jmunhoz@igalia.com>
References: <1339326744-17507-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch updates/adds comments in order to clarify devices and Lynx
families supported for this driver.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/Kconfig  |    9 +++++++--
 drivers/staging/sm7xx/smtcfb.c |   10 +++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/sm7xx/Kconfig b/drivers/staging/sm7xx/Kconfig
index 315102c..323964f 100644
--- a/drivers/staging/sm7xx/Kconfig
+++ b/drivers/staging/sm7xx/Kconfig
@@ -1,8 +1,13 @@
 config FB_SM7XX
-	tristate "Silicon Motion SM7XX Frame Buffer Support"
+	tristate "Silicon Motion SM7XX framebuffer support"
 	depends on FB
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	help
-	  Frame Buffer driver for the Silicon Motion SM7XX serial graphic card.
+	  Frame buffer driver for the Silicon Motion SM710, SM712, SM721
+	  and SM722 chips.
+
+	  This driver is also available as a module. The module will be
+	  called sm7xx. If you want to compile it as a module, say M
+	  here and read <file:Documentation/kbuild/modules.txt>.
diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 2c172d6..e7028a3 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -15,6 +15,7 @@
  * License. See the file COPYING in the main directory of this archive for
  * more details.
  *
+ * Framebuffer driver for Silicon Motion SM710, SM712, SM721 and SM722 chips
  */
 
 #include <linux/io.h>
@@ -758,7 +759,7 @@ static void smtc_unmap_smem(struct smtcfb_info *sfb)
 }
 
 /*
- * We need to wake up the LynxEM+, and make sure its in linear memory mode.
+ * We need to wake up the device and make sure its in linear memory mode.
  */
 static inline void sm7xx_init_hw(void)
 {
@@ -963,7 +964,11 @@ failed_free:
 	return err;
 }
 
-
+/*
+ * 0x710 (LynxEM)
+ * 0x712 (LynxEM+)
+ * 0x720 (Lynx3DM, Lynx3DM+)
+ */
 static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
 	{ PCI_DEVICE(0x126f, 0x710), },
 	{ PCI_DEVICE(0x126f, 0x712), },
@@ -971,7 +976,6 @@ static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
 	{0,}
 };
 
-
 static void __devexit smtcfb_pci_remove(struct pci_dev *pdev)
 {
 	struct smtcfb_info *sfb;
-- 
1.7.10


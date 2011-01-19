Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1ASDmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:42:12 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:44119 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1ASDmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:42:11 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Artem Bityutskiy <dedekind1@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-mtd@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH] mtd/of: allow MTD_OF_PARTS and MTD_PHYSMAP_OF config to others
Date: Wed, 19 Jan 2011 11:43:59 +0800
Message-Id: <1295408639-14742-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.3.4
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As devicetree support is added to more arch, these config should
be allowed to other arch.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/mtd/Kconfig      |    2 +-
 drivers/mtd/maps/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 1e2cbf5..b1f7689 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -159,7 +159,7 @@ config MTD_AFS_PARTS
 
 config MTD_OF_PARTS
 	tristate "Flash partition map based on OF description"
-	depends on (MICROBLAZE || PPC_OF) && MTD_PARTITIONS
+	depends on OF && MTD_PARTITIONS
 	help
 	  This provides a partition parsing function which derives
 	  the partition map from the children of the flash node,
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index a0dd7bb..5d37d31 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -72,7 +72,7 @@ config MTD_PHYSMAP_BANKWIDTH
 
 config MTD_PHYSMAP_OF
 	tristate "Flash device in physical memory map based on OF description"
-	depends on (MICROBLAZE || PPC_OF) && (MTD_CFI || MTD_JEDECPROBE || MTD_ROM)
+	depends on OF && (MTD_CFI || MTD_JEDECPROBE || MTD_ROM)
 	help
 	  This provides a 'mapping' driver which allows the NOR Flash and
 	  ROM driver code to communicate with chips which are mapped
-- 
1.7.3.4


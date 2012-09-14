Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203Ab2INWhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:37:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45419 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760146Ab2INWhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:37:11 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/dqVoDg2XdnZqIxShL1gspdtF6SQ3RbPpkivmbdo
	c6qJA4ulb5aLwa
From: Peter Huewe <peterhuewe@gmx.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Huang Shijie <b32955@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] mtd/nand/docg4: Add missing HAS_IOMEM dependency
Date: Sat, 15 Sep 2012 00:41:09 +0200
Message-Id: <1347662469-1604-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While building an allyesconfig for UML I received this error message(s):
 drivers/mtd/nand/docg4.c: In function 'probe_docg4':
 drivers/mtd/nand/docg4.c:1272:2: error: implicit declaration of function
 'ioremap' [-Werror=implicit-function-declaration]
 drivers/mtd/nand/docg4.c:1272:10: warning: assignment makes pointer from
 integer without a cast [enabled by default]
 drivers/mtd/nand/docg4.c:1327:2: error: implicit declaration of function
 'iounmap' [-Werror=implicit-function-declaration]

which is caused by the missing implementations on UML.

This patch adds this missing HAS_IOMEM dependency and prevents the driver from
being build on platforms with no HAS_IOMEM

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/mtd/nand/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 8ca4176..3e2f75d 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -356,7 +356,7 @@ config MTD_NAND_DISKONCHIP_BBTWRITE
 
 config MTD_NAND_DOCG4
 	tristate "Support for DiskOnChip G4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && HAS_IOMEM
 	select BCH
 	select BITREVERSE
 	help
-- 
1.7.8.6


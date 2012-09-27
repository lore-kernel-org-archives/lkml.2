Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2I0Kg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:36:56 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:33408 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2I0Kgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdSECAxVwYTiAm3b5E1A5VpkxQ
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447804"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 03/17] Staging: ipack/bridges/tpci200: Don't map memory spaces that are not used later on.
Date: Thu, 27 Sep 2012 12:37:27 +0200
Message-Id: <1348742261-28145-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Remove the unused pointers to these spaces.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   10 ----------
 drivers/staging/ipack/bridges/tpci200.h |    2 --
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index ee66129..a804290 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -78,8 +78,6 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	free_irq(tpci200->info->pdev->irq, (void *) tpci200);
 
 	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
-	pci_iounmap(tpci200->info->pdev, tpci200->info->ioidint_space);
-	pci_iounmap(tpci200->info->pdev, tpci200->info->mem8_space);
 	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
 
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
@@ -289,14 +287,6 @@ static int tpci200_register(struct tpci200_board *tpci200)
 		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
 					   TPCI200_IP_INTERFACE_BAR),
 			TPCI200_IFACE_SIZE);
-	tpci200->info->ioidint_space =
-		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
-					   TPCI200_IO_ID_INT_SPACES_BAR),
-			TPCI200_IOIDINT_SIZE);
-	tpci200->info->mem8_space =
-		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
-					   TPCI200_MEM8_SPACE_BAR),
-			TPCI200_MEM8_SIZE);
 
 	/* Initialize lock that protects interface_regs */
 	spin_lock_init(&tpci200->regs_lock);
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 235d1fe..e4ed0a3 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -156,8 +156,6 @@ struct tpci200_infos {
 	struct pci_dev			*pdev;
 	struct pci_device_id		*id_table;
 	struct tpci200_regs __iomem	*interface_regs;
-	void __iomem			*ioidint_space;
-	void __iomem			*mem8_space;
 	void __iomem			*cfg_regs;
 	struct ipack_bus_device		*ipack_bus;
 };
-- 
1.7.10.4


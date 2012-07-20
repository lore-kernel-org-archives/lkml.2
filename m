Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2GTHjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:39:06 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:30124 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752622Ab2GTHi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:38:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAAIKCVBbdWOb/2dsb2JhbABFhXSzSoEHgiEBBSMECwFGECUCJgICVwYTiBGsB5MDgSCPeoESA5VEiSmGYIJh
X-IronPort-AV: E=Sophos;i="4.77,621,1336341600"; 
   d="scan'208";a="546394758"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Subject: [PATCH 3/3] Staging: ipack/bridges/tpci200: use ioremap_nocache instead of ioremap
Date: Fri, 20 Jul 2012 09:39:05 +0200
Message-Id: <1342769945-6999-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342769945-6999-1-git-send-email-siglesias@igalia.com>
References: <1342769945-6999-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU might write-combine and/or cache memory access.  Something that for
most modules is not desired.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index cee25c7..5831af8 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -390,15 +390,15 @@ static int tpci200_register(struct tpci200_board *tpci200)
 
 	/* Map internal tpci200 driver user space */
 	tpci200->info->interface_regs =
-		ioremap(pci_resource_start(tpci200->info->pdev,
+		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
 					   TPCI200_IP_INTERFACE_BAR),
 			TPCI200_IFACE_SIZE);
 	tpci200->info->ioidint_space =
-		ioremap(pci_resource_start(tpci200->info->pdev,
+		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
 					   TPCI200_IO_ID_INT_SPACES_BAR),
 			TPCI200_IOIDINT_SIZE);
 	tpci200->info->mem8_space =
-		ioremap(pci_resource_start(tpci200->info->pdev,
+		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
 					   TPCI200_MEM8_SPACE_BAR),
 			TPCI200_MEM8_SIZE);
 
@@ -677,7 +677,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 
 	virt_addr_space->size = size_to_map;
 	virt_addr_space->address =
-		ioremap((unsigned long)phys_address, size_to_map);
+		ioremap_nocache((unsigned long)phys_address, size_to_map);
 
 out_unlock:
 	mutex_unlock(&tpci200->mutex);
-- 
1.7.10.4


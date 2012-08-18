Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2HRRdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:33:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:35714 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2HRRa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="204520299"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/31] sections: Fix section conflicts in arch/mips
Date: Sat, 18 Aug 2012 10:29:57 -0700
Message-Id: <1345311022-26328-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/mips/bcm63xx/boards/board_bcm963xx.c |    2 +-
 arch/mips/pci/pci-octeon.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index feb0525..dd18e4b 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -632,7 +632,7 @@ static struct board_info __initdata board_DWVS0 = {
 /*
  * all boards
  */
-static const struct board_info __initdata *bcm963xx_boards[] = {
+static const struct board_info __initconst *bcm963xx_boards[] = {
 #ifdef CONFIG_BCM63XX_CPU_6328
 	&board_96328avng,
 #endif
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index 52a1ba7..0e6b15c 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -58,7 +58,7 @@ union octeon_pci_address {
 	} s;
 };
 
-int __initdata (*octeon_pcibios_map_irq)(const struct pci_dev *dev,
+int __initconst (*octeon_pcibios_map_irq)(const struct pci_dev *dev,
 					 u8 slot, u8 pin);
 enum octeon_dma_bar_type octeon_dma_bar_type = OCTEON_DMA_BAR_TYPE_INVALID;
 
-- 
1.7.7.6


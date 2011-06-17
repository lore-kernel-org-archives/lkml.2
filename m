Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1FQBNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:13:14 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:21792 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698Ab1FQBNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:13:08 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Turischev <denis@compulab.co.il>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_phub: Fix register miss-setting issue
Date: Fri, 17 Jun 2011 10:13:26 +0900
Message-Id: <1308273206-3074-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register "interrupt delay value" is for GbE which is connected to Bus-m of PCIe.
However currently, the value is set for Bus-n.
As a result, the value is not set correctly.
This patch moves setting the value processing of Bus-n to Bus-m.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/misc/pch_phub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 4d2b7ed..7bc6f35 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -731,6 +731,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		 * Device8(GbE)
 		 */
 		iowrite32(0x000a0000, chip->pch_phub_base_address + 0x14);
+		/* set the interrupt delay value */
+		iowrite32(0x25, chip->pch_phub_base_address + 0x140);
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
@@ -748,8 +750,6 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		 * Device6(SATA 2):f
 		 */
 		iowrite32(0x0000ffa0, chip->pch_phub_base_address + 0x14);
-		/* set the interrupt delay value */
-		iowrite32(0x25, chip->pch_phub_base_address + 0x140);
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
-- 
1.7.4


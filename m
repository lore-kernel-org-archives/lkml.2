Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0L0WAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 17:00:15 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:41427 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0L0WAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 17:00:13 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.37rc] ARM: fix IXP4xx build failure
Date: Mon, 27 Dec 2010 22:59:57 +0100
Message-ID: <m3lj3aop0i.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Kaloz <kaloz@openwrt.org>

arm: export dma_set_coherent_mask

While a regression was fixed with commit 710224fa2750cf (arm: fix
"arm: fix pci_set_consistent_dma_mask for dmabounce devices"), a
new one was introduced as dma_set_coherent_mask wasn't exported
for modules. This patch takes care for this issue.

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -352,3 +352,4 @@ struct pci_bus * __init it8152_pci_scan_bus(int nr, struct pci_sys_data *sys)
 	return pci_scan_bus(nr, &it8152_ops, sys);
 }
 
+EXPORT_SYMBOL(dma_set_coherent_mask);
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -483,4 +483,4 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
 
 EXPORT_SYMBOL(ixp4xx_pci_read);
 EXPORT_SYMBOL(ixp4xx_pci_write);
-
+EXPORT_SYMBOL(dma_set_coherent_mask);

-- 
Krzysztof Halasa

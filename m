Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0LLWAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 17:00:18 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:40108 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0LLWAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 17:00:16 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 17:00:16 EST
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Fix IXP4xx build
Date: Sun, 12 Dec 2010 22:52:36 +0100
Message-ID: <m3ei9m7j6j.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

Is it ok if I send the following to Linus, or would you like to do it
yourself? Leaving IXP4xx build broken for 2.6.37 isn't the best idea.

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

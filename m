Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1HCHSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 03:18:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63291 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1HCHSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 03:18:23 -0400
Subject: [PATCH RESEND] omap1: select GENERIC_IRQ_CHIP for TI OMAP1
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 15:18:17 +0800
Message-ID: <1312355897.14329.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio-omap driver has been converted to use generic IRQ chip.
Thus select GENERIC_IRQ_CHIP for TI OMAP1 to fix below build error.

 LD      vmlinux
drivers/built-in.o: In function `omap_mpuio_alloc_gc':
drivers/gpio/gpio-omap.c:1087: undefined reference to `irq_alloc_generic_chip'
drivers/gpio/gpio-omap.c:1100: undefined reference to `irq_setup_generic_chip'
drivers/built-in.o: In function `omap_gpio_show_rev':
drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_clr_bit'
drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_set_bit'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Kevin already sent a similar patch.  http://marc.info/?l=linux-omap&m=130749135312468&w=2
But I still have the build error with make omap1_defconfig in today's linux-next tree.
So here is a resend.

Regards,
Axel
 arch/arm/plat-omap/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 6e6735f..bb8f4a6 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -13,6 +13,7 @@ config ARCH_OMAP1
 	bool "TI OMAP1"
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
+	select GENERIC_IRQ_CHIP
 	help
 	  "Systems based on omap7xx, omap15xx or omap16xx"
 
-- 
1.7.4.1




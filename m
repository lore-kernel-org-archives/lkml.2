Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1F1JHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:07:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43540 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab1F1JFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=eTidOoZ+DpXWJ8+81mLSyCqkuMs5lFaMYMVmdKMv+gQao5uZhw81ccVoWl+PTwvYtc
         phmPBV38rSC3FQ8amkfUb4st+SZq8Y04ojWmSZDbzwOEABdfpmJe5Zc5fTe4dKN623Np
         LFgqc+UTug6k8ra+zXLVrmk4uRLrKZoYyP3j4=
Subject: [PATCH] omap1: select GENERIC_IRQ_CHIP for TI OMAP1
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 17:05:43 +0800
Message-ID: <1309251943.3984.1.camel@phoenix>
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
 arch/arm/plat-omap/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 49a4c75..9a4a6bf 100644
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




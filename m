Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1HJMSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:18:38 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:36116 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204Ab1HJMSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:18:36 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Vitaly Wool <vitalywool@gmail.com>
Subject: [PATCH 16/19] mach-pnx4008: move PNX4008 GPIO driver to GPIO subsystem
Date: Wed, 10 Aug 2011 14:18:25 +0200
Message-ID: <1312978705-18605-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As per example from the other ARM boards, push the PNX4008
GPIO driver down to the GPIO subsystem so it can be consolidated.

Cc: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-pnx4008/Makefile                     |    2 +-
 drivers/gpio/Makefile                              |    1 +
 .../gpio.c => drivers/gpio/gpio-pnx4008.c          |    0
 3 files changed, 2 insertions(+), 1 deletions(-)
 rename arch/arm/mach-pnx4008/gpio.c => drivers/gpio/gpio-pnx4008.c (100%)

diff --git a/arch/arm/mach-pnx4008/Makefile b/arch/arm/mach-pnx4008/Makefile
index 777564c..5e2e211 100644
--- a/arch/arm/mach-pnx4008/Makefile
+++ b/arch/arm/mach-pnx4008/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y			:= core.o irq.o time.o clock.o gpio.o serial.o dma.o i2c.o
+obj-y			:= core.o irq.o time.o clock.o serial.o dma.o i2c.o
 obj-m			:=
 obj-n			:=
 obj-			:=
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 6640e1d..7f846bf 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_GPIO_PCA953X)	+= gpio-pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
 obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
+obj-$(CONFIG_ARCH_PNX4008)	+= gpio-pnx4008.o
 obj-$(CONFIG_PLAT_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 
diff --git a/arch/arm/mach-pnx4008/gpio.c b/drivers/gpio/gpio-pnx4008.c
similarity index 100%
rename from arch/arm/mach-pnx4008/gpio.c
rename to drivers/gpio/gpio-pnx4008.c
-- 
1.7.3.2


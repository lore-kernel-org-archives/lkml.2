Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1HJMRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:17:36 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:60353 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1HJMRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:17:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: [PATCH 08/19] mach-davinci: move DaVinci TNET GPIO driver to GPIO subsystem
Date: Wed, 10 Aug 2011 14:17:19 +0200
Message-ID: <1312978639-18339-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As per example from the other ARM boards, push the DaVinci TNET
GPIO driver down to the GPIO subsystem so it can be consolidated.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-davinci/Makefile                     |    1 -
 drivers/gpio/Makefile                              |    1 +
 .../mach-davinci => drivers/gpio}/gpio-tnetv107x.c |    0
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename {arch/arm/mach-davinci => drivers/gpio}/gpio-tnetv107x.c (100%)

diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 8f3c8ee..495e313 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_ARCH_DAVINCI_DM365)	+= dm365.o devices.o
 obj-$(CONFIG_ARCH_DAVINCI_DA830)        += da830.o devices-da8xx.o
 obj-$(CONFIG_ARCH_DAVINCI_DA850)        += da850.o devices-da8xx.o
 obj-$(CONFIG_ARCH_DAVINCI_TNETV107X)    += tnetv107x.o devices-tnetv107x.o
-obj-$(CONFIG_ARCH_DAVINCI_TNETV107X)    += gpio-tnetv107x.o
 
 obj-$(CONFIG_AINTC)			+= irq.o
 obj-$(CONFIG_CP_INTC)			+= cp_intc.o
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index a26fffa..2269822 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
 obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
+obj-$(CONFIG_ARCH_DAVINCI_TNETV107X) += gpio-tnetv107x.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
diff --git a/arch/arm/mach-davinci/gpio-tnetv107x.c b/drivers/gpio/gpio-tnetv107x.c
similarity index 100%
rename from arch/arm/mach-davinci/gpio-tnetv107x.c
rename to drivers/gpio/gpio-tnetv107x.c
-- 
1.7.3.2


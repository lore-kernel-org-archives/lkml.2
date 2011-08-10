Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1HJMSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:18:43 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:45048 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab1HJMSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:18:38 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 14/19] plat-pxa: move PXA GPIO driver to GPIO subsystem
Date: Wed, 10 Aug 2011 14:18:09 +0200
Message-ID: <1312978689-18539-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As per example from the other ARM boards, push the PXA
GPIO driver down to the GPIO subsystem so it can be consolidated.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-pxa/Makefile                         |    1 -
 drivers/gpio/Makefile                              |    1 +
 .../arm/plat-pxa/gpio.c => drivers/gpio/gpio-pxa.c |    0
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/arm/plat-pxa/gpio.c => drivers/gpio/gpio-pxa.c (100%)

diff --git a/arch/arm/plat-pxa/Makefile b/arch/arm/plat-pxa/Makefile
index 3aca5ba..f302d04 100644
--- a/arch/arm/plat-pxa/Makefile
+++ b/arch/arm/plat-pxa/Makefile
@@ -4,7 +4,6 @@
 
 obj-y	:= dma.o
 
-obj-$(CONFIG_GENERIC_GPIO)	+= gpio.o
 obj-$(CONFIG_PXA3xx)		+= mfp.o
 obj-$(CONFIG_PXA95x)		+= mfp.o
 obj-$(CONFIG_ARCH_MMP)		+= mfp.o
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 33e095bd..6640e1d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_GPIO_PCA953X)	+= gpio-pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
 obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
+obj-$(CONFIG_PLAT_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 
 obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
diff --git a/arch/arm/plat-pxa/gpio.c b/drivers/gpio/gpio-pxa.c
similarity index 100%
rename from arch/arm/plat-pxa/gpio.c
rename to drivers/gpio/gpio-pxa.c
-- 
1.7.3.2


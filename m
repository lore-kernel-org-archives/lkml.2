Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936188Ab1KJD4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:56:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33718 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935924Ab1KJD4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:56:34 -0500
Message-ID: <1320897382.13190.1.camel@phoenix>
Subject: [PATCH] ARM: SAMSUNG: gpio-cfg.h: include linux/types.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 10 Nov 2011 11:56:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/types.h to fix below build error:

  CC      drivers/power/max8903_charger.o
In file included from arch/arm/plat-samsung/include/plat/gpio-fns.h:27,
                 from arch/arm/mach-s3c2410/include/mach/gpio-fns.h:1,
                 from arch/arm/mach-s3c2410/include/mach/gpio.h:27,
                 from /home/axel/repos/git/linux-2.6/arch/arm/include/asm/gpio.h:5,
                 from include/linux/gpio.h:30,
                 from drivers/power/max8903_charger.c:23:
arch/arm/plat-samsung/include/plat/gpio-cfg.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'samsung_gpio_pull_t'
arch/arm/plat-samsung/include/plat/gpio-cfg.h:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before 's5p_gpio_drvstr_t'
arch/arm/plat-samsung/include/plat/gpio-cfg.h:55: error: expected specifier-qualifier-list before 'samsung_gpio_pull_t'
arch/arm/plat-samsung/include/plat/gpio-cfg.h:146: error: expected declaration specifiers or '...' before 'samsung_gpio_pull_t'
arch/arm/plat-samsung/include/plat/gpio-cfg.h:154: error: expected '=', ',', ';', 'asm' or '__attribute__' before 's3c_gpio_getpull'
arch/arm/plat-samsung/include/plat/gpio-cfg.h:173: error: expected declaration specifiers or '...' before 'samsung_gpio_pull_t'
arch/arm/plat-samsung/include/plat/gpio-cfg.h: In function 's3c_gpio_cfgrange_nopull':
arch/arm/plat-samsung/include/plat/gpio-cfg.h:178: error: '__force' undeclared (first use in this function)
arch/arm/plat-samsung/include/plat/gpio-cfg.h:178: error: (Each undeclared identifier is reported only once
arch/arm/plat-samsung/include/plat/gpio-cfg.h:178: error: for each function it appears in.)
arch/arm/plat-samsung/include/plat/gpio-cfg.h:178: error: expected ')' before 'samsung_gpio_pull_t'
arch/arm/plat-samsung/include/plat/gpio-cfg.h:178: error: expected ')' before numeric constant
arch/arm/plat-samsung/include/plat/gpio-cfg.h:178: error: too many arguments to function 's3c_gpio_cfgall_range'
arch/arm/plat-samsung/include/plat/gpio-cfg.h: At top level:
arch/arm/plat-samsung/include/plat/gpio-cfg.h:197: error: expected '=', ',', ';', 'asm' or '__attribute__' before 's5p_gpio_get_drvstr'
arch/arm/plat-samsung/include/plat/gpio-cfg.h:208: error: expected declaration specifiers or '...' before 's5p_gpio_drvstr_t'
make[2]: *** [drivers/power/max8903_charger.o] Error 1
make[1]: *** [drivers/power] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/plat-samsung/include/plat/gpio-cfg.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/gpio-cfg.h b/arch/arm/plat-samsung/include/plat/gpio-cfg.h
index d48245b..df8155b 100644
--- a/arch/arm/plat-samsung/include/plat/gpio-cfg.h
+++ b/arch/arm/plat-samsung/include/plat/gpio-cfg.h
@@ -24,6 +24,8 @@
 #ifndef __PLAT_GPIO_CFG_H
 #define __PLAT_GPIO_CFG_H __FILE__
 
+#include<linux/types.h>
+
 typedef unsigned int __bitwise__ samsung_gpio_pull_t;
 typedef unsigned int __bitwise__ s5p_gpio_drvstr_t;
 
-- 
1.7.5.4




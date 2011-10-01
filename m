Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1JAUFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1JAUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/26] ARM: pxa: pxa95x/saarb depends on pxa3xx code
Date: Sat,  1 Oct 2011 22:03:44 +0200
Message-Id: <1317499438-14058-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:GGlW+HRhOye41uFjg5Dgm3HqjSZ1bPJQws+de0wk2ef
 Bqui9Vb52KIhGb8lZ05cAGi26QdDnu8aoJbbmJPOppbtvg12KS
 KOCchHhUajoEgzt5ZyGOD/fxU7UZYyLukQnDF0iFSNnHg/tIbH
 GFmh3kiquEoN3j7YeyViaTnM+Rfcp1JOo+FpvYMC7XYigc3ikB
 LD9moS0HJK2tafUSyISiv0On3qTnu1ijyIPXTrth4UMHLxbPo+
 jGZvRSwWvT4mpEi12c3bhrNBDVDEgdEZoLmreYX5i78rb7i4tr
 r2VCD4h6Fzqjdm6f+Wl97e/AlvEdWPxMAg55YQIrBStlILc8mI
 ScWuh+ujCQQNXTKIniqHy8byaDYW2Ae10qyaxJMeGB5ZJ3UCBV
 0ovJwB4yZjy4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

saarb uses pxa3xx_map_io and pxa3xx_handle_irq, which are part
of the pxa3xx code. This makes sure the necessary header and
implementation is used when building the board file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Makefile |    2 +-
 arch/arm/mach-pxa/saarb.c  |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index cc39d17..be0f7df 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -19,7 +19,7 @@ endif
 obj-$(CONFIG_PXA25x)		+= mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa25x.o
 obj-$(CONFIG_PXA27x)		+= mfp-pxa2xx.o clock-pxa2xx.o pxa2xx.o pxa27x.o
 obj-$(CONFIG_PXA3xx)		+= mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o smemc.o pxa3xx-ulpi.o
-obj-$(CONFIG_PXA95x)		+= mfp-pxa3xx.o clock-pxa3xx.o pxa95x.o smemc.o
+obj-$(CONFIG_PXA95x)		+= mfp-pxa3xx.o clock-pxa3xx.o pxa3xx.o pxa95x.o smemc.o
 obj-$(CONFIG_CPU_PXA300)	+= pxa300.o
 obj-$(CONFIG_CPU_PXA320)	+= pxa320.o
 obj-$(CONFIG_CPU_PXA930)	+= pxa930.o
diff --git a/arch/arm/mach-pxa/saarb.c b/arch/arm/mach-pxa/saarb.c
index ebd6379..829c514 100644
--- a/arch/arm/mach-pxa/saarb.c
+++ b/arch/arm/mach-pxa/saarb.c
@@ -25,6 +25,8 @@
 #include <mach/mfp-pxa930.h>
 #include <mach/gpio.h>
 
+#include <mach/pxa930.h>
+
 #include "generic.h"
 
 #define SAARB_NR_IRQS	(IRQ_BOARD_START + 40)
-- 
1.7.5.4


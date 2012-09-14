Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2INVfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab2INVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 04/24] ARM: ep93xx: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:32 +0200
Message-Id: <1347658492-11608-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:sM7BIM67SH/pbgVqhpQpsimhvfLrdI9dCcu0zvp+rjO
 i01Q74sdLd6qiDaoBGeYfBMup/HiKmoEkmR/AK9KyBOkJh86Tc
 939WpAO73HkmkvsN5rZ2pV+xamSuDcWKF1qeBKUTcOuPae3zcc
 Q466BTjodubkOUt7+REsUpg+gVUDwkI83G/y/Xy55htIE9GbyU
 RsvA7exurHZXh3gQ0ofhCy7wR9JRGvzNyZ0LKEfiKhAWKqOrBh
 3lYtcKpxROjEK+K9+Z9mYfjfibvvRG8SIM1yE+yO1Na0sTQrbp
 YXLuWsCOTqPgydRiQKWvBNCyMv1ZZUvGUpy7Jt5mXUwnnxXkie
 +iPkzvGQLeJukaLVCkH8M/9y0G/EofjIFUtW1POgfxbF6IZWIV
 5AuKswAwkQf7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-ep93xx/include/mach/ts72xx.h |   10 +++++-----
 arch/arm/mach-ep93xx/ts72xx.c              |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-ep93xx/include/mach/ts72xx.h b/arch/arm/mach-ep93xx/include/mach/ts72xx.h
index f1397a1..071feaa 100644
--- a/arch/arm/mach-ep93xx/include/mach/ts72xx.h
+++ b/arch/arm/mach-ep93xx/include/mach/ts72xx.h
@@ -14,7 +14,7 @@
  */
 
 #define TS72XX_MODEL_PHYS_BASE		0x22000000
-#define TS72XX_MODEL_VIRT_BASE		0xfebff000
+#define TS72XX_MODEL_VIRT_BASE		IOMEM(0xfebff000)
 #define TS72XX_MODEL_SIZE		0x00001000
 
 #define TS72XX_MODEL_TS7200		0x00
@@ -26,7 +26,7 @@
 
 
 #define TS72XX_OPTIONS_PHYS_BASE	0x22400000
-#define TS72XX_OPTIONS_VIRT_BASE	0xfebfe000
+#define TS72XX_OPTIONS_VIRT_BASE	IOMEM(0xfebfe000)
 #define TS72XX_OPTIONS_SIZE		0x00001000
 
 #define TS72XX_OPTIONS_COM2_RS485	0x02
@@ -34,18 +34,18 @@
 
 
 #define TS72XX_OPTIONS2_PHYS_BASE	0x22800000
-#define TS72XX_OPTIONS2_VIRT_BASE	0xfebfd000
+#define TS72XX_OPTIONS2_VIRT_BASE	IOMEM(0xfebfd000)
 #define TS72XX_OPTIONS2_SIZE		0x00001000
 
 #define TS72XX_OPTIONS2_TS9420		0x04
 #define TS72XX_OPTIONS2_TS9420_BOOT	0x02
 
 
-#define TS72XX_RTC_INDEX_VIRT_BASE	0xfebf9000
+#define TS72XX_RTC_INDEX_VIRT_BASE	IOMEM(0xfebf9000)
 #define TS72XX_RTC_INDEX_PHYS_BASE	0x10800000
 #define TS72XX_RTC_INDEX_SIZE		0x00001000
 
-#define TS72XX_RTC_DATA_VIRT_BASE	0xfebf8000
+#define TS72XX_RTC_DATA_VIRT_BASE	IOMEM(0xfebf8000)
 #define TS72XX_RTC_DATA_PHYS_BASE	0x11700000
 #define TS72XX_RTC_DATA_SIZE		0x00001000
 
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index 75cab2d..faa5bdd 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -32,27 +32,27 @@
 
 static struct map_desc ts72xx_io_desc[] __initdata = {
 	{
-		.virtual	= TS72XX_MODEL_VIRT_BASE,
+		.virtual	= (unsigned long)TS72XX_MODEL_VIRT_BASE,
 		.pfn		= __phys_to_pfn(TS72XX_MODEL_PHYS_BASE),
 		.length		= TS72XX_MODEL_SIZE,
 		.type		= MT_DEVICE,
 	}, {
-		.virtual	= TS72XX_OPTIONS_VIRT_BASE,
+		.virtual	= (unsigned long)TS72XX_OPTIONS_VIRT_BASE,
 		.pfn		= __phys_to_pfn(TS72XX_OPTIONS_PHYS_BASE),
 		.length		= TS72XX_OPTIONS_SIZE,
 		.type		= MT_DEVICE,
 	}, {
-		.virtual	= TS72XX_OPTIONS2_VIRT_BASE,
+		.virtual	= (unsigned long)TS72XX_OPTIONS2_VIRT_BASE,
 		.pfn		= __phys_to_pfn(TS72XX_OPTIONS2_PHYS_BASE),
 		.length		= TS72XX_OPTIONS2_SIZE,
 		.type		= MT_DEVICE,
 	}, {
-		.virtual	= TS72XX_RTC_INDEX_VIRT_BASE,
+		.virtual	= (unsigned long)TS72XX_RTC_INDEX_VIRT_BASE,
 		.pfn		= __phys_to_pfn(TS72XX_RTC_INDEX_PHYS_BASE),
 		.length		= TS72XX_RTC_INDEX_SIZE,
 		.type		= MT_DEVICE,
 	}, {
-		.virtual	= TS72XX_RTC_DATA_VIRT_BASE,
+		.virtual	= (unsigned long)TS72XX_RTC_DATA_VIRT_BASE,
 		.pfn		= __phys_to_pfn(TS72XX_RTC_DATA_PHYS_BASE),
 		.length		= TS72XX_RTC_DATA_SIZE,
 		.type		= MT_DEVICE,
-- 
1.7.10


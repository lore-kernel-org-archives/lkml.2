Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab2INVf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828Ab2INVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Jochen Friedrich <jochen@scram.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 15/24] ARM: sa1100: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:43 +0200
Message-Id: <1347658492-11608-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0LvK15tmXfFYHthTW3ShVJt1cq9x2mt/rN7nSwcEN3z
 UL/kQdFmYcGgMp2/e+ODL7UOGiqm8PvQNkyKZhiBVMpRb65ezt
 7Yt1Dw+7mlPJHnczzu8YjzWOakRNKyfGBGbSCGmm8679a58bxg
 N0H+djI9o2URg8nbWsPuP39i7gL3c/RziqyfguDyk3+yQ+8WJL
 d9T57cbzYXUwhqPQW+DjkObre+f8VJoJB2kfhJuXSmJt0t7+No
 N1IoNPZRciZBXveEqL0Rrh8oX73vpKEjl8LhjkZueWz7oCbjGD
 VZw3yFnVeBawZjS2HnJjdZrBITX/lhMQ3Kiq25zac2fTx4u0a3
 wjhDZ1F923guKScRY7IWC8Y70CnxqMl8ds5wz6984cW5e52NED
 p4QMXD1rJhR6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Jochen Friedrich <jochen@scram.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-sa1100/include/mach/simpad.h |    2 +-
 arch/arm/mach-sa1100/simpad.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-sa1100/include/mach/simpad.h b/arch/arm/mach-sa1100/include/mach/simpad.h
index cdea671..ac2ea76 100644
--- a/arch/arm/mach-sa1100/include/mach/simpad.h
+++ b/arch/arm/mach-sa1100/include/mach/simpad.h
@@ -87,7 +87,7 @@
 #define SIMPAD_CS3_PCMCIA_SHORT		(SIMPAD_CS3_GPIO_BASE + 22)
 #define SIMPAD_CS3_GPIO_23		(SIMPAD_CS3_GPIO_BASE + 23)
 
-#define CS3_BASE        0xf1000000
+#define CS3_BASE        IOMEM(0xf1000000)
 
 long simpad_get_cs3_ro(void);
 long simpad_get_cs3_shadow(void);
diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
index fbd5359..6ca92d0 100644
--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -124,7 +124,7 @@ static struct map_desc simpad_io_desc[] __initdata = {
 		.length		= 0x00800000,
 		.type		= MT_DEVICE
 	}, {	/* Simpad CS3 */
-		.virtual	= CS3_BASE,
+		.virtual	= (unsigned long)CS3_BASE,
 		.pfn		= __phys_to_pfn(SA1100_CS3_PHYS),
 		.length		= 0x00100000,
 		.type		= MT_DEVICE
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab2INVlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:41:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab2INVf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>
Subject: [PATCH 13/24] ARM: nomadik: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:41 +0200
Message-Id: <1347658492-11608-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:scx6WOHbfcgLOJhBH7MVQ99ReOMrtQKfNehcYbrZsXo
 ruNKKKS8/hei1hlhfecpBMG0zl+0G8NnUGrm9o3enoApJ4Dha7
 yvjMdEWaAZ0nyzhkxC/XrsmY5duge5qLEy5dMBK07iNqzAqJj8
 vbJS1p2KGZBItr/PZ6s2sJAjmf3RYt0lu7l+WLESxG5CnabaPF
 kJoZv/4CVqg04vWxVSOinvFoeY8M23iVnLIC8/OUYfcWHfuNln
 NLHDj4sXI2FIP9/pMhAjanKaHe0hPD9BKEJ0JA/ohgDtUWuCSG
 dalBoy9/NGCJRZZ4rRS2egVABjk/nNEPp3jcRK4M7ypcNDu9Fk
 AlO7ketoqSTeNU3K/l1PZdmbV4+BI7thZhbtYnnKhHpXKtZN3m
 EMLeIoGaKae2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-nomadik/board-nhk8815.c           |    3 +--
 arch/arm/mach-nomadik/include/mach/hardware.h   |    2 +-
 arch/arm/mach-nomadik/include/mach/uncompress.h |    8 ++++----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index f4535a7..c3841a9 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -112,8 +112,7 @@ static struct mtd_partition nhk8815_partitions[] = {
 static struct nomadik_nand_platform_data nhk8815_nand_data = {
 	.parts		= nhk8815_partitions,
 	.nparts		= ARRAY_SIZE(nhk8815_partitions),
-	.options	= NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING \
-			| NAND_NO_READRDY,
+	.options	= NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING,
 	.init		= nhk8815_nand_init,
 };
 
diff --git a/arch/arm/mach-nomadik/include/mach/hardware.h b/arch/arm/mach-nomadik/include/mach/hardware.h
index 6316dba..02035e4 100644
--- a/arch/arm/mach-nomadik/include/mach/hardware.h
+++ b/arch/arm/mach-nomadik/include/mach/hardware.h
@@ -30,7 +30,7 @@
 			- NOMADIK_IO_VIRTUAL + NOMADIK_IO_PHYSICAL)
 
 /* used in asm code, so no casts */
-#define IO_ADDRESS(x) ((x) - NOMADIK_IO_PHYSICAL + NOMADIK_IO_VIRTUAL)
+#define IO_ADDRESS(x) IOMEM((x) - NOMADIK_IO_PHYSICAL + NOMADIK_IO_VIRTUAL)
 
 /*
  *   Base address defination for Nomadik Onchip Logic Block
diff --git a/arch/arm/mach-nomadik/include/mach/uncompress.h b/arch/arm/mach-nomadik/include/mach/uncompress.h
index 071003b..7d4687e 100644
--- a/arch/arm/mach-nomadik/include/mach/uncompress.h
+++ b/arch/arm/mach-nomadik/include/mach/uncompress.h
@@ -27,10 +27,10 @@
 struct amba_device;
 #include <linux/amba/serial.h>
 
-#define NOMADIK_UART_DR		0x101FB000
-#define NOMADIK_UART_LCRH	0x101FB02c
-#define NOMADIK_UART_CR		0x101FB030
-#define NOMADIK_UART_FR		0x101FB018
+#define NOMADIK_UART_DR		(void __iomem *)0x101FB000
+#define NOMADIK_UART_LCRH	(void __iomem *)0x101FB02c
+#define NOMADIK_UART_CR		(void __iomem *)0x101FB030
+#define NOMADIK_UART_FR		(void __iomem *)0x101FB018
 
 static void putc(const char c)
 {
-- 
1.7.10


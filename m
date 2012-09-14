Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab2INVlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:41:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab2INVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Barry Song <baohua.song@csr.com>
Subject: [PATCH 14/24] ARM: prima2: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:42 +0200
Message-Id: <1347658492-11608-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:TvdevrEaPXtYC6ekVQWxBud0429dQ9TTKTTbRGwFWBY
 myzhHoBFjVcQNoZFrpcp8nX826pBYJ9n9vPU/SzALT9HsySC2p
 8ONh3iBHhYYZI77jOXHtMavrtDn8eqzTvHsi8NOLTgACNaN1Zg
 Pbt/otzYhOpU3BHdJua02nSkf8ste3e2AiBLVe6+n4LxYwy54y
 +6StUqjebGCy6pzIM3eVW5V/9g4oMyhQNKBKwx8FDngOfDUQv2
 99eR6ZJRdBAL3Umxy0f8Zo695+S6OvVqjDm+RKtTGu90n/DtFs
 dPmt9adaGrycYd56WzisGCp4mJJrtYE4byq2HkQ1Zbg1B+0HTP
 IsBCpKgN3xrZBgnSG7hY+cENTxP4UcyPaauvGIx1l11l+0X/YA
 1OdrWvrCO0BgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Barry Song <baohua.song@csr.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-prima2/include/mach/uncompress.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-prima2/include/mach/uncompress.h b/arch/arm/mach-prima2/include/mach/uncompress.h
index 83125c6..0c898fc 100644
--- a/arch/arm/mach-prima2/include/mach/uncompress.h
+++ b/arch/arm/mach-prima2/include/mach/uncompress.h
@@ -25,11 +25,11 @@ static __inline__ void putc(char c)
 	 * during kernel decompression, all mappings are flat:
 	 *  virt_addr == phys_addr
 	 */
-	while (__raw_readl(SIRFSOC_UART1_PA_BASE + SIRFSOC_UART_TXFIFO_STATUS)
+	while (__raw_readl((void __iomem *)SIRFSOC_UART1_PA_BASE + SIRFSOC_UART_TXFIFO_STATUS)
 		& SIRFSOC_UART1_TXFIFO_FULL)
 		barrier();
 
-	__raw_writel(c, SIRFSOC_UART1_PA_BASE + SIRFSOC_UART_TXFIFO_DATA);
+	__raw_writel(c, (void __iomem *)SIRFSOC_UART1_PA_BASE + SIRFSOC_UART_TXFIFO_DATA);
 }
 
 static inline void flush(void)
-- 
1.7.10


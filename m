Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2BQRuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:50:44 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:53289 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2BQRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:50:43 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] ARM: at91: finally drop at91_sys_read/write
Date: Fri, 17 Feb 2012 18:50:06 +0100
Message-Id: <c28d0078ad5d9ebb86c986959b37be6ac15fce55.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Remove at91_sys_read/write() from io.h file. This function
is not used anymore and was a stopper on the way to single
zImage kernel for AT91.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/io.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/io.h b/arch/arm/mach-at91/include/mach/io.h
index 4ca09ef..4003001 100644
--- a/arch/arm/mach-at91/include/mach/io.h
+++ b/arch/arm/mach-at91/include/mach/io.h
@@ -28,22 +28,4 @@
 #define __io(a)		__typesafe_io(a)
 #define __mem_pci(a)	(a)
 
-#ifndef __ASSEMBLY__
-
-static inline unsigned int at91_sys_read(unsigned int reg_offset)
-{
-	void __iomem *addr = (void __iomem *)AT91_VA_BASE_SYS;
-
-	return __raw_readl(addr + reg_offset);
-}
-
-static inline void at91_sys_write(unsigned int reg_offset, unsigned long value)
-{
-	void __iomem *addr = (void __iomem *)AT91_VA_BASE_SYS;
-
-	__raw_writel(value, addr + reg_offset);
-}
-
-#endif
-
 #endif
-- 
1.7.9


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0F2N7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:59:01 -0400
Received: from mail.df.lth.se ([194.47.250.12]:33590 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756061Ab0F2N7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:59:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       yuanyabin1978@sina.com, Linus Walleij <linus.walleij@stericsson.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 1/2] DMAENGINE: correct PL080 register header file
Date: Tue, 29 Jun 2010 13:36:07 +0200
Message-Id: <1277811367-17694-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PL008 among all other variables named PL080 doesn't seem
right. Fix it. Also add some missing defined that I use in the
new PL08x driver.

Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Ben can you ACK this? Shouldn't be any big deal.
---
 arch/arm/include/asm/hardware/pl080.h |    4 +++-
 arch/arm/mach-s3c64xx/dma.c           |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/hardware/pl080.h b/arch/arm/include/asm/hardware/pl080.h
index 6a6c66b..f35b86e 100644
--- a/arch/arm/include/asm/hardware/pl080.h
+++ b/arch/arm/include/asm/hardware/pl080.h
@@ -43,7 +43,7 @@
 
 /* Per channel configuration registers */
 
-#define PL008_Cx_STRIDE				(0x20)
+#define PL080_Cx_STRIDE				(0x20)
 #define PL080_Cx_BASE(x)			((0x100 + (x * 0x20)))
 #define PL080_Cx_SRC_ADDR(x)			((0x100 + (x * 0x20)))
 #define PL080_Cx_DST_ADDR(x)			((0x104 + (x * 0x20)))
@@ -68,6 +68,8 @@
 #define PL080_CONTROL_TC_IRQ_EN			(1 << 31)
 #define PL080_CONTROL_PROT_MASK			(0x7 << 28)
 #define PL080_CONTROL_PROT_SHIFT		(28)
+#define PL080_CONTROL_PROT_CACHE		(1 << 30)
+#define PL080_CONTROL_PROT_BUFF			(1 << 29)
 #define PL080_CONTROL_PROT_SYS			(1 << 28)
 #define PL080_CONTROL_DST_INCR			(1 << 27)
 #define PL080_CONTROL_SRC_INCR			(1 << 26)
diff --git a/arch/arm/mach-s3c64xx/dma.c b/arch/arm/mach-s3c64xx/dma.c
index 5567e03..e7d03ab 100644
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@ -697,7 +697,7 @@ static int s3c64xx_dma_init1(int chno, enum dma_ch chbase,
 		chptr->number = chno;
 		chptr->dmac = dmac;
 		chptr->regs = regptr;
-		regptr += PL008_Cx_STRIDE;
+		regptr += PL080_Cx_STRIDE;
 	}
 
 	/* for the moment, permanently enable the controller */
-- 
1.7.0.1


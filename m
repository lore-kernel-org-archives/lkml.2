Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0FKP1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:27:44 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:45948 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756384Ab0FKP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:27:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 05/13] ARM: correct PL080 editor mistake
Date: Fri, 11 Jun 2010 17:27:03 +0200
Message-ID: <1276270023-1553-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PL008 among all other variables named PL080 doesn't seem
right. Fix it.

Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/include/asm/hardware/pl080.h |    2 +-
 arch/arm/mach-s3c64xx/dma.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/hardware/pl080.h b/arch/arm/include/asm/hardware/pl080.h
index 6a6c66b..f70e1e9 100644
--- a/arch/arm/include/asm/hardware/pl080.h
+++ b/arch/arm/include/asm/hardware/pl080.h
@@ -43,7 +43,7 @@
 
 /* Per channel configuration registers */
 
-#define PL008_Cx_STRIDE				(0x20)
+#define PL080_Cx_STRIDE				(0x20)
 #define PL080_Cx_BASE(x)			((0x100 + (x * 0x20)))
 #define PL080_Cx_SRC_ADDR(x)			((0x100 + (x * 0x20)))
 #define PL080_Cx_DST_ADDR(x)			((0x104 + (x * 0x20)))
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
1.6.3.3


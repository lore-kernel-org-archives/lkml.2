Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2JPHVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:21:30 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:41974 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2JPHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:21:27 -0400
From: Josh Wu <josh.wu@atmel.com>
To: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com, egtvedt@samfundet.no
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com, fengguang.wu@intel.com,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] avr32: fix build error in atstk1006_defconfig
Date: Tue, 16 Oct 2012 15:19:27 +0800
Message-Id: <1350371967-8914-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 16 Oct 2012 07:21:06.0851 (UTC) FILETIME=[CED63730:01CDAB6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed the following compile error when use avr32 atstk1006_defconfig:
  drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
  drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'

which was introduced by commit 1c7b874d33b463 ("mtd: at91: atmel_nand: add Programmable Multibit ECC controller support").
The PMECC for nand flash code uses writel_relaxed(). But in avr32, there is no macro "writel_relaxed" defined. This patch add writex_relaxed macro definitions.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 arch/avr32/include/asm/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
index cf60d0a..fc6483f 100644
--- a/arch/avr32/include/asm/io.h
+++ b/arch/avr32/include/asm/io.h
@@ -165,6 +165,10 @@ BUILDIO_IOPORT(l, u32)
 #define readw_be			__raw_readw
 #define readl_be			__raw_readl
 
+#define writeb_relaxed			writeb
+#define writew_relaxed			writew
+#define writel_relaxed			writel
+
 #define writeb_be			__raw_writeb
 #define writew_be			__raw_writew
 #define writel_be			__raw_writel
-- 
1.7.9.5


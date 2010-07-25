Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab0GYRLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 13:11:34 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:35017 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0GYRLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 13:11:08 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] coresight: cosmetic fixes
Date: Sun, 25 Jul 2010 20:05:16 +0300
Message-Id: <1280077520-7538-4-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BIT() macro whenever it is sensible to do so.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/include/asm/hardware/coresight.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index d846051..7ecd793 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -100,10 +100,10 @@
 
 /* ETM status register, "ETM Architecture", 3.3.2 */
 #define ETMR_STATUS		(0x10)
-#define ETMST_OVERFLOW		(1 << 0)
-#define ETMST_PROGBIT		(1 << 1)
-#define ETMST_STARTSTOP		(1 << 2)
-#define ETMST_TRIGGER		(1 << 3)
+#define ETMST_OVERFLOW		BIT(0)
+#define ETMST_PROGBIT		BIT(1)
+#define ETMST_STARTSTOP		BIT(2)
+#define ETMST_TRIGGER		BIT(3)
 
 #define etm_progbit(t)		(etm_readl((t), ETMR_STATUS) & ETMST_PROGBIT)
 #define etm_started(t)		(etm_readl((t), ETMR_STATUS) & ETMST_STARTSTOP)
@@ -111,7 +111,7 @@
 
 #define ETMR_TRACEENCTRL2	0x1c
 #define ETMR_TRACEENCTRL	0x24
-#define ETMTE_INCLEXCL		(1 << 24)
+#define ETMTE_INCLEXCL		BIT(24)
 #define ETMR_TRACEENEVT		0x20
 #define ETMCTRL_OPTS		(ETMCTRL_DO_CPRT | \
 				ETMCTRL_DATA_DO_ADDR | \
@@ -134,12 +134,12 @@
 #define ETBR_CTRL		0x20
 #define ETBR_FORMATTERCTRL	0x304
 #define ETBFF_ENFTC		1
-#define ETBFF_ENFCONT		(1 << 1)
-#define ETBFF_FONFLIN		(1 << 4)
-#define ETBFF_MANUAL_FLUSH	(1 << 6)
-#define ETBFF_TRIGIN		(1 << 8)
-#define ETBFF_TRIGEVT		(1 << 9)
-#define ETBFF_TRIGFL		(1 << 10)
+#define ETBFF_ENFCONT		BIT(1)
+#define ETBFF_FONFLIN		BIT(4)
+#define ETBFF_MANUAL_FLUSH	BIT(6)
+#define ETBFF_TRIGIN		BIT(8)
+#define ETBFF_TRIGEVT		BIT(9)
+#define ETBFF_TRIGFL		BIT(10)
 
 #define etb_writel(t, v, x) \
 	(__raw_writel((v), (t)->etb_regs + (x)))
-- 
1.7.1


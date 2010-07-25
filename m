Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0GYRLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 13:11:16 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:53104 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0GYRLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 13:11:05 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] coresight: add ETM management registers
Date: Sun, 25 Jul 2010 20:05:15 +0300
Message-Id: <1280077520-7538-3-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add notion of ETM OS lock, save and restore registers.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/include/asm/hardware/coresight.h |    8 ++++++--
 arch/arm/kernel/etm.c                     |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 8838be1..d846051 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -36,8 +36,6 @@
 /* CoreSight Component Registers */
 #define CSCR_CLASS	0xff4
 
-#define CSCR_PRSR	0x314
-
 #define UNLOCK_MAGIC	0xc5acce55
 
 /* ETM control register, "ETM Architecture", 3.3.1 */
@@ -120,6 +118,12 @@
 				ETMCTRL_BRANCH_OUTPUT | \
 				ETMCTRL_DO_CONTEXTID)
 
+/* ETM management registers, "ETM Architecture", 3.5.24 */
+#define ETMMR_OSLAR	0x300
+#define ETMMR_OSLSR	0x304
+#define ETMMR_OSSRR	0x308
+#define ETMMR_PDSR	0x314
+
 /* ETB registers, "CoreSight Components TRM", 9.3 */
 #define ETBR_DEPTH		0x04
 #define ETBR_STATUS		0x0c
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 47a38af..d08062b 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -558,7 +558,7 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 	t->etm_portsz = 1;
 
 	etm_unlock(t);
-	ret = etm_readl(t, CSCR_PRSR);
+	ret = etm_readl(t, ETMMR_PDSR);
 
 	t->ncmppairs = etm_readl(t, ETMR_CONFCODE) & 0xf;
 	etm_writel(t, 0x440, ETMR_CTRL);
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0GYRLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 13:11:05 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:40761 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0GYRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 13:11:03 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] coresight: move struct tracectx inside etm driver
Date: Sun, 25 Jul 2010 20:05:14 +0300
Message-Id: <1280077520-7538-2-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is done so as to be able to make use of the coresight components'
registers in assembler code (like omap sleep code). Also, there shouldn't
be any users of this structure outside the etm driver.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/include/asm/hardware/coresight.h |   12 ------------
 arch/arm/kernel/etm.c                     |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index f82b25d..8838be1 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -21,18 +21,6 @@
 #define TRACER_RUNNING		BIT(TRACER_RUNNING_BIT)
 #define TRACER_CYCLE_ACC	BIT(TRACER_CYCLE_ACC_BIT)
 
-struct tracectx {
-	unsigned int	etb_bufsz;
-	void __iomem	*etb_regs;
-	void __iomem	*etm_regs;
-	unsigned long	flags;
-	int		ncmppairs;
-	int		etm_portsz;
-	struct device	*dev;
-	struct clk	*emu_clk;
-	struct mutex	mutex;
-};
-
 #define TRACER_TIMEOUT 10000
 
 #define etm_writel(t, v, x) \
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8277539..47a38af 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -30,6 +30,21 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexander Shishkin");
 
+/*
+ * ETM tracer state
+ */
+struct tracectx {
+	unsigned int	etb_bufsz;
+	void __iomem	*etb_regs;
+	void __iomem	*etm_regs;
+	unsigned long	flags;
+	int		ncmppairs;
+	int		etm_portsz;
+	struct device	*dev;
+	struct clk	*emu_clk;
+	struct mutex	mutex;
+};
+
 static struct tracectx tracer;
 
 static inline bool trace_isrunning(struct tracectx *t)
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1HLI2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:28:09 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:37255 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab1HLI2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:28:04 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/23] mfd/db8500-prcmu: initialize DB8500 PRCMU regs
Date: Fri, 12 Aug 2011 10:27:50 +0200
Message-ID: <1313137670-30683-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

Some clocks may be force enabled when we probe the
driver, but they need to be turned off by default so
we have a known state. We call this the register
initialization function if we need more stuff in
there in the future.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index dcc690e..e2c4a26 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1840,6 +1840,16 @@ void __init prcmu_early_init(void)
 	}
 }
 
+static void __init init_prcm_registers(void)
+{
+	u32 val;
+
+	val = readl(PRCM_A9PL_FORCE_CLKEN);
+	val &= ~(PRCM_A9PL_FORCE_CLKEN_PRCM_A9PL_FORCE_CLKEN |
+		PRCM_A9PL_FORCE_CLKEN_PRCM_A9AXI_FORCE_CLKEN);
+	writel(val, (PRCM_A9PL_FORCE_CLKEN));
+}
+
 /*
  * Power domain switches (ePODs) modeled as regulators for the DB8500 SoC
  */
@@ -2038,6 +2048,8 @@ static int __init db8500_prcmu_probe(struct platform_device *pdev)
 	if (ux500_is_svp())
 		return -ENODEV;
 
+	init_prcm_registers();
+
 	/* Clean up the mailbox interrupts after pre-kernel code. */
 	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
 
-- 
1.7.3.2


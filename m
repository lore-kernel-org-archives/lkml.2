Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2K1Sfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:35:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40807 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2K1Sfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:35:33 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        linus.walleij@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 1/3] mfd: stmpe: Get rid of irq_invert_polarity
Date: Thu, 29 Nov 2012 00:05:20 +0530
Message-Id: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the very first patch, stmpe core driver is using irq_invert_polarity as
part of platform data. But, nobody is actually using it in kernel till now.

Also, this is not something part of hardware specs, but is included to cater
some board mistakes or quirks.

So, better get rid of it. This is earlier discussed here:

https://lkml.org/lkml/2012/11/27/636

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

This is actually V1 of this patch.

 drivers/mfd/stmpe.c       | 7 -------
 include/linux/mfd/stmpe.h | 2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 8b164f3..fece28b 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -960,13 +960,6 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 			else
 				icr |= STMPE_ICR_LSB_HIGH;
 		}
-
-		if (stmpe->pdata->irq_invert_polarity) {
-			if (id == STMPE801_ID)
-				icr ^= STMPE801_REG_SYS_CTRL_INT_HI;
-			else
-				icr ^= STMPE_ICR_LSB_HIGH;
-		}
 	}
 
 	if (stmpe->pdata->autosleep) {
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 15dac79..383ac15 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -190,7 +190,6 @@ struct stmpe_ts_platform_data {
  * @id: device id to distinguish between multiple STMPEs on the same board
  * @blocks: bitmask of blocks to enable (use STMPE_BLOCK_*)
  * @irq_trigger: IRQ trigger to use for the interrupt to the host
- * @irq_invert_polarity: IRQ line is connected with reversed polarity
  * @autosleep: bool to enable/disable stmpe autosleep
  * @autosleep_timeout: inactivity timeout in milliseconds for autosleep
  * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
@@ -207,7 +206,6 @@ struct stmpe_platform_data {
 	unsigned int blocks;
 	int irq_base;
 	unsigned int irq_trigger;
-	bool irq_invert_polarity;
 	bool autosleep;
 	bool irq_over_gpio;
 	int irq_gpio;
-- 
1.7.12.rc2.18.g61b472e


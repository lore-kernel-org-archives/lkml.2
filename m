Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab2ANT67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 14:58:59 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:56271 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756578Ab2ANT65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 14:58:57 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RESEND 1/2] MFD: twl6040-codec: Store mclk configuration
Date: Sat, 14 Jan 2012 20:58:43 +0100
Message-Id: <1326571124-11436-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1326571124-11436-1-git-send-email-peter.ujfalusi@ti.com>
References: <1326571124-11436-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the last used mclk configuration for the PLL.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |    3 +++
 include/linux/mfd/twl6040.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index dda8629..c2088f4 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -282,6 +282,7 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 		/* Default PLL configuration after power up */
 		twl6040->pll = TWL6040_SYSCLK_SEL_LPPLL;
 		twl6040->sysclk = 19200000;
+		twl6040->mclk = 32768;
 	} else {
 		/* already powered-down */
 		if (!twl6040->power_count) {
@@ -305,6 +306,7 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			twl6040_power_down(twl6040);
 		}
 		twl6040->sysclk = 0;
+		twl6040->mclk = 0;
 	}
 
 out:
@@ -421,6 +423,7 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 	}
 
 	twl6040->sysclk = freq_out;
+	twl6040->mclk = freq_in;
 	twl6040->pll = pll_id;
 
 pll_out:
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 2463c261..9bc9ac6 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -187,8 +187,10 @@ struct twl6040 {
 	int rev;
 	u8 vibra_ctrl_cache[2];
 
+	/* PLL configuration */
 	int pll;
 	unsigned int sysclk;
+	unsigned int mclk;
 
 	unsigned int irq;
 	unsigned int irq_base;
-- 
1.7.8.3


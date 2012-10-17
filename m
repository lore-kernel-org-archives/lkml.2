Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2JQGTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:19:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34064 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2JQGTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:19:04 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: sbkim73@samsung.com, sameo@linux.intel.com, patches@linaro.org
Subject: [PATCH] MFD: SEC: Fix reg_offset for interrupt registers
Date: Wed, 17 Oct 2012 11:48:55 +0530
Message-Id: <1350454735-17697-1-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg_offset is offset of the status/mask registers. Now, since status_base
and mask_base are pointing to corresponding first registers, reg_offset
should start from 0 otheriwse regmap_add_irq_chip will fail during probe.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
It is based on Samuel's for-next-merge branch of mfd-2.6 tree. 

 drivers/mfd/sec-irq.c |  102 ++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index c901fa5..0dd84e9 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -24,67 +24,67 @@
 
 static struct regmap_irq s2mps11_irqs[] = {
 	[S2MPS11_IRQ_PWRONF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_PWRONF_MASK,
 	},
 	[S2MPS11_IRQ_PWRONR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_PWRONR_MASK,
 	},
 	[S2MPS11_IRQ_JIGONBF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_JIGONBF_MASK,
 	},
 	[S2MPS11_IRQ_JIGONBR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_JIGONBR_MASK,
 	},
 	[S2MPS11_IRQ_ACOKBF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_ACOKBF_MASK,
 	},
 	[S2MPS11_IRQ_ACOKBR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_ACOKBR_MASK,
 	},
 	[S2MPS11_IRQ_PWRON1S] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_PWRON1S_MASK,
 	},
 	[S2MPS11_IRQ_MRB] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_MRB_MASK,
 	},
 	[S2MPS11_IRQ_RTC60S] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S2MPS11_IRQ_RTC60S_MASK,
 	},
 	[S2MPS11_IRQ_RTCA1] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S2MPS11_IRQ_RTCA1_MASK,
 	},
 	[S2MPS11_IRQ_RTCA2] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S2MPS11_IRQ_RTCA2_MASK,
 	},
 	[S2MPS11_IRQ_SMPL] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S2MPS11_IRQ_SMPL_MASK,
 	},
 	[S2MPS11_IRQ_RTC1S] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S2MPS11_IRQ_RTC1S_MASK,
 	},
 	[S2MPS11_IRQ_WTSR] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S2MPS11_IRQ_WTSR_MASK,
 	},
 	[S2MPS11_IRQ_INT120C] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S2MPS11_IRQ_INT120C_MASK,
 	},
 	[S2MPS11_IRQ_INT140C] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S2MPS11_IRQ_INT140C_MASK,
 	},
 };
@@ -92,146 +92,146 @@ static struct regmap_irq s2mps11_irqs[] = {
 
 static struct regmap_irq s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8767_IRQ_PWRR_MASK,
 	},
 	[S5M8767_IRQ_PWRF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8767_IRQ_PWRF_MASK,
 	},
 	[S5M8767_IRQ_PWR1S] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8767_IRQ_PWR1S_MASK,
 	},
 	[S5M8767_IRQ_JIGR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8767_IRQ_JIGR_MASK,
 	},
 	[S5M8767_IRQ_JIGF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8767_IRQ_JIGF_MASK,
 	},
 	[S5M8767_IRQ_LOWBAT2] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8767_IRQ_LOWBAT2_MASK,
 	},
 	[S5M8767_IRQ_LOWBAT1] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8767_IRQ_LOWBAT1_MASK,
 	},
 	[S5M8767_IRQ_MRB] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_MRB_MASK,
 	},
 	[S5M8767_IRQ_DVSOK2] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_DVSOK2_MASK,
 	},
 	[S5M8767_IRQ_DVSOK3] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_DVSOK3_MASK,
 	},
 	[S5M8767_IRQ_DVSOK4] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_DVSOK4_MASK,
 	},
 	[S5M8767_IRQ_RTC60S] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_RTC60S_MASK,
 	},
 	[S5M8767_IRQ_RTCA1] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_RTCA1_MASK,
 	},
 	[S5M8767_IRQ_RTCA2] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_RTCA2_MASK,
 	},
 	[S5M8767_IRQ_SMPL] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_SMPL_MASK,
 	},
 	[S5M8767_IRQ_RTC1S] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_RTC1S_MASK,
 	},
 	[S5M8767_IRQ_WTSR] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_WTSR_MASK,
 	},
 };
 
 static struct regmap_irq s5m8763_irqs[] = {
 	[S5M8763_IRQ_DCINF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8763_IRQ_DCINF_MASK,
 	},
 	[S5M8763_IRQ_DCINR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8763_IRQ_DCINR_MASK,
 	},
 	[S5M8763_IRQ_JIGF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8763_IRQ_JIGF_MASK,
 	},
 	[S5M8763_IRQ_JIGR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8763_IRQ_JIGR_MASK,
 	},
 	[S5M8763_IRQ_PWRONF] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8763_IRQ_PWRONF_MASK,
 	},
 	[S5M8763_IRQ_PWRONR] = {
-		.reg_offset = 1,
+		.reg_offset = 0,
 		.mask = S5M8763_IRQ_PWRONR_MASK,
 	},
 	[S5M8763_IRQ_WTSREVNT] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_WTSREVNT_MASK,
 	},
 	[S5M8763_IRQ_SMPLEVNT] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_SMPLEVNT_MASK,
 	},
 	[S5M8763_IRQ_ALARM1] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_ALARM1_MASK,
 	},
 	[S5M8763_IRQ_ALARM0] = {
-		.reg_offset = 2,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_ALARM0_MASK,
 	},
 	[S5M8763_IRQ_ONKEY1S] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_ONKEY1S_MASK,
 	},
 	[S5M8763_IRQ_TOPOFFR] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_TOPOFFR_MASK,
 	},
 	[S5M8763_IRQ_DCINOVPR] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_DCINOVPR_MASK,
 	},
 	[S5M8763_IRQ_CHGRSTF] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_CHGRSTF_MASK,
 	},
 	[S5M8763_IRQ_DONER] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_DONER_MASK,
 	},
 	[S5M8763_IRQ_CHGFAULT] = {
-		.reg_offset = 3,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_CHGFAULT_MASK,
 	},
 	[S5M8763_IRQ_LOBAT1] = {
-		.reg_offset = 4,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_LOBAT1_MASK,
 	},
 	[S5M8763_IRQ_LOBAT2] = {
-		.reg_offset = 4,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_LOBAT2_MASK,
 	},
 };
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2K2GmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:42:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58994 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab2K2GmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:42:22 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] mfd: tps65910: fix wrong ack_base register
Thread-Topic: [PATCH 3/3] mfd: tps65910: fix wrong ack_base register
Thread-Index: Ac3N/Kj0BSwq9Aj4S6uJVNm8ZqImOg==
Date: Thu, 29 Nov 2012 06:42:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6418F154@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The interrupt status registers of TPS65910/1 should be cleared
 when the associated interrupt event occurs.
 This work is done in the regmap irq thread - using 'ack_base' register.
 The ACK registers should be fixed as status register, not mask registers.

 This patch fixes the infinite interrupt event problem by clearing
 interrupt status registers.

 Tested on the AM3517 Craneboard.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/mfd/tps65910.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index ca37833..fdb3027 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -211,7 +211,7 @@ static struct regmap_irq_chip tps65911_irq_chip = {
 	.irq_reg_stride = 2,
 	.status_base = TPS65910_INT_STS,
 	.mask_base = TPS65910_INT_MSK,
-	.ack_base = TPS65910_INT_MSK,
+	.ack_base = TPS65910_INT_STS,
 };
 
 static struct regmap_irq_chip tps65910_irq_chip = {
@@ -222,7 +222,7 @@ static struct regmap_irq_chip tps65910_irq_chip = {
 	.irq_reg_stride = 2,
 	.status_base = TPS65910_INT_STS,
 	.mask_base = TPS65910_INT_MSK,
-	.ack_base = TPS65910_INT_MSK,
+	.ack_base = TPS65910_INT_STS,
 };
 
 static int tps65910_irq_init(struct tps65910 *tps65910, int irq,
-- 
1.7.9.5

Best Regards,
Milo



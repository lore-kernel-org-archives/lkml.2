Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab2FNFzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 01:55:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39834 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2FNFzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 01:55:33 -0400
Message-ID: <1339653325.6769.1.camel@phoenix>
Subject: [PATCH] regulator: tps65023: Fix mask for LDOs output voltage
 select control
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 14 Jun 2012 13:55:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:
The LDO_CTRL registers are used to set the output voltage of LDO1 and LDO2.
LDO_CTRL[7] and LDO_CTRL[3] are reserved and should always be written to 0.

Thus the mask for TPS65023_LDO_1 and TPS65023_LDO_2 should be 0x07 and 0x70
respectively.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index df8b70d..6fab428 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -71,7 +71,7 @@
 
 /* LDO_CTRL bitfields */
 #define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
-#define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0x0F << ((ldo_id)*4))
+#define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0x07 << ((ldo_id)*4))
 
 /* Number of step-down converters available */
 #define TPS65023_NUM_DCDC		3
-- 
1.7.9.5




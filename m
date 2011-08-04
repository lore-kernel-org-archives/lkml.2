Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1HDNjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 09:39:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51566 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1HDNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 09:39:32 -0400
Message-ID: <4E3AA111.1030002@gmail.com>
Date: Thu, 04 Aug 2011 15:39:29 +0200
From: Marcus Folkesson <marcus.folkesson@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        bernd@petrovitsch.priv.at
Subject: Re: [PATCH 1/4] regulator: tps65023: Fixes i2c configuration issues
References: <marcus.folkesson@gmail.com> <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com> <1312457632-27075-2-git-send-email-marcus.folkesson@gmail.com> <20110804121331.GB9959@opensource.wolfsonmicro.com>
In-Reply-To: <20110804121331.GB9959@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 02:13 PM, Mark Brown wrote:

> On Thu, Aug 04, 2011 at 01:33:49PM +0200, Marcus Folkesson wrote:
>> Allow i2c core voltage adjustments by clearing CORE ADJ Allowed bit in CTRL2
>>
>> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Changes:
-#define TPS65023_REG_CTRL2_DCDC1	BIT(2)
+#define TPS65023_REG_CTRL2_DCDC1	BIT(1)

Thank you Bernd Petrovitsch for mention it!

Best regards
Marcus

>From 20c5ce4865050edd6da6e0cfb400cc858c7483dd Mon Sep 17 00:00:00 2001
From: Marcus Folkesson <marcus.folkesson@gmail.com>
Date: Tue, 2 Aug 2011 10:22:34 +0200
Subject: [PATCH 1/4] regulator: tps65023: Fixes i2c configuration issues

Allow i2c core voltage adjustments by clearing CORE ADJ Allowed bit in CTRL2

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 701a590..a81abd4 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -63,6 +63,13 @@
 #define TPS65023_REG_CTRL_LDO2_EN	BIT(2)
 #define TPS65023_REG_CTRL_LDO1_EN	BIT(1)
 
+/* REG_CTRL2 bitfields */
+#define TPS65023_REG_CTRL2_GO		BIT(7)
+#define TPS65023_REG_CTRL2_CORE_ADJ	BIT(6)
+#define TPS65023_REG_CTRL2_DCDC2	BIT(2)
+#define TPS65023_REG_CTRL2_DCDC1	BIT(1)
+#define TPS65023_REG_CTRL2_DCDC3	BIT(0)
+
 /* LDO_CTRL bitfields */
 #define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
 #define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0xF0 >> ((ldo_id)*4))
@@ -475,6 +482,10 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, tps);
 
+	/* Enable setting output voltage by I2C */
+	tps_65023_clear_bits(tps, TPS65023_REG_CON_CTRL2,
+						TPS65023_REG_CTRL2_CORE_ADJ);
+
 	return 0;
 
  fail:
-- 
1.7.4.1




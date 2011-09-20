Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1ITBws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 21:52:48 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:63222 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1ITBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 21:52:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1316483565!39057611!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tps65023-regulator: remove duplicate REG_CTRL2 defines
Date: Mon, 19 Sep 2011 18:51:39 -0700
User-Agent: KMail/1.9.9
CC: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109191851.40743.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two sets of defines for the REG_CTRL2 bitfields and one
of them has TPS65023_REG_CTRL2_DCDC1 defined incorrectly. Remove
the duplicates and leave the correct one for TPS65023_REG_CTRL2_DCDC1.

This fixes the following sparse warnings:

drivers/regulator/tps65023-regulator.c:77:9: warning: preprocessor token TPS65023_REG_CTRL2_DCDC1 redefined
drivers/regulator/tps65023-regulator.c:70:9: this was the original definition

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>

---

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index b02c670..9fb4c7b 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -67,13 +67,6 @@
 #define TPS65023_REG_CTRL2_GO		BIT(7)
 #define TPS65023_REG_CTRL2_CORE_ADJ	BIT(6)
 #define TPS65023_REG_CTRL2_DCDC2	BIT(2)
-#define TPS65023_REG_CTRL2_DCDC1	BIT(2)
-#define TPS65023_REG_CTRL2_DCDC3	BIT(0)
-
-/* REG_CTRL2 bitfields */
-#define TPS65023_REG_CTRL2_GO		BIT(7)
-#define TPS65023_REG_CTRL2_CORE_ADJ	BIT(6)
-#define TPS65023_REG_CTRL2_DCDC2	BIT(2)
 #define TPS65023_REG_CTRL2_DCDC1	BIT(1)
 #define TPS65023_REG_CTRL2_DCDC3	BIT(0)
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2GXI2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:28:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19281 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2GXI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:28:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jul 2012 01:24:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps6586x: correct vin pin for sm0/sm1/sm2
Date: Tue, 24 Jul 2012 13:48:00 +0530
Message-ID: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per datasheet, the vin pin for the regulator is named
as vin_sm0, vin_sm1, vin_sm2 for sm0, sm1 and sm2 respectively.

Correcting the names in driver and documentation to match with
datasheet.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reported-by: Stephen Warren <swarren@nvidia.com>
---
 .../devicetree/bindings/regulator/tps6586x.txt     |   12 ++++++------
 drivers/regulator/tps6586x-regulator.c             |    8 +++++---
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
index d156e1b..da80c2a 100644
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
+++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -9,9 +9,9 @@ Required properties:
 - regulators: list of regulators provided by this controller, must have
   property "regulator-compatible" to match their hardware counterparts:
   sm[0-2], ldo[0-9] and ldo_rtc
-- sm0-supply: The input supply for the SM0.
-- sm1-supply: The input supply for the SM1.
-- sm2-supply: The input supply for the SM2.
+- vin-sm0-supply: The input supply for the SM0.
+- vin-sm1-supply: The input supply for the SM1.
+- vin-sm2-supply: The input supply for the SM2.
 - vinldo01-supply: The input supply for the LDO1 and LDO2
 - vinldo23-supply: The input supply for the LDO2 and LDO3
 - vinldo4-supply: The input supply for the LDO4
@@ -30,9 +30,9 @@ Example:
 		#gpio-cells = <2>;
 		gpio-controller;
 
-		sm0-supply = <&some_reg>;
-		sm1-supply = <&some_reg>;
-		sm2-supply = <&some_reg>;
+		vin-sm0-supply = <&some_reg>;
+		vin-sm1-supply = <&some_reg>;
+		vin-sm2-supply = <&some_reg>;
 		vinldo01-supply = <...>;
 		vinldo23-supply = <...>;
 		vinldo4-supply = <...>;
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e6da90a..19241fc 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -240,14 +240,16 @@ static struct tps6586x_regulator tps6586x_regulator[] = {
 	TPS6586X_LDO(LDO_9, "vinldo9", ldo, SUPPLYV6, 3, 3, ENE, 7, ENE, 7),
 	TPS6586X_LDO(LDO_RTC, NULL, ldo, SUPPLYV4, 3, 3, V4, 7, V4, 7),
 	TPS6586X_LDO(LDO_1, "vinldo01", dvm, SUPPLYV1, 0, 5, ENC, 1, END, 1),
-	TPS6586X_LDO(SM_2, "sm2", sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
+	TPS6586X_LDO(SM_2, "vin-sm2", sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
 
 	TPS6586X_DVM(LDO_2, "vinldo23", dvm, LDO2BV1, 0, 5, ENA, 3,
 					ENB, 3, VCC2, 6),
 	TPS6586X_DVM(LDO_4, "vinldo4", ldo4, LDO4V1, 0, 5, ENC, 3,
 					END, 3, VCC1, 6),
-	TPS6586X_DVM(SM_0, "sm0", dvm, SM0V1, 0, 5, ENA, 1, ENB, 1, VCC1, 2),
-	TPS6586X_DVM(SM_1, "sm1", dvm, SM1V1, 0, 5, ENA, 0, ENB, 0, VCC1, 0),
+	TPS6586X_DVM(SM_0, "vin-sm0", dvm, SM0V1, 0, 5, ENA, 1,
+					ENB, 1, VCC1, 2),
+	TPS6586X_DVM(SM_1, "vin-sm1", dvm, SM1V1, 0, 5, ENA, 0,
+					ENB, 0, VCC1, 0),
 };
 
 /*
-- 
1.7.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab2F1KU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:20:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54689 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab2F1KUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:20:54 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/2] mfd: tps65910: add device-tree entry to enable external 32-kHz oscillator
Date: Thu, 28 Jun 2012 12:20:22 +0200
Message-Id: <1340878822-28444-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1340878822-28444-1-git-send-email-jhovold@gmail.com>
References: <1340878822-28444-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree entry to enable external 32-kHz crystal oscillator
input.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 Documentation/devicetree/bindings/mfd/tps65910.txt |    4 +++-
 drivers/mfd/tps65910.c                             |    3 +++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt
index 645f5eaa..0f5d9b7 100644
--- a/Documentation/devicetree/bindings/mfd/tps65910.txt
+++ b/Documentation/devicetree/bindings/mfd/tps65910.txt
@@ -29,6 +29,8 @@ Optional properties:
   comparator. (see VMBCH_VSEL in TPS65910 datasheet)
 - ti,vmbch2-threshold: (tps65911) main battery discharged threshold
   comparator. (see VMBCH_VSEL in TPS65910 datasheet)
+- ti,en-ck32k-xtal: enable external 32-kHz crystal oscillator (see CK32K_CTRL
+  in TPS6591X datasheet)
 - ti,en-gpio-sleep: enable sleep control for gpios
   There should be 9 entries here, one for each gpio.
 
@@ -53,7 +55,7 @@ Example:
 
 		ti,vmbch-threshold = 0;
 		ti,vmbch2-threshold = 0;
-
+		ti,en-ck32k-xtal;
 		ti,en-gpio-sleep = <0 0 1 0 0 0 0 0 0>;
 
 		regulators {
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index b0526b7d..3f27ea1 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -194,6 +194,9 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 	else if (*chip_id == TPS65911)
 		dev_warn(&client->dev, "VMBCH2-Threshold not specified");
 
+	prop = of_property_read_bool(np, "ti,en-ck32k-xtal");
+	board_info->en_ck32k_xtal = prop;
+
 	board_info->irq = client->irq;
 	board_info->irq_base = -1;
 
-- 
1.7.8.6


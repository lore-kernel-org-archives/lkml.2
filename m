Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2HNWKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:10:18 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:47411 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2HNWKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:10:14 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: rnayak@ti.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH] regulator: twl-regulator: fix up VINTANA1/VINTANA2
Date: Wed, 15 Aug 2012 01:10:04 +0300
Message-Id: <1344982205-21186-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems commit 2098e95ce9bb039ff2e7bf836df358d18a176139 (regulator: twl:
adapt twl-regulator driver to dt) accidentally deleted VINTANA1. Also
the same commit defines VINTANA2 twice with TWL4030_ADJUSTABLE_LDO and
TWL4030_FIXED_LDO. This patch changes the fixed one to be VINTANA1.

I noticed this when auditing my N900 boot logs. I could not notice any
change in device behaviour, though, except that the boot logs are now
like before:

	...
	[    0.282928] VDAC: 1800 mV normal standby
	[    0.284027] VCSI: 1800 mV normal standby
	[    0.285400] VINTANA1: 1500 mV normal standby
	[    0.286865] VINTANA2: 2750 mV normal standby
	[    0.288208] VINTDIG: 1500 mV normal standby
	[    0.289978] VSDI_CSI: 1800 mV normal standby
	...

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/regulator/twl-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 242fe90..8168271 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1037,7 +1037,7 @@ TWL6025_ADJUSTABLE_LDO(LDO7, 0x74, 1000, 3300);
 TWL6025_ADJUSTABLE_LDO(LDO6, 0x60, 1000, 3300);
 TWL6025_ADJUSTABLE_LDO(LDOLN, 0x64, 1000, 3300);
 TWL6025_ADJUSTABLE_LDO(LDOUSB, 0x70, 1000, 3300);
-TWL4030_FIXED_LDO(VINTANA2, 0x3f, 1500, 11, 100, 0x08);
+TWL4030_FIXED_LDO(VINTANA1, 0x3f, 1500, 11, 100, 0x08);
 TWL4030_FIXED_LDO(VINTDIG, 0x47, 1500, 13, 100, 0x08);
 TWL4030_FIXED_LDO(VUSB1V5, 0x71, 1500, 17, 100, 0x08);
 TWL4030_FIXED_LDO(VUSB1V8, 0x74, 1800, 18, 100, 0x08);
@@ -1117,7 +1117,7 @@ static const struct of_device_id twl_of_match[] __devinitconst = {
 	TWL6025_OF_MATCH("ti,twl6025-ldo6", LDO6),
 	TWL6025_OF_MATCH("ti,twl6025-ldoln", LDOLN),
 	TWL6025_OF_MATCH("ti,twl6025-ldousb", LDOUSB),
-	TWLFIXED_OF_MATCH("ti,twl4030-vintana2", VINTANA2),
+	TWLFIXED_OF_MATCH("ti,twl4030-vintana1", VINTANA1),
 	TWLFIXED_OF_MATCH("ti,twl4030-vintdig", VINTDIG),
 	TWLFIXED_OF_MATCH("ti,twl4030-vusb1v5", VUSB1V5),
 	TWLFIXED_OF_MATCH("ti,twl4030-vusb1v8", VUSB1V8),
-- 
1.7.2.5


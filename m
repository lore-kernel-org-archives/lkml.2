Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2ILXlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:41:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab2ILXk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:40:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 53/85] regulator: twl-regulator: fix up VINTANA1/VINTANA2
Date: Wed, 12 Sep 2012 16:36:36 -0700
Message-Id: <20120912233547.290145360@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit 908d6d52928a7f2a4b317aac47542c5fbef43d88 upstream.

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
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/twl-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1085,7 +1085,7 @@ TWL6025_ADJUSTABLE_LDO(LDO7, 0x74, 1000,
 TWL6025_ADJUSTABLE_LDO(LDO6, 0x60, 1000, 3300);
 TWL6025_ADJUSTABLE_LDO(LDOLN, 0x64, 1000, 3300);
 TWL6025_ADJUSTABLE_LDO(LDOUSB, 0x70, 1000, 3300);
-TWL4030_FIXED_LDO(VINTANA2, 0x3f, 1500, 11, 100, 0x08);
+TWL4030_FIXED_LDO(VINTANA1, 0x3f, 1500, 11, 100, 0x08);
 TWL4030_FIXED_LDO(VINTDIG, 0x47, 1500, 13, 100, 0x08);
 TWL4030_FIXED_LDO(VUSB1V5, 0x71, 1500, 17, 100, 0x08);
 TWL4030_FIXED_LDO(VUSB1V8, 0x74, 1800, 18, 100, 0x08);
@@ -1166,7 +1166,7 @@ static const struct of_device_id twl_of_
 	TWL6025_OF_MATCH("ti,twl6025-ldo6", LDO6),
 	TWL6025_OF_MATCH("ti,twl6025-ldoln", LDOLN),
 	TWL6025_OF_MATCH("ti,twl6025-ldousb", LDOUSB),
-	TWLFIXED_OF_MATCH("ti,twl4030-vintana2", VINTANA2),
+	TWLFIXED_OF_MATCH("ti,twl4030-vintana1", VINTANA1),
 	TWLFIXED_OF_MATCH("ti,twl4030-vintdig", VINTDIG),
 	TWLFIXED_OF_MATCH("ti,twl4030-vusb1v5", VUSB1V5),
 	TWLFIXED_OF_MATCH("ti,twl4030-vusb1v8", VUSB1V8),



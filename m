Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1HLDfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:35:46 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:40117 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1HLDfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=kylemanna.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=
	kylemanna.com; b=dbfG8gL6mJj3pQbUsrUxDdj3qITu03u2nZaAJlu304M0kze
	YF19pajgiRdrTSbgMCb7nX0LcmUb0EnvU8bkTEgziLSuREEjcA7qFqUEu+uwWa8/
	40z4uLAV5evRgqZjTyTLkRe4NOeXBq7OWFhtNusCJ/J48mMog4VXbJthiXsk=
From: Kyle Manna <kyle@kylemanna.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Keerthy <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyle Manna <kyle@kylemanna.com>
Subject: [PATCH v2 4/4] arm: BeagleBoard: add support for the twl4030-madc
Date: Thu, 11 Aug 2011 22:33:15 -0500
Message-Id: <1313119995-15382-5-git-send-email-kyle@kylemanna.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
References: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
 <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kyle Manna <kyle@kylemanna.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 3ae16b4..9cc9fa9 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -378,7 +378,8 @@ static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
 static int __init omap3_beagle_i2c_init(void)
 {
 	omap3_pmic_get_config(&beagle_twldata,
-			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO,
+			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC |
+			TWL_COMMON_PDATA_AUDIO,
 			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
 
 	beagle_twldata.vpll2->constraints.name = "VDVI";
@@ -456,9 +457,15 @@ static void __init omap3_beagle_init_irq(void)
 	omap3_init_irq();
 }
 
+static struct platform_device madc_hwmon = {
+	.name	= "twl4030_madc_hwmon",
+	.id	= -1,
+};
+
 static struct platform_device *omap3_beagle_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
+	&madc_hwmon,
 };
 
 static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
-- 
1.7.4.1


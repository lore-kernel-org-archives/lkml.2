Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1DSQmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:42:39 -0400
Received: from pequod.mess.org ([188.220.58.213]:51173 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab1DSQmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:42:38 -0400
Date: Tue, 19 Apr 2011 17:41:57 +0100
From: Sean Young <sean@mess.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Robin Becker <robin@reportlab.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm: mach-kirkwood: leds on eSATA SheevaPlug regression
Message-ID: <20110419164157.GA7373@pequod.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression in 2.6.39-rc2 on eSATA SheevaPlug where the leds are no
longer probed correctly.

[    6.188278] leds-gpio: probe of leds-gpio failed with error -22

Also add missing blue led which was incorrectly wired to the green led.

Tested on both SheevaPlug models (original and eSATA).

Signed-off-by: Robin Becker <robin@reportlab.com>
Signed-off-by: Sean Young <sean@mess.org>
--- 
diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
index 17de0bf..e6b864a 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -65,6 +65,12 @@ static struct gpio_led sheevaplug_led_pins[] = {
 	},
 	{
 		.name			= "plug:green:health",
+		.default_trigger	= "none",
+		.gpio			= 48,
+		.active_low		= 1,
+	},
+	{
+		.name			= "plug:blue:health",
 		.default_trigger	= "default-on",
 		.gpio			= 49,
 		.active_low		= 1,
@@ -87,15 +93,18 @@ static struct platform_device sheevaplug_leds = {
 static unsigned int sheevaplug_mpp_config[] __initdata = {
 	MPP29_GPIO,	/* USB Power Enable */
 	MPP46_GPIO,	/* LED Red */
-	MPP49_GPIO,	/* LED */
+	MPP48_GPIO,	/* LED Green */
+	MPP49_GPIO,	/* LED Blue */
 	0
 };
 
 static unsigned int sheeva_esata_mpp_config[] __initdata = {
 	MPP29_GPIO,	/* USB Power Enable */
 	MPP44_GPIO,	/* SD Write Protect */
+	MPP46_GPIO,	/* LED Red */
 	MPP47_GPIO,	/* SD Card Detect */
-	MPP49_GPIO,	/* LED Green */
+	MPP48_GPIO,	/* LED Green */
+	MPP49_GPIO,	/* LED Blue */
 	0
 };
 

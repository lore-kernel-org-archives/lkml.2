Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1CIN1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:27:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1CIN1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:27:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SDdw6FkfVh+v8t7ZW627I8vojZ810sHU8F7IqKDmXtwdqwtl7EPcMWP6QKRQATeUFd
         9J4oEZybNFCWMnMQ4IBqgNUTVNuf3sSh3VtIhspTliy5OpJtxncdz/48lbh1ECWZiKY9
         tctVf8yw22o3JOGPLVXWDoFFTgB7fTauaBppI=
From: Robin Becker <replabrobin@gmail.com>
To: kernel@wantstofly.org, nico@fluxnic.net, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: replabrobin <robin@reportlab.com>
Subject: [PATCH] stable: sheevaplug-setup.c fix LED color name and add support for second LED This is a patch to the sheevaplug-setup.c file that fixes the color name of the existing health LED. That LED gpio 49 is green when off and blue when on. The patch also adds support for the second LED that is green when off and red when on. Signed-off-by: Robin Becker <robin@reportlab.com>
Date: Wed,  9 Mar 2011 13:27:19 +0000
Message-Id: <1299677239-3352-1-git-send-email-robin@reportlab.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: replabrobin <robin@reportlab.com>

---
 arch/arm/mach-kirkwood/sheevaplug-setup.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
index d2eec35..40441da 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -58,7 +58,13 @@ static struct mvsdio_platform_data sheeva_esata_mvsdio_data = {
 
 static struct gpio_led sheevaplug_led_pins[] = {
 	{
-		.name			= "plug:green:health",
+		.name			= "plug:red:misc",
+		.default_trigger	= "none",
+		.gpio			= 46,
+		.active_low		= 1,
+	},
+	{
+		.name			= "plug:blue:health",
 		.default_trigger	= "default-on",
 		.gpio			= 49,
 		.active_low		= 1,
@@ -80,13 +86,15 @@ static struct platform_device sheevaplug_leds = {
 
 static unsigned int sheevaplug_mpp_config[] __initdata = {
 	MPP29_GPIO,	/* USB Power Enable */
-	MPP49_GPIO,	/* LED */
+	MPP46_GPIO,	/* RED LED */
+	MPP49_GPIO,	/* BLUE LED */
 	0
 };
 
 static unsigned int sheeva_esata_mpp_config[] __initdata = {
 	MPP29_GPIO,	/* USB Power Enable */
 	MPP44_GPIO,	/* SD Write Protect */
+	MPP46_GPIO,	/* RED LED */
 	MPP47_GPIO,	/* SD Card Detect */
 	MPP49_GPIO,	/* LED Green */
 	0
-- 
1.7.4.1


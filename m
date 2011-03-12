Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1CLPdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 10:33:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63432 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1CLPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 10:33:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CYmqZveojz5IJfWlacH0CQCYsWD7tjOZXGw0GsF5GMoQGFX8MzI1oZ2ajQ58BXRJzv
         2qU8r2VxmRxQb2MN35s7Ilb6o3xG/3LIEdUCbEFm+gm7t4feRwPLcTAeAfyR4efGSgTo
         W/PpE9uNdQq1d4/w5yS5DeMkDQHeWL+j2EFKk=
From: Robin Becker <replabrobin@gmail.com>
To: Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Robin Becker <replabrobin@gmail.com>, Robin Becker <robin@reportlab.com>
Subject: [PATCH] arm: mach-kirkwood: add led in sheevaplug-setup.c
Date: Sat, 12 Mar 2011 15:32:45 +0000
Message-Id: <1299943965-8626-1-git-send-email-robin@reportlab.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Becker <replabrobin@gmail.com>

This patch adds a second, red, led for the standard sheevaplug.
The sheeva_esata mpp config is left unchanged.

Tested on a standard sheevaplug

Signed-off-by: Robin Becker <robin@reportlab.com>
---
 arch/arm/mach-kirkwood/sheevaplug-setup.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
index d2eec35..247aa92 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -58,6 +58,12 @@ static struct mvsdio_platform_data sheeva_esata_mvsdio_data = {
 
 static struct gpio_led sheevaplug_led_pins[] = {
 	{
+		.name			= "plug:red:misc",
+		.default_trigger	= "none",
+		.gpio			= 46,
+		.active_low		= 1,
+	},
+	{
 		.name			= "plug:green:health",
 		.default_trigger	= "default-on",
 		.gpio			= 49,
@@ -80,6 +86,7 @@ static struct platform_device sheevaplug_leds = {
 
 static unsigned int sheevaplug_mpp_config[] __initdata = {
 	MPP29_GPIO,	/* USB Power Enable */
+	MPP46_GPIO,	/* LED Red */
 	MPP49_GPIO,	/* LED */
 	0
 };
-- 
1.7.4.1


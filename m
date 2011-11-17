Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1KSL3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:29:48 -0500
Received: from www17.your-server.de ([213.133.104.17]:41077 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab1KSL3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:29:40 -0500
Subject: [PATCH] MIPS: ath79: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.273.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/mips/ath79/dev-gpio-buttons.c b/arch/mips/ath79/dev-gpio-buttons.c
--- a/arch/mips/ath79/dev-gpio-buttons.c 2011-11-07 19:37:22.626233914 +0100
+++ b/arch/mips/ath79/dev-gpio-buttons.c 2011-11-08 11:02:34.088856260 +0100
@@ -25,12 +25,10 @@ void __init ath79_register_gpio_keys_pol
 	struct gpio_keys_button *p;
 	int err;
 
-	p = kmalloc(nbuttons * sizeof(*p), GFP_KERNEL);
+	p = kmemdup(buttons, nbuttons * sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return;
 
-	memcpy(p, buttons, nbuttons * sizeof(*p));
-
 	pdev = platform_device_alloc("gpio-keys-polled", id);
 	if (!pdev)
 		goto err_free_buttons;
diff -u -p a/arch/mips/ath79/dev-leds-gpio.c b/arch/mips/ath79/dev-leds-gpio.c
--- a/arch/mips/ath79/dev-leds-gpio.c 2011-11-07 19:37:22.626233914 +0100
+++ b/arch/mips/ath79/dev-leds-gpio.c 2011-11-08 11:02:33.992188296 +0100
@@ -24,12 +24,10 @@ void __init ath79_register_leds_gpio(int
 	struct gpio_led *p;
 	int err;
 
-	p = kmalloc(num_leds * sizeof(*p), GFP_KERNEL);
+	p = kmemdup(leds, num_leds * sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return;
 
-	memcpy(p, leds, num_leds * sizeof(*p));
-
 	pdev = platform_device_alloc("leds-gpio", id);
 	if (!pdev)
 		goto err_free_leds;

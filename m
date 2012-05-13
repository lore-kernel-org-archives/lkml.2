Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2EMQHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:07:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39930 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab2EMQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:45 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 1/7] HID: Do not switch default values in EXPERT mode
Date: Sun, 13 May 2012 18:07:04 +0200
Message-Id: <1336925230-2853-2-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expert mode was designed to toggle visibility of options and not to
change their behavior. If a user wants to tweak a single value and
enables EXPERT mode to do this, he will have several unexpected
side effects when other subsystems toggle their default values based
on EXPERT mode. This makes EXPERT pretty useless.

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/hid/Kconfig |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index ffddcba..ce21ea1 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -63,7 +63,7 @@ menu "Special HID drivers"
 config HID_A4TECH
 	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
@@ -84,7 +84,7 @@ config HID_ACRUX_FF
 config HID_APPLE
 	tristate "Apple {i,Power,Mac}Books" if EXPERT
 	depends on (USB_HID || BT_HIDP)
-	default !EXPERT
+	default y
 	---help---
 	Support for some Apple devices which less or more break
 	HID specification.
@@ -95,21 +95,21 @@ config HID_APPLE
 config HID_BELKIN
 	tristate "Belkin Flip KVM and Wireless keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
 config HID_CHERRY
 	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
 	tristate "Chicony Tactical pad" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Chicony Tactical pad.
 
@@ -131,7 +131,7 @@ config HID_PRODIKEYS
 config HID_CYPRESS
 	tristate "Cypress mouse and barcode readers" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for cypress mouse and barcode readers.
 
@@ -173,7 +173,7 @@ config HID_ELECOM
 config HID_EZKEY
 	tristate "Ezkey BTC 8193 keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
 
@@ -236,7 +236,7 @@ config HID_TWINHAN
 config HID_KENSINGTON
 	tristate "Kensington Slimblade Trackball" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Kensington Slimblade Trackball.
 
@@ -249,7 +249,7 @@ config HID_LCPOWER
 config HID_LOGITECH
 	tristate "Logitech devices" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
 
@@ -325,14 +325,14 @@ config HID_MAGICMOUSE
 config HID_MICROSOFT
 	tristate "Microsoft non-fully HID-compliant devices" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
 config HID_MONTEREY
 	tristate "Monterey Genius KB29E keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default y
 	---help---
 	Support for Monterey Genius KB29E.
 
@@ -438,7 +438,7 @@ config HID_PICOLCD
 
 config HID_PICOLCD_FB
 	bool "Framebuffer support" if EXPERT
-	default !EXPERT
+	default y
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=FB || FB=y
 	select FB_DEFERRED_IO
@@ -452,7 +452,7 @@ config HID_PICOLCD_FB
 
 config HID_PICOLCD_BACKLIGHT
 	bool "Backlight control" if EXPERT
-	default !EXPERT
+	default y
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
 	---help---
@@ -461,7 +461,7 @@ config HID_PICOLCD_BACKLIGHT
 
 config HID_PICOLCD_LCD
 	bool "Contrast control" if EXPERT
-	default !EXPERT
+	default y
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
 	---help---
@@ -469,7 +469,7 @@ config HID_PICOLCD_LCD
 
 config HID_PICOLCD_LEDS
 	bool "GPO via leds class" if EXPERT
-	default !EXPERT
+	default y
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
 	---help---
-- 
1.7.10.2


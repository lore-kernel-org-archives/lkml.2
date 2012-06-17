Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2FQKwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:52:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44366 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2FQKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:52:49 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: mail@bernhard-seibold.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        jkosina@suse.cz, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rdunlap@xenotime.net
Subject: [PATCH] HID: select NEW_LEDS for driver of Lenovo ThinkPad USB Keyboard with TrackPoint
Date: Sun, 17 Jun 2012 18:52:34 +0800
Message-Id: <1339930354-1040-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 'HID: Driver for Lenovo Keyboard with Trackpoint'
(c1dcad2d32d0252e8a3023d20311b52a187ecda3) introduced a compiling error due to
unmetting dependency of CONFIG_LEDS_CLASS.

on i386:

ERROR: "led_brightness_set" [drivers/leds/led-class.ko] undefined!
ERROR: "leds_list" [drivers/leds/led-class.ko] undefined!
ERROR: "leds_list_lock" [drivers/leds/led-class.ko] undefined!

and possibly related:

warning: (ADB_PMU_LED && IWLWIFI && IWLEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS && TABLET_USB_WACOM && INPUT_WISTRON_BTNS && SENSORS_APPLESMC && IR_WINBOND_CIR && BACKLIGHT_ADP8860 && BACKLIGHT_ADP8870 && HID_LENOVO_TPKBD && ACER_WMI && ASUS_LAPTOP && DELL_LAPTOP && HP_ACCEL && THINKPAD_ACPI && EEEPC_LAPTOP && ASUS_WMI && ACPI_TOSHIBA && SAMSUNG_LAPTOP) selects LEDS_CLASS which has unmet direct dependencies (NEW_LEDS)

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/hid/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index bb4fd6b..cea0951 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -271,6 +271,7 @@ config HID_LCPOWER
 config HID_LENOVO_TPKBD
 	tristate "Lenovo ThinkPad USB Keyboard with TrackPoint"
 	depends on USB_HID
+	select NEW_LEDS
 	select LEDS_CLASS
 	---help---
 	Support for the Lenovo ThinkPad USB Keyboard with TrackPoint.
-- 
1.7.10.4


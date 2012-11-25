Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2KYOF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 09:05:58 -0500
Received: from fep11.mx.upcmail.net ([62.179.121.31]:33743 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2KYOF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 09:05:57 -0500
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <50B22662.4070503@odi.ch>
Date: Sun, 25 Nov 2012 15:08:34 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
CC: stable@vger.kernel.org
Subject: [PATCH] HID: hid-input: battery quirk for Apple keyboard
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support battery capacity on another Apple wireless
keyboard.

NB: most likely all other APPLE_ALU_WIRELESS_*
keyboards should be added as well.

Signed-off-by: Ortwin Glück <odi@odi.ch>
---
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 5301006..b2ae097 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -299,6 +299,9 @@ static enum power_supply_property hidinput_battery_props[] = {

  static const struct hid_device_id hid_battery_quirks[] = {
         { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+                              USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+         HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+       { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
                                USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
           HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
         { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,

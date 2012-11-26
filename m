Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2KZMcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:32:17 -0500
Received: from fep23.mx.upcmail.net ([62.179.121.43]:33477 "EHLO
	fep23.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2KZMcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:32:15 -0500
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <50B36147.4070602@odi.ch>
Date: Mon, 26 Nov 2012 13:32:07 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
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

Cc: stable <at> kernel.org
Signed-off-by: Ortwin Glück <odi@odi.ch>
---
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 5301006..b2ae097 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -299,6 +299,9 @@ static enum power_supply_property 
hidinput_battery_props[] = {

  static const struct hid_device_id hid_battery_quirks[] = {
         { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+                              USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+         HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+       { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
                                USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
           HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
         { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,

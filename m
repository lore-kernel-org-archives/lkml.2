Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab0DVT2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:32 -0400
Received: from kroah.org ([198.145.64.141]:40752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab0DVT2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:23 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:13 2010
Message-Id: <20100422190913.746221802@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dtor@mail.ru>, Len Brown <len.brown@intel.com>
Subject: [071/197] thinkpad-acpi: use input_set_capability
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 792979c8032b8f5adb77ea986db7082fff04c8e7 upstream.

Use input_set_capability() instead of set_bit.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3350,16 +3350,14 @@ static int __init hotkey_init(struct ibm
 			TPACPI_HOTKEY_MAP_SIZE);
 	}
 
-	set_bit(EV_KEY, tpacpi_inputdev->evbit);
-	set_bit(EV_MSC, tpacpi_inputdev->evbit);
-	set_bit(MSC_SCAN, tpacpi_inputdev->mscbit);
+	input_set_capability(tpacpi_inputdev, EV_MSC, MSC_SCAN);
 	tpacpi_inputdev->keycodesize = TPACPI_HOTKEY_MAP_TYPESIZE;
 	tpacpi_inputdev->keycodemax = TPACPI_HOTKEY_MAP_LEN;
 	tpacpi_inputdev->keycode = hotkey_keycode_map;
 	for (i = 0; i < TPACPI_HOTKEY_MAP_LEN; i++) {
 		if (hotkey_keycode_map[i] != KEY_RESERVED) {
-			set_bit(hotkey_keycode_map[i],
-				tpacpi_inputdev->keybit);
+			input_set_capability(tpacpi_inputdev, EV_KEY,
+						hotkey_keycode_map[i]);
 		} else {
 			if (i < sizeof(hotkey_reserved_mask)*8)
 				hotkey_reserved_mask |= 1 << i;
@@ -3367,12 +3365,10 @@ static int __init hotkey_init(struct ibm
 	}
 
 	if (tp_features.hotkey_wlsw) {
-		set_bit(EV_SW, tpacpi_inputdev->evbit);
-		set_bit(SW_RFKILL_ALL, tpacpi_inputdev->swbit);
+		input_set_capability(tpacpi_inputdev, EV_SW, SW_RFKILL_ALL);
 	}
 	if (tp_features.hotkey_tablet) {
-		set_bit(EV_SW, tpacpi_inputdev->evbit);
-		set_bit(SW_TABLET_MODE, tpacpi_inputdev->swbit);
+		input_set_capability(tpacpi_inputdev, EV_SW, SW_TABLET_MODE);
 	}
 
 	/* Do not issue duplicate brightness change events to



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab1C3WO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:14:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:25024 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab1C3VFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733588"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: hmh@hmh.eng.br, mjg@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [2/275] thinkpad-acpi: lock down size of hotkey keymap
Message-Id: <20110330210355.C84D23E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:03:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

[ upstream commit 34a656d22f5539f613b93e7a1d14b4bd53592505 ]

Use a safer coding style for the hotkey keymap.  This does not fix any
problems, as the current code is correct.  But it might help avoid
mistakes in the future.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/thinkpad_acpi.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 22:52:06.274027381 -0700
+++ linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 23:55:37.481508118 -0700
@@ -1911,6 +1911,17 @@
 	TP_ACPI_HOTKEYSCAN_VOLUMEDOWN,
 	TP_ACPI_HOTKEYSCAN_MUTE,
 	TP_ACPI_HOTKEYSCAN_THINKPAD,
+	TP_ACPI_HOTKEYSCAN_UNK1,
+	TP_ACPI_HOTKEYSCAN_UNK2,
+	TP_ACPI_HOTKEYSCAN_UNK3,
+	TP_ACPI_HOTKEYSCAN_UNK4,
+	TP_ACPI_HOTKEYSCAN_UNK5,
+	TP_ACPI_HOTKEYSCAN_UNK6,
+	TP_ACPI_HOTKEYSCAN_UNK7,
+	TP_ACPI_HOTKEYSCAN_UNK8,
+
+	/* Hotkey keymap size */
+	TPACPI_HOTKEY_MAP_LEN
 };
 
 enum {	/* Keys/events available through NVRAM polling */
@@ -3113,7 +3124,7 @@
 	 * If the above is too much to ask, don't change the keymap.
 	 * Ask the thinkpad-acpi maintainer to do it, instead.
 	 */
-	static u16 ibm_keycode_map[] __initdata = {
+	static u16 ibm_keycode_map[TPACPI_HOTKEY_MAP_LEN] __initdata = {
 		/* Scan Codes 0x00 to 0x0B: ACPI HKEY FN+F1..F12 */
 		KEY_FN_F1,	KEY_FN_F2,	KEY_COFFEE,	KEY_SLEEP,
 		KEY_WLAN,	KEY_FN_F6, KEY_SWITCHVIDEOMODE, KEY_FN_F8,
@@ -3147,7 +3158,7 @@
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
 	};
-	static u16 lenovo_keycode_map[] __initdata = {
+	static u16 lenovo_keycode_map[TPACPI_HOTKEY_MAP_LEN] __initdata = {
 		/* Scan Codes 0x00 to 0x0B: ACPI HKEY FN+F1..F12 */
 		KEY_FN_F1,	KEY_COFFEE,	KEY_BATTERY,	KEY_SLEEP,
 		KEY_WLAN,	KEY_FN_F6, KEY_SWITCHVIDEOMODE, KEY_FN_F8,
@@ -3191,7 +3202,6 @@
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
 	};
 
-#define TPACPI_HOTKEY_MAP_LEN		ARRAY_SIZE(ibm_keycode_map)
 #define TPACPI_HOTKEY_MAP_SIZE		sizeof(ibm_keycode_map)
 #define TPACPI_HOTKEY_MAP_TYPESIZE	sizeof(ibm_keycode_map[0])
 
@@ -3469,7 +3479,8 @@
 	*send_acpi_ev = true;
 	*ignore_acpi_ev = false;
 
-	if (scancode > 0 && scancode < 0x21) {
+	/* HKEY event 0x1001 is scancode 0x00 */
+	if (scancode > 0 && scancode <= TPACPI_HOTKEY_MAP_LEN) {
 		scancode--;
 		if (!(hotkey_source_mask & (1 << scancode))) {
 			tpacpi_input_send_key_masked(scancode);

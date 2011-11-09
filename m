Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935740Ab1KJDeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:34:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935365Ab1KJDeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:34:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:26 2011
Message-Id: <20111109212726.833763208@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>
Subject: [261/262] HID: consolidate MacbookAir 4,1 mappings
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit da617c7cb915545dda4280df888dd6f8d5697420 upstream.

MacbookAir 4,1 doesn't require extra mapping table, as the mappings
are identical to apple_fn_keys[].

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-apple.c |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -82,28 +82,6 @@ static const struct apple_key_translatio
 	{ }
 };
 
-static const struct apple_key_translation macbookair4_fn_keys[] = {
-	{ KEY_BACKSPACE, KEY_DELETE },
-	{ KEY_ENTER,	KEY_INSERT },
-	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
-	{ KEY_F2,	KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
-	{ KEY_F3,	KEY_SCALE,          APPLE_FLAG_FKEY },
-	{ KEY_F4,	KEY_DASHBOARD,      APPLE_FLAG_FKEY },
-	{ KEY_F5,	KEY_KBDILLUMDOWN,   APPLE_FLAG_FKEY },
-	{ KEY_F6,	KEY_KBDILLUMUP,     APPLE_FLAG_FKEY },
-	{ KEY_F7,	KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
-	{ KEY_F8,	KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
-	{ KEY_F9,	KEY_NEXTSONG,       APPLE_FLAG_FKEY },
-	{ KEY_F10,	KEY_MUTE,           APPLE_FLAG_FKEY },
-	{ KEY_F11,	KEY_VOLUMEDOWN,     APPLE_FLAG_FKEY },
-	{ KEY_F12,	KEY_VOLUMEUP,       APPLE_FLAG_FKEY },
-	{ KEY_UP,	KEY_PAGEUP },
-	{ KEY_DOWN,	KEY_PAGEDOWN },
-	{ KEY_LEFT,	KEY_HOME },
-	{ KEY_RIGHT,	KEY_END },
-	{ }
-};
-
 static const struct apple_key_translation apple_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
 	{ KEY_ENTER,	KEY_INSERT },
@@ -208,9 +186,6 @@ static int hidinput_apple_event(struct h
 		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6_JIS)
 			table = macbookair_fn_keys;
-		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6A_ANSI &&
-				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6A_JIS)
-			table = macbookair4_fn_keys;
 		else if (hid->product < 0x21d || hid->product >= 0x300)
 			table = powerbook_fn_keys;
 		else



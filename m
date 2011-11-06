Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1KFRRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:17:50 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43176
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab1KFRRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:17:49 -0500
From: Dirk Hohndel <hohndel@infradead.org>
To: Joshua V Dillon <jvdillon@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add support for the Mid 2011 MacBook Air keyboard layout
User-Agent: Notmuch/0.5-251-g11db5ef (http://notmuchmail.org) Emacs/23.3.1 (x86_64-suse-linux-gnu)
Date: Sun, 06 Nov 2011 09:16:56 -0800
Message-ID: <87r51l41dj.fsf@hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When adding support for the MacBookAir4,x models in commit
5d922baa631058c7e37ae33e81c4d3e6437f8d1d Joshua Dillon overlooked
that they have a slightly different keyboard layout compared to the older
MacBook Air models. With this patch the function keys all work as
advertized, including keyboard brightness, etc.

Signed-off-by: Dirk Hohndel <hohndel@infradead.org>
---
 drivers/hid/hid-apple.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 8cdb4b4..57489a2 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -82,6 +82,30 @@ static const struct apple_key_translation macbookair_fn_keys[] = {
 	{ }
 };
 
+/* MacBook Air Mid2011 
+ * (dmidecode identifies as MacBookAir4,1 (11") and 4,2 (13")) */
+static const struct apple_key_translation macbookair4_x_fn_keys[] = {
+	{ KEY_BACKSPACE, KEY_DELETE },
+	{ KEY_ENTER,	KEY_INSERT },
+	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
+	{ KEY_F2,	KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
+	{ KEY_F3,	KEY_SCALE,          APPLE_FLAG_FKEY },
+	{ KEY_F4,	KEY_DASHBOARD,      APPLE_FLAG_FKEY },
+	{ KEY_F5,	KEY_KBDILLUMDOWN,   APPLE_FLAG_FKEY },
+	{ KEY_F6,	KEY_KBDILLUMUP,     APPLE_FLAG_FKEY },
+	{ KEY_F7,	KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
+	{ KEY_F8,	KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
+	{ KEY_F9,	KEY_NEXTSONG,       APPLE_FLAG_FKEY },
+	{ KEY_F10,	KEY_MUTE,           APPLE_FLAG_FKEY },
+	{ KEY_F11,	KEY_VOLUMEDOWN,     APPLE_FLAG_FKEY },
+	{ KEY_F12,	KEY_VOLUMEUP,       APPLE_FLAG_FKEY },
+	{ KEY_UP,	KEY_PAGEUP },
+	{ KEY_DOWN,	KEY_PAGEDOWN },
+	{ KEY_LEFT,	KEY_HOME },
+	{ KEY_RIGHT,	KEY_END },
+	{ }
+};
+
 static const struct apple_key_translation apple_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
 	{ KEY_ENTER,	KEY_INSERT },
@@ -185,7 +209,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 			table = macbookair_fn_keys;
 		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6_JIS)
-			table = macbookair_fn_keys;
+			table = macbookair4_x_fn_keys;
 		else if (hid->product < 0x21d || hid->product >= 0x300)
 			table = powerbook_fn_keys;
 		else
-- 
1.7.7


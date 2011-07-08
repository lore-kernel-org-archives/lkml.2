Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1GHFNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:13:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab1GHFDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.677676174@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [061/107] [media] keymaps: fix table for pinnacle pctv hd devices
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit 1ba9268c2bfeebfd70193145685e12faeae92882 upstream.

Both consumers of RC_MAP_PINNACLE_PCTV_HD send along full RC-5
scancodes, so this update makes this keymap actually *have* full
scancodes, heisted from rc-dib0700-rc5.c. This should fix out of the box
remote functionality for the Pinnacle PCTV HD 800i (cx88 pci card) and
PCTV HD Pro 801e (em28xx usb stick).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c |   58 +++++++++++--------------
 1 file changed, 27 insertions(+), 31 deletions(-)

--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -15,43 +15,39 @@
 /* Pinnacle PCTV HD 800i mini remote */
 
 static struct rc_map_table pinnacle_pctv_hd[] = {
-
-	{ 0x0f, KEY_1 },
-	{ 0x15, KEY_2 },
-	{ 0x10, KEY_3 },
-	{ 0x18, KEY_4 },
-	{ 0x1b, KEY_5 },
-	{ 0x1e, KEY_6 },
-	{ 0x11, KEY_7 },
-	{ 0x21, KEY_8 },
-	{ 0x12, KEY_9 },
-	{ 0x27, KEY_0 },
-
-	{ 0x24, KEY_ZOOM },
-	{ 0x2a, KEY_SUBTITLE },
-
-	{ 0x00, KEY_MUTE },
-	{ 0x01, KEY_ENTER },	/* Pinnacle Logo */
-	{ 0x39, KEY_POWER },
-
-	{ 0x03, KEY_VOLUMEUP },
-	{ 0x09, KEY_VOLUMEDOWN },
-	{ 0x06, KEY_CHANNELUP },
-	{ 0x0c, KEY_CHANNELDOWN },
-
-	{ 0x2d, KEY_REWIND },
-	{ 0x30, KEY_PLAYPAUSE },
-	{ 0x33, KEY_FASTFORWARD },
-	{ 0x3c, KEY_STOP },
-	{ 0x36, KEY_RECORD },
-	{ 0x3f, KEY_EPG },	/* Labeled "?" */
+	/* Key codes for the tiny Pinnacle remote*/
+	{ 0x0700, KEY_MUTE },
+	{ 0x0701, KEY_MENU }, /* Pinnacle logo */
+	{ 0x0739, KEY_POWER },
+	{ 0x0703, KEY_VOLUMEUP },
+	{ 0x0709, KEY_VOLUMEDOWN },
+	{ 0x0706, KEY_CHANNELUP },
+	{ 0x070c, KEY_CHANNELDOWN },
+	{ 0x070f, KEY_1 },
+	{ 0x0715, KEY_2 },
+	{ 0x0710, KEY_3 },
+	{ 0x0718, KEY_4 },
+	{ 0x071b, KEY_5 },
+	{ 0x071e, KEY_6 },
+	{ 0x0711, KEY_7 },
+	{ 0x0721, KEY_8 },
+	{ 0x0712, KEY_9 },
+	{ 0x0727, KEY_0 },
+	{ 0x0724, KEY_ZOOM }, /* 'Square' key */
+	{ 0x072a, KEY_SUBTITLE },   /* 'T' key */
+	{ 0x072d, KEY_REWIND },
+	{ 0x0730, KEY_PLAYPAUSE },
+	{ 0x0733, KEY_FASTFORWARD },
+	{ 0x0736, KEY_RECORD },
+	{ 0x073c, KEY_STOP },
+	{ 0x073f, KEY_HELP }, /* '?' key */
 };
 
 static struct rc_map_list pinnacle_pctv_hd_map = {
 	.map = {
 		.scan    = pinnacle_pctv_hd,
 		.size    = ARRAY_SIZE(pinnacle_pctv_hd),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_RC5,
 		.name    = RC_MAP_PINNACLE_PCTV_HD,
 	}
 };



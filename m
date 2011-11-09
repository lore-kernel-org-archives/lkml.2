Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936169Ab1KJDwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:52:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966104Ab1KJDtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:09 2011
Message-Id: <20111109213209.154941825@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:35:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
        Joshua V Dillon <jvdillon@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [264/264] hid/apple: modern macbook airs use the standard apple function key translations
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 21404b772a1c65f7b935b8c0fddc388a949f4e31 upstream.

This removes the use of the special "macbookair_fn_keys" keyboard
translation table for the MacBookAir4,x models (ie the 2011 refresh).
They use the standard apple_fn_keys[] translation.  Apparently only the
old MacBook Air's need a different translation table.

This mirrors the change that commit da617c7cb915 ("HID: consolidate
MacbookAir 4,1 mappings") did for the WELLSPRING6A ones, but does it for
the WELLSPRING6 model used on the MacBookAir4,2.

Reported-and-tested-by: Dirk Hohndel <hohndel@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joshua V Dillon <jvdillon@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -183,9 +183,6 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
 			table = macbookair_fn_keys;
-		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI &&
-				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6_JIS)
-			table = macbookair_fn_keys;
 		else if (hid->product < 0x21d || hid->product >= 0x300)
 			table = powerbook_fn_keys;
 		else



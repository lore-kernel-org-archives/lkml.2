Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1CKAAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:00:49 -0500
Received: from kroah.org ([198.145.64.141]:46871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab1CJX5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.620671772@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>,
        James Sharam <james.sharam@googlemail.com>
Subject: [patch 16/29] HID: hid-mosart: ignore buttons report
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

commit ad6d42670279da8f33f633f8a96a67cd7ef3b1da upstream.

This commit allows the device to be recognized as a touchscreen, and not a
touchpad by xf86-input-evdev.

The device has 2 modes. The first one is an emulation of a touchscreen by
sending left and right button, and the second mode is the one used in
dual-touch (sending trackingID, touch and else).

That's why there is a hid report containing left and right buttons
(9000001 and 9000002). The point is that xorg relies on these fields to
determine if it's a touchpad or a touchscreen.
Clearing the report (return -1) makes xorg detecting it out of the box
as a quite pleasant (dual)touchscreen.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: James Sharam <james.sharam@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-mosart.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hid/hid-mosart.c
+++ b/drivers/hid/hid-mosart.c
@@ -90,6 +90,10 @@ static int mosart_input_mapping(struct h
 	case 0xff000000:
 		/* ignore HID features */
 		return -1;
+
+	case HID_UP_BUTTON:
+		/* ignore buttons */
+		return -1;
 	}
 
 	return 0;



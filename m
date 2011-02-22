Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab1BVWe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:34:58 -0500
Received: from kroah.org ([198.145.64.141]:46606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab1BVWVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.475640162@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [14/70] HID: magicmouse: Dont report REL_{X, Y} for Magic Trackpad
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Chase Douglas <chase.douglas@canonical.com>

[ Linus' tree commit 6a66bbd693c12f71697c61207aa18bc5a12da0ab ]

With the recent switch to having the hid layer handle standard axis
initialization, the Magic Trackpad now reports relative axes. This would
be fine in the normal mode, but the driver puts the device in multitouch
mode where no relative events are generated. Also, userspace software
depends on accurate axis information for device type detection. Thus,
ignoring the relative axes from the Magic Trackpad is best.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-magicmouse.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -433,6 +433,11 @@ static int magicmouse_input_mapping(stru
 	if (!msc->input)
 		msc->input = hi->input;
 
+	/* Magic Trackpad does not give relative data after switching to MT */
+	if (hi->input->id.product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD &&
+	    field->flags & HID_MAIN_ITEM_RELATIVE)
+		return -1;
+
 	return 0;
 }
 



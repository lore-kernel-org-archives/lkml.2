Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab1CUXQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:16:15 -0400
Received: from kroah.org ([198.145.64.141]:49516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab1CUXPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:15 2011
Message-Id: <20110321230714.982268367@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Poole <mdpoole@troilus.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [56/87] HID: hid-magicmouse: Correct touch orientation direction
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 2d9ca4e9f393d81d8f37ed37505aecbf3a5e1bd6 upstream.

The magic trackpad and mouse both report touch orientation in opposite
direction to the bcm5974 driver and what is written in
Documents/input/multi-touch-protocol.txt. This patch reverts the
direction, so that all in-kernel devices with this feature behave the
same way.

Since no known application has been utilizing this information yet, it
seems appropriate also for stable.

Cc: Michael Poole <mdpoole@troilus.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-magicmouse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -256,7 +256,7 @@ static void magicmouse_emit_touch(struct
 		input_report_abs(input, ABS_MT_TRACKING_ID, id);
 		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major << 2);
 		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor << 2);
-		input_report_abs(input, ABS_MT_ORIENTATION, orientation);
+		input_report_abs(input, ABS_MT_ORIENTATION, -orientation);
 		input_report_abs(input, ABS_MT_POSITION_X, x);
 		input_report_abs(input, ABS_MT_POSITION_Y, y);
 
@@ -395,7 +395,7 @@ static void magicmouse_setup_input(struc
 		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
 		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 4, 0);
 		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 4, 0);
-		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 1, 0);
+		input_set_abs_params(input, ABS_MT_ORIENTATION, -31, 32, 1, 0);
 
 		/* Note: Touch Y position from the device is inverted relative
 		 * to how pointer motion is reported (and relative to how USB



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1CIRhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:37:16 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49284 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106Ab1CIRhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:37:14 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        stable@kernel.org, Michael Poole <mdpoole@troilus.org>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH] HID: hid-magicmouse: Correct touch orientation direction
Date: Wed,  9 Mar 2011 18:38:57 +0100
Message-Id: <1299692337-1547-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.4.1
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxNJh-0003Kx-6H.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PxNJh-0003Kx-6H 49ced1d223f8efea2d34f8ee10f22fd7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The magic trackpad and mouse both report touch orientation in opposite
direction to the bcm5974 driver and what is written in
Documents/input/multi-touch-protocol.txt. This patch reverts the
direction, so that all in-kernel devices with this feature behave the
same way.

Since no known application has been utilizing this information yet, it
seems appropriate also for stable.

Cc: stable@kernel.org
Cc: Michael Poole <mdpoole@troilus.org>
Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-magicmouse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 698e645..318cc40 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -258,7 +258,7 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 		input_report_abs(input, ABS_MT_TRACKING_ID, id);
 		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major << 2);
 		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor << 2);
-		input_report_abs(input, ABS_MT_ORIENTATION, orientation);
+		input_report_abs(input, ABS_MT_ORIENTATION, -orientation);
 		input_report_abs(input, ABS_MT_POSITION_X, x);
 		input_report_abs(input, ABS_MT_POSITION_Y, y);
 
@@ -397,7 +397,7 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
 		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 4, 0);
 		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 4, 0);
-		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 1, 0);
+		input_set_abs_params(input, ABS_MT_ORIENTATION, -31, 32, 1, 0);
 
 		/* Note: Touch Y position from the device is inverted relative
 		 * to how pointer motion is reported (and relative to how USB
-- 
1.7.4.1


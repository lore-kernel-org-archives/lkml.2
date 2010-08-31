Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0HaSl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:41:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51985 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0HaSlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:41:25 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6 v2] HID: magicmouse: remove axis data filtering
Date: Tue, 31 Aug 2010 14:41:06 -0400
Message-Id: <1283280068-12285-4-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Magic Mouse device is very precise. No driver filtering of input
data needs to be performed.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Acked-by: Michael Poole <mdpoole@troilus.org>
---
 drivers/hid/hid-magicmouse.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 98bbc53..0fe2464 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -357,11 +357,11 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		__set_bit(EV_ABS, input->evbit);
 
 		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
-		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 4, 0);
-		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 4, 0);
-		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 1, 0);
+		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
+		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
+		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 0, 0);
 		input_set_abs_params(input, ABS_MT_POSITION_X, -1100, 1358,
-				4, 0);
+				0, 0);
 		/* Note: Touch Y position from the device is inverted relative
 		 * to how pointer motion is reported (and relative to how USB
 		 * HID recommends the coordinates work).  This driver keeps
@@ -369,7 +369,7 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		 * inverse of the reported Y.
 		 */
 		input_set_abs_params(input, ABS_MT_POSITION_Y, -1589, 2047,
-				4, 0);
+				0, 0);
 	}
 
 	if (report_undeciphered) {
-- 
1.7.1


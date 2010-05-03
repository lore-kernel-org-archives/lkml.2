Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0ECJJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:09:47 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:36730 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0ECJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:09:43 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: linux-input@vger.kernel.org, jkosina@suse.cz, chatty@enac.fr
Cc: dmitry.torokhov@gmail.com, micki@n-trig.com, linux-kernel@vger.kernel.org,
       Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 2/2] Remove unused macro, TripleTap and QuadTap
Date: Mon,  3 May 2010 05:08:30 -0400
Message-Id: <1272877710-25431-3-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272877710-25431-1-git-send-email-rafi@seas.upenn.edu>
References: <1272877710-25431-1-git-send-email-rafi@seas.upenn.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the higher number taps.  Their usage was incorrect
and even if correct they should not be used for a touch screen.
_MT_ events should be used to communicate multiple fingers.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

---
I'm not removing DoubleTap just yet.  There are still some people
using the wacom driver for touch, and I'd rather not pull the rug
out from under them.
---
 drivers/hid/hid-ntrig.c |   32 ++------------------------------
 1 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 10b08d6..4777bbf 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -24,9 +24,6 @@
 
 #define NTRIG_DUPLICATE_USAGES	0x001
 
-#define nt_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
-					EV_KEY, (c))
-
 struct ntrig_data {
 	/* Incoming raw values for a single contact */
 	__u16 x, y, w, h;
@@ -257,29 +254,10 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 			nd->reading_mt = 0;
 
 			if (nd->first_contact_touch) {
-				switch (value) {
-				case 0:	/* for single touch devices */
-				case 1:
-					input_report_key(input,
-							BTN_TOOL_DOUBLETAP, 1);
-					break;
-				case 2:
-					input_report_key(input,
-							BTN_TOOL_TRIPLETAP, 1);
-					break;
-				case 3:
-				default:
-					input_report_key(input,
-							BTN_TOOL_QUADTAP, 1);
-				}
+				input_report_key(input, BTN_TOOL_DOUBLETAP, 1);
 				input_report_key(input, BTN_TOUCH, 1);
 			} else {
-				input_report_key(input,
-						BTN_TOOL_DOUBLETAP, 0);
-				input_report_key(input,
-						BTN_TOOL_TRIPLETAP, 0);
-				input_report_key(input,
-						BTN_TOOL_QUADTAP, 0);
+				input_report_key(input, BTN_TOOL_DOUBLETAP, 0);
 				input_report_key(input, BTN_TOUCH, 0);
 			}
 			break;
@@ -345,13 +323,7 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			__clear_bit(BTN_TOOL_PEN, input->keybit);
 			__clear_bit(BTN_TOOL_FINGER, input->keybit);
 			__clear_bit(BTN_0, input->keybit);
-			/*
-			 * A little something special to enable
-			 * two and three finger taps.
-			 */
 			__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
-			__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
-			__set_bit(BTN_TOOL_QUADTAP, input->keybit);
 			/*
 			 * The physical touchscreen (single touch)
 			 * input has a value for physical, whereas
-- 
1.7.1


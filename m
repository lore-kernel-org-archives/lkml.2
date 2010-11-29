Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0K2Hoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 02:44:34 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:57059 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755178Ab0K2Hoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 02:44:32 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 5/7] hid: egalax: Add event filtering (rev3)
Date: Mon, 29 Nov 2010 08:43:30 +0100
Message-Id: <1291016612-25102-6-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PMyP3-0000Ut-B0.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PMyP3-0000Ut-B0 515d99709509e94d3b0bb5889d616d6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use estimated signal-to-noise ratios to reduce noise and limit the
amount of events emitted.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-egalax.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index a6ab617..5da5ecb 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -25,6 +25,10 @@ MODULE_LICENSE("GPL");
 
 #include "hid-ids.h"
 
+/* estimated signal-to-noise ratios */
+#define SN_MOVE			4096
+#define SN_PRESSURE		32
+
 struct egalax_data {
 	__u16 x, y, z;
 	__u8 id;
@@ -57,17 +61,17 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			field->logical_maximum = 32760;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_X);
-			set_abs(input, ABS_MT_POSITION_X, field, 0);
+			set_abs(input, ABS_MT_POSITION_X, field, SN_MOVE);
 			/* touchscreen emulation */
-			set_abs(input, ABS_X, field, 0);
+			set_abs(input, ABS_X, field, SN_MOVE);
 			return 1;
 		case HID_GD_Y:
 			field->logical_maximum = 32760;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_Y);
-			set_abs(input, ABS_MT_POSITION_Y, field, 0);
+			set_abs(input, ABS_MT_POSITION_Y, field, SN_MOVE);
 			/* touchscreen emulation */
-			set_abs(input, ABS_Y, field, 0);
+			set_abs(input, ABS_Y, field, SN_MOVE);
 			return 1;
 		}
 		return 0;
@@ -93,9 +97,9 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			field->logical_minimum = 0;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_PRESSURE);
-			set_abs(input, ABS_MT_PRESSURE, field, 0);
+			set_abs(input, ABS_MT_PRESSURE, field, SN_PRESSURE);
 			/* touchscreen emulation */
-			set_abs(input, ABS_PRESSURE, field, 0);
+			set_abs(input, ABS_PRESSURE, field, SN_PRESSURE);
 			return 1;
 		}
 		return 0;
-- 
1.7.1


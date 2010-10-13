Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0JMUbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:31:17 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:48848 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970Ab0JMUbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:31:16 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 5/6] hid: egalax: Add event filtering (rev2)
Date: Wed, 13 Oct 2010 22:30:24 +0200
Message-Id: <1287001824-4132-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286978302-30034-4-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-4-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P67yM-0001Kz-B0.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1P67yM-0001Kz-B0 55a34076a95b9433dd063a0358914814
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
index b8025b9..78a2b3e 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -27,6 +27,10 @@ MODULE_LICENSE("GPL");
 
 #define MAX_EVENTS		120
 
+/* estimated signal-to-noise ratios */
+#define SN_MOVE			1024
+#define SN_PRESSURE		32
+
 struct egalax_data {
 	__u16 x, y, z;
 	__u8 id;
@@ -59,17 +63,17 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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
@@ -96,9 +100,9 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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


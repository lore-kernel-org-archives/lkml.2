Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0K2Hqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 02:46:44 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:35506 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177Ab0K2Hqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 02:46:43 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/7] hid: egalax: Correct for device resolution report error (rev2)
Date: Mon, 29 Nov 2010 08:43:28 +0100
Message-Id: <1291016612-25102-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PMyOw-0008VB-5V.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PMyOw-0008VB-5V 64dc76e780e64dac500e647df09dcea9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware of both supported devices report a X/Y maximum of 4095,
whereas in reality, it is eight times larger. Fixed with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-egalax.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index 6fbb4e0..b3a1139 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -54,6 +54,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_GENDESK:
 		switch (usage->hid) {
 		case HID_GD_X:
+			field->logical_maximum = 32760;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_X);
 			set_abs(input, ABS_MT_POSITION_X, field, 0);
@@ -61,6 +62,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			set_abs(input, ABS_X, field, 0);
 			return 1;
 		case HID_GD_Y:
+			field->logical_maximum = 32760;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_Y);
 			set_abs(input, ABS_MT_POSITION_Y, field, 0);
-- 
1.7.1


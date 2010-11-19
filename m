Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0KSAZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:25:28 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:50259 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab0KSAZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:25:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KUJEReDt7O9XAcdDbUiv0a+PCGbOhTedKX1eJ0ZbpzUL0Diey6NGjCFemlrbi5irBz
         c62e6fU8R8CT9gfIJhFHujQ5/NuAOU86uLShiXpJnDBh2KN2SU0fUUFd8ulG0U4KDQaV
         oAahSQv5WeITfzQBKs9/ko4+CXIXrGlmGVgKU=
From: Ping Cheng <pinglinux@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, Ping Cheng <pingc@wacom.com>
Subject: [PATCH] Add BTN_TOOL_BUTTONS to input.h
Date: Thu, 18 Nov 2010 16:25:35 -0800
Message-Id: <1290126335-12430-1-git-send-email-pingc@wacom.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We "borrowed" BTN_TOOL_FINGER from input/mouse to pass tablet
buttons to the user land. This has not been an issue since
tablet was not considered as a mouse replacement. With the
introduction of hybrid digitizer and touch devices, the tool
type is causing confusion. A new tool type is due for the
well-being of future input device drivers.

Signed-off-by: Ping Cheng <pingc@wacom.com>
---
 drivers/input/tablet/hanwang.c   |    6 +++---
 drivers/input/tablet/wacom_wac.c |   24 ++++++++++++------------
 include/linux/input.h            |    1 +
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/input/tablet/hanwang.c b/drivers/input/tablet/hanwang.c
index 6504b62..c59f78c 100644
--- a/drivers/input/tablet/hanwang.c
+++ b/drivers/input/tablet/hanwang.c
@@ -112,7 +112,7 @@ static const int hw_absevents[] = {
 
 static const int hw_btnevents[] = {
 	BTN_STYLUS, BTN_STYLUS2, BTN_TOOL_PEN, BTN_TOOL_RUBBER,
-	BTN_TOOL_MOUSE, BTN_TOOL_FINGER,
+	BTN_TOOL_MOUSE, BTN_TOOL_BUTTONS,
 	BTN_0, BTN_1, BTN_2, BTN_3, BTN_4, BTN_5, BTN_6, BTN_7, BTN_8,
 };
 
@@ -202,7 +202,7 @@ static void hanwang_parse_packet(struct hanwang *hanwang)
 
 		switch (type) {
 		case HANWANG_ART_MASTER_III:
-			input_report_key(input_dev, BTN_TOOL_FINGER, data[1] ||
+			input_report_key(input_dev, BTN_TOOL_BUTTONS, data[1] ||
 							data[2] || data[3]);
 			input_report_abs(input_dev, ABS_WHEEL, data[1]);
 			input_report_key(input_dev, BTN_0, data[2]);
@@ -212,7 +212,7 @@ static void hanwang_parse_packet(struct hanwang *hanwang)
 			break;
 
 		case HANWANG_ART_MASTER_HD:
-			input_report_key(input_dev, BTN_TOOL_FINGER, data[1] ||
+			input_report_key(input_dev, BTN_TOOL_BUTTONS, data[1] ||
 					data[2] || data[3] || data[4] ||
 					data[5] || data[6]);
 			input_report_abs(input_dev, ABS_RX,
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index b3252ef..360ce4a 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -268,7 +268,7 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
 			input_report_key(input, BTN_4, (data[7] & 0x80));
 			rw = ((data[7] & 0x18) >> 3) - ((data[7] & 0x20) >> 3);
 			input_report_rel(input, REL_WHEEL, rw);
-			input_report_key(input, BTN_TOOL_FINGER, 0xf0);
+			input_report_key(input, BTN_TOOL_BUTTONS, 0xf0);
 			if (!prox)
 				wacom->id[1] = 0;
 			input_report_abs(input, ABS_MISC, wacom->id[1]);
@@ -286,7 +286,7 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
 			input_report_key(input, BTN_4, (data[7] & 0x10));
 			input_report_key(input, BTN_5, (data[7] & 0x40));
 			input_report_abs(input, ABS_WHEEL, (data[8] & 0x7f));
-			input_report_key(input, BTN_TOOL_FINGER, 0xf0);
+			input_report_key(input, BTN_TOOL_BUTTONS, 0xf0);
 			if (!prox)
 				wacom->id[1] = 0;
 			input_report_abs(input, ABS_MISC, wacom->id[1]);
@@ -486,8 +486,8 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 	/* pad packets. Works as a second tool and is always in prox */
 	if (data[0] == WACOM_REPORT_INTUOSPAD) {
 		/* initiate the pad as a device */
-		if (wacom->tool[1] != BTN_TOOL_FINGER)
-			wacom->tool[1] = BTN_TOOL_FINGER;
+		if (wacom->tool[1] != BTN_TOOL_BUTTONS)
+			wacom->tool[1] = BTN_TOOL_BUTTONS;
 
 		if (features->type >= INTUOS4S && features->type <= INTUOS4L) {
 			input_report_key(input, BTN_0, (data[2] & 0x01));
@@ -552,11 +552,11 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 			if ((data[5] & 0x1f) | data[6] | (data[1] & 0x1f) |
 				data[2] | (data[3] & 0x1f) | data[4] | data[8] |
 				(data[7] & 0x01)) {
-				input_report_key(input, wacom->tool[1], 1);
-				input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
+			/*	input_report_key(input, wacom->tool[1], 1);
+			*/	input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
 			} else {
-				input_report_key(input, wacom->tool[1], 0);
-				input_report_abs(input, ABS_MISC, 0);
+			/*	input_report_key(input, wacom->tool[1], 0);
+			*/	input_report_abs(input, ABS_MISC, 0);
 			}
 		}
 		input_event(input, EV_MSC, MSC_SERIAL, 0xffffffff);
@@ -1141,7 +1141,7 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 	case WACOM_G4:
 		input_set_capability(input_dev, EV_MSC, MSC_SERIAL);
 
-		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+		__set_bit(BTN_TOOL_BUTTONS, input_dev->keybit);
 		__set_bit(BTN_0, input_dev->keybit);
 		__set_bit(BTN_4, input_dev->keybit);
 		/* fall through */
@@ -1179,7 +1179,7 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 	case CINTIQ:
 		for (i = 0; i < 8; i++)
 			__set_bit(BTN_0 + i, input_dev->keybit);
-		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+		__set_bit(BTN_TOOL_BUTTONS, input_dev->keybit);
 
 		input_set_abs_params(input_dev, ABS_RX, 0, 4096, 0, 0);
 		input_set_abs_params(input_dev, ABS_RY, 0, 4096, 0, 0);
@@ -1203,7 +1203,7 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 		__set_bit(BTN_2, input_dev->keybit);
 		__set_bit(BTN_3, input_dev->keybit);
 
-		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+		__set_bit(BTN_TOOL_BUTTONS, input_dev->keybit);
 
 		input_set_abs_params(input_dev, ABS_RX, 0, 4096, 0, 0);
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
@@ -1222,7 +1222,7 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 	case INTUOS4S:
 		for (i = 0; i < 7; i++)
 			__set_bit(BTN_0 + i, input_dev->keybit);
-		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+		__set_bit(BTN_TOOL_BUTTONS, input_dev->keybit);
 
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
 		wacom_setup_intuos(wacom_wac);
diff --git a/include/linux/input.h b/include/linux/input.h
index 6ef4446..be3c4bf 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -468,6 +468,7 @@ struct input_keymap_entry {
 #define BTN_TOOL_FINGER		0x145
 #define BTN_TOOL_MOUSE		0x146
 #define BTN_TOOL_LENS		0x147
+#define BTN_TOOL_BUTTONS	0x148
 #define BTN_TOUCH		0x14a
 #define BTN_STYLUS		0x14b
 #define BTN_STYLUS2		0x14c
-- 
1.7.2.3


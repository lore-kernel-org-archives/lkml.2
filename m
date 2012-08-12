Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2HLVkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:36 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:52498 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2HLVj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:29 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1OADciKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBEogRtjoUkS8DmzaNBg
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="389105696"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 03/19] Input: Remove redundant packet estimates
Date: Sun, 12 Aug 2012 23:42:21 +0200
Message-Id: <1344807757-2217-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Packet estimates are now better handled in the input core. Remove the
redundant estimates from those drivers.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-input.c       | 4 ----
 drivers/hid/hid-magicmouse.c  | 2 --
 drivers/input/input-mt.c      | 1 -
 drivers/input/mouse/bcm5974.c | 2 --
 4 files changed, 9 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 811bfad..ad5cbcf 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -911,10 +911,6 @@ mapped:
 
 		input_abs_set_res(input, usage->code,
 				  hidinput_calc_abs_res(field, usage->code));
-
-		/* use a larger default input buffer for MT devices */
-		if (usage->code == ABS_MT_POSITION_X && input->hint_events_per_packet == 0)
-			input_set_events_per_packet(input, 60);
 	}
 
 	if (usage->type == EV_ABS &&
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 7364726..e425de4 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -435,8 +435,6 @@ static int magicmouse_setup_input(struct input_dev *input, struct hid_device *hd
 				  TRACKPAD_RES_Y);
 	}
 
-	input_set_events_per_packet(input, 60);
-
 	if (report_undeciphered) {
 		__set_bit(EV_MSC, input->evbit);
 		__set_bit(MSC_RAW, input->mscbit);
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c6df704..58bde77 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -42,7 +42,6 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots)
 	mt->num_slots = num_slots;
 	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
 	input_set_abs_params(dev, ABS_MT_TRACKING_ID, 0, TRKID_MAX, 0, 0);
-	input_set_events_per_packet(dev, 6 * num_slots);
 
 	/* Mark slots as 'unused' */
 	for (i = 0; i < num_slots; i++)
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index d528c23..8234098 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -456,8 +456,6 @@ static void setup_events_to_report(struct input_dev *input_dev,
 	__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
 	if (cfg->caps & HAS_INTEGRATED_BUTTON)
 		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
-
-	input_set_events_per_packet(input_dev, 60);
 }
 
 /* report button data as logical button state */
-- 
1.7.11.4


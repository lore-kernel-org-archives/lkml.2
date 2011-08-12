Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1HLRRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:17:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1HLRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:17:00 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 7/8 v3] Input: add BTN_TOOL_QUINTTAP for reporting 5 fingers on touchpad
Date: Sat, 13 Aug 2011 01:16:46 +0800
Message-Id: <1313169407-4358-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"4-finger scroll" is a gesture supported by some applications and
operating systems.

"Resting thumb" is when a clickpad user rests a finger (e.g., a
thumb), in a "click zone" (typically the bottom of the touchpad) in
anticipation of click+move=select gestures.

Thus, "4-finger scroll + resting thumb" is a 5-finger gesture.
To allow userspace to detect this gesture, we send BTN_TOOL_QUINTTAP.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/input-mt.c |    1 +
 include/linux/input.h    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c48c81f..9150ee7 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -117,6 +117,7 @@ void input_mt_report_finger_count(struct input_dev *dev, int count)
 	input_event(dev, EV_KEY, BTN_TOOL_DOUBLETAP, count == 2);
 	input_event(dev, EV_KEY, BTN_TOOL_TRIPLETAP, count == 3);
 	input_event(dev, EV_KEY, BTN_TOOL_QUADTAP, count == 4);
+	input_event(dev, EV_KEY, BTN_TOOL_QUINTTAP, count == 5);
 }
 EXPORT_SYMBOL(input_mt_report_finger_count);
 
diff --git a/include/linux/input.h b/include/linux/input.h
index 068784e..4de4b46 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -503,6 +503,7 @@ struct input_keymap_entry {
 #define BTN_TOOL_FINGER		0x145
 #define BTN_TOOL_MOUSE		0x146
 #define BTN_TOOL_LENS		0x147
+#define BTN_TOOL_QUINTTAP	0x148	/* Five fingers on trackpad */
 #define BTN_TOUCH		0x14a
 #define BTN_STYLUS		0x14b
 #define BTN_STYLUS2		0x14c
-- 
1.7.3.1


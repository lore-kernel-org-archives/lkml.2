Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2ALTVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 14:21:23 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:41024 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2ALTVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 14:21:21 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvRQAMcxD09V5qrvPGdsb2JhbABDiVWjNhkBAQEBNzKCIC8TAQ8YgQIKGhOHfLc/E4wKBJpujF0
X-IronPort-AV: E=Sophos;i="4.71,499,1320620400"; 
   d="scan'208";a="30665779"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] Input: Use accessor for MT events
Date: Thu, 12 Jan 2012 20:21:05 +0100
Message-Id: <1326396065-2448-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an accessor function for the actual MT event types, and use
it everywhere.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c    |    2 +-
 include/linux/input/mt.h |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index da38d97..ba6839f 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -180,7 +180,7 @@ static int input_handle_abs_event(struct input_dev *dev,
 		return INPUT_IGNORE_EVENT;
 	}
 
-	is_mt_event = code >= ABS_MT_FIRST && code <= ABS_MT_LAST;
+	is_mt_event = input_is_mt_value(code);
 
 	if (!is_mt_event) {
 		pold = &dev->absinfo[code].value;
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index 318bb82..f867375 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -48,10 +48,14 @@ static inline void input_mt_slot(struct input_dev *dev, int slot)
 	input_event(dev, EV_ABS, ABS_MT_SLOT, slot);
 }
 
+static inline bool input_is_mt_value(int axis)
+{
+	return axis >= ABS_MT_FIRST && axis <= ABS_MT_LAST;
+}
+
 static inline bool input_is_mt_axis(int axis)
 {
-	return axis == ABS_MT_SLOT ||
-		(axis >= ABS_MT_FIRST && axis <= ABS_MT_LAST);
+	return axis == ABS_MT_SLOT || input_is_mt_value(axis);
 }
 
 void input_mt_report_slot_state(struct input_dev *dev,
-- 
1.7.8.1


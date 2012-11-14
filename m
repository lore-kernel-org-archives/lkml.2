Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423122Ab2KNQBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:01:50 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38882 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423000Ab2KNP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:59:54 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/14] Input: introduce EV_MSC Timestamp
Date: Wed, 14 Nov 2012 16:59:21 +0100
Message-Id: <1352908766-4492-10-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices provides the actual timestamp (hid_dg_scan_time in win8 ones)
computed by the hardware itself. This value is global to the frame and is
not specific to the multitouch protocol.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/event-codes.txt | 11 +++++++++++
 include/linux/input.h               |  1 +
 2 files changed, 12 insertions(+)

diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index 53305bd..f1ea2c6 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -196,6 +196,17 @@ EV_MSC:
 EV_MSC events are used for input and output events that do not fall under other
 categories.
 
+A few EV_MSC codes have special meaning:
+
+* MSC_TIMESTAMP:
+  - Used to report the number of microseconds since the last reset. This event
+    should be coded as an uint32 value, which is allowed to wrap around with
+    no special consequence. It is assumed that the time difference between two
+    consecutive events is reliable on a reasonable time scale (hours).
+    A reset to zero can happen, in which case the time since the last event is
+    unknown.  If the device does not provide this information, the driver must
+    not provide it to user space.
+
 EV_LED:
 ----------
 EV_LED events are used for input and output to set and query the state of
diff --git a/include/linux/input.h b/include/linux/input.h
index ba48743..25354f3 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -858,6 +858,7 @@ struct input_keymap_entry {
 #define MSC_GESTURE		0x02
 #define MSC_RAW			0x03
 #define MSC_SCAN		0x04
+#define MSC_TIMESTAMP		0x05
 #define MSC_MAX			0x07
 #define MSC_CNT			(MSC_MAX+1)
 
-- 
1.8.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2EDMyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:54:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59011 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab2EDMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:54:12 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] input: Introduce MT_CENTER_X and MT_CENTER_Y
Date: Fri,  4 May 2012 14:53:49 +0200
Message-Id: <1336136030-18503-5-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Microsoft published a new version of their multitouch specification.
They introduced a new multitouch field: MT_CENTER_X|Y.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 Documentation/input/multi-touch-protocol.txt |   14 ++++++++++++--
 include/linux/input.h                        |    8 +++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 543101c..289951c 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -254,11 +254,21 @@ between. In such cases, the range of ABS_MT_ORIENTATION should be [0, 1]
 
 ABS_MT_POSITION_X
 
-The surface X coordinate of the center of the touching ellipse.
+The surface X coordinate of the point the user intended to touch.
 
 ABS_MT_POSITION_Y
 
-The surface Y coordinate of the center of the touching ellipse.
+The surface Y coordinate of the point the user intended to touch.
+
+ABS_MT_CENTER_X
+
+The surface X coordinate of the center of the touching ellipse. This field is
+introduced by Windows 8 multitouch protocol.
+
+ABS_MT_CENTER_Y
+
+The surface Y coordinate of the center of the touching ellipse. This field is
+introduced by Windows 8 multitouch protocol.
 
 ABS_MT_TOOL_TYPE
 
diff --git a/include/linux/input.h b/include/linux/input.h
index a816714..5b0dfe2 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -806,18 +806,20 @@ struct input_keymap_entry {
 #define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
 #define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis (omit if circular) */
 #define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
-#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
-#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
+#define ABS_MT_POSITION_X	0x35	/* X the user intended to touch */
+#define ABS_MT_POSITION_Y	0x36	/* Y the user intended to touch */
 #define ABS_MT_TOOL_TYPE	0x37	/* Type of touching device */
 #define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
 #define ABS_MT_TRACKING_ID	0x39	/* Unique ID of initiated contact */
 #define ABS_MT_PRESSURE		0x3a	/* Pressure on contact area */
 #define ABS_MT_DISTANCE		0x3b	/* Contact hover distance */
+#define ABS_MT_CENTER_X		0x3c	/* Center X ellipse position */
+#define ABS_MT_CENTER_Y		0x3d	/* Center Y ellipse position */
 
 #ifdef __KERNEL__
 /* Implementation details, userspace should not care about these */
 #define ABS_MT_FIRST		ABS_MT_TOUCH_MAJOR
-#define ABS_MT_LAST		ABS_MT_DISTANCE
+#define ABS_MT_LAST		ABS_MT_CENTER_Y
 #endif
 
 #define ABS_MAX			0x3f
-- 
1.7.7.6


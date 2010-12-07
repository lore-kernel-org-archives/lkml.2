Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0LGI2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:28:47 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:48369 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460Ab0LGI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:28:46 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Add hovering distance axis
Date: Tue,  7 Dec 2010 09:27:48 +0100
Message-Id: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PPsty-0000G0-B7.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PPsty-0000G0-B7 ce311d19cb59ed3ffa756e27d5bed1c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Touch devices capable of hovering, i.e., fingers detected a distance
from the surface, are not supported by the current input MT
protocol. This patch adds ABS_MT_DISTANCE, which may be used to
indicate the distance between the contact and the surface.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/multi-touch-protocol.txt |    9 ++++++++-
 include/linux/input.h                        |    3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index bdcba15..07215fa 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -161,7 +161,8 @@ against the glass. The inner region will increase, and in general, the
 ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR, which is always smaller than
 unity, is related to the contact pressure. For pressure-based devices,
 ABS_MT_PRESSURE may be used to provide the pressure on the contact area
-instead.
+instead. Devices capable of contact hovering can use ABS_MT_DISTANCE to
+indicate the distance between the contact and the surface.
 
 In addition to the MAJOR parameters, the oval shape of the contact can be
 described by adding the MINOR parameters, such that MAJOR and MINOR are the
@@ -213,6 +214,12 @@ The pressure, in arbitrary units, on the contact area. May be used instead
 of TOUCH and WIDTH for pressure-based devices or any device with a spatial
 signal intensity distribution.
 
+ABS_MT_DISTANCE
+
+The distance, in surface units, between the contact and the surface. Zero
+distance means the contact is touching the surface. A positive number means
+the contact is hovering above the surface.
+
 ABS_MT_ORIENTATION
 
 The orientation of the ellipse. The value should describe a signed quarter
diff --git a/include/linux/input.h b/include/linux/input.h
index 1fc268b..08013aa 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -766,11 +766,12 @@ struct input_keymap_entry {
 #define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
 #define ABS_MT_TRACKING_ID	0x39	/* Unique ID of initiated contact */
 #define ABS_MT_PRESSURE		0x3a	/* Pressure on contact area */
+#define ABS_MT_DISTANCE		0x3b	/* Contact hover distance */
 
 #ifdef __KERNEL__
 /* Implementation details, userspace should not care about these */
 #define ABS_MT_FIRST		ABS_MT_TOUCH_MAJOR
-#define ABS_MT_LAST		ABS_MT_PRESSURE
+#define ABS_MT_LAST		ABS_MT_DISTANCE
 #endif
 
 #define ABS_MAX			0x3f
-- 
1.7.1


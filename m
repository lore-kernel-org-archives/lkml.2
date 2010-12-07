Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0LGL31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:29:27 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:49528 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184Ab0LGL3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:29:25 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Add an envelope tool type
Date: Tue,  7 Dec 2010 12:29:00 +0100
Message-Id: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PPvjG-0002Ob-Ch.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PPvjG-0002Ob-Ch a53079a8c984bd697f611bb097e4be98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some touch devices are capable of detecting the envelope or hull
of the touches, but not the touches themselves. This patch adds
the MT_TOOL_ENVELOPE touch type to be used for such devices.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi all,

This patch represents an MT solution for those devices that can detect
and report some effects of dual touch, but cannot report individual
contacts. Synaptics and elantech are two examples. Having the drivers
report the bounding rectangle of the touches is useful in userland,
since the information makes it possible to implement zooming
gestures. At the same time, it would be confusing to send these
envelope points as fingers, since they clearly are not. As a remedy,
introduce MT_TOOL_ENVELOPE, which tells applications that care about
details that these are not real fingers, at the same time as it allows
gesture applications based on MT data to function without
modification.

Thanks,
Henrik

 Documentation/input/multi-touch-protocol.txt |    5 +++--
 include/linux/input.h                        |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index bdcba15..690dd11 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -240,7 +240,7 @@ ABS_MT_TOOL_TYPE
 The type of approaching tool. A lot of kernel drivers cannot distinguish
 between different tool types, such as a finger or a pen. In such cases, the
 event should be omitted. The protocol currently supports MT_TOOL_FINGER and
-MT_TOOL_PEN [2].
+MT_TOOL_PEN and MT_TOOL_ENVELOPE [2].
 
 ABS_MT_BLOB_ID
 
@@ -312,7 +312,8 @@ where examples can be found.
 [1] With the extension ABS_MT_APPROACH_X and ABS_MT_APPROACH_Y, the
 difference between the contact position and the approaching tool position
 could be used to derive tilt.
-[2] The list can of course be extended.
+[2] ABS_MT_ENVELOPE contacts represent an envelope of the contacts rather
+than the actual contacts. Used with older, not fully MT capable, devices.
 [3] Multitouch X driver project: http://bitmath.org/code/multitouch/.
 [4] See the section on event computation.
 [5] See the section on finger tracking.
diff --git a/include/linux/input.h b/include/linux/input.h
index dd7c0fc..329dc0e 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -848,6 +848,8 @@ struct input_keymap_entry {
  */
 #define MT_TOOL_FINGER		0
 #define MT_TOOL_PEN		1
+#define MT_TOOL_ENVELOPE	2
+#define MT_TOOL_MAX		2
 
 /*
  * Values describing the status of a force-feedback effect
-- 
1.7.1


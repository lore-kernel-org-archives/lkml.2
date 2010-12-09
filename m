Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0LIVW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:22:57 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:37666 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756957Ab0LIVW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:22:56 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Interface and MT_TOOL documentation updates
Date: Thu,  9 Dec 2010 22:22:12 +0100
Message-Id: <1291929732-5989-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQnwP-0001ef-4D.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQnwP-0001ef-4D c453136edcc8115fed47e99ae9a79765
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent input-mt interface changes together with
recent discussions about pen and touch and support
for legacy multitouch pads suggest that the documentation
on MT tool types be expanded. This patch adds references
to the new interface, and adds a section for MT_TOOL types,
in particular documenting the use of MT_TOOL_ENVELOPE.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/multi-touch-protocol.txt |   37 ++++++++++++++++++-------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 351fab8..e190943 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -169,12 +169,14 @@ described by adding the MINOR parameters, such that MAJOR and MINOR are the
 major and minor axis of an ellipse. Finally, the orientation of the oval
 shape can be describe with the ORIENTATION parameter.
 
+For type A devices, further specification of the touch shape is possible
+via ABS_MT_BLOB_ID.
+
 The ABS_MT_TOOL_TYPE may be used to specify whether the touching tool is a
-contact or a pen or something else.  Devices with more granular information
-may specify general shapes as blobs, i.e., as a sequence of rectangular
-shapes grouped together by an ABS_MT_BLOB_ID. Finally, for the few devices
-that currently support it, the ABS_MT_TRACKING_ID event may be used to
-report contact tracking from hardware [5].
+contact or a pen or something else. Finally, the ABS_MT_TRACKING_ID event
+may be used to track identified contacts over time [5]. In the type B
+protocol, the use of ABS_MT_TOOL_TYPE and ABS_MT_TRACKING_ID is implicit
+via the input_mt_report_slot_state() function.
 
 
 Event Semantics
@@ -247,21 +249,34 @@ ABS_MT_TOOL_TYPE
 The type of approaching tool. A lot of kernel drivers cannot distinguish
 between different tool types, such as a finger or a pen. In such cases, the
 event should be omitted. The protocol currently supports MT_TOOL_FINGER and
-MT_TOOL_PEN and MT_TOOL_ENVELOPE [2].
+MT_TOOL_PEN and MT_TOOL_ENVELOPE [2]. For type B devices, this event is
+handled by input core, via the input_mt interface.
+
+- The MT_TOOL_FINGER type is the default, and represents a finger touch.
+
+- The MT_TOOL_PEN type represents a pen, and the list of related tools is
+expected to grow with time.
+
+- The MT_TOOL_ENVELOPE type is used to indicate that the contact position
+is not well-defined, and is only used for legacy hardware. The real contact
+positions are to be found within the bounding rectangle formed by the
+envelope contact positions.
 
 ABS_MT_BLOB_ID
 
 The BLOB_ID groups several packets together into one arbitrarily shaped
-contact. This is a low-level anonymous grouping for type A devices, and
+contact. The sequence of points forms a polygon which defines the shape of
+the contact. This is a low-level anonymous grouping for type A devices, and
 should not be confused with the high-level trackingID [5]. Most type A
 devices do not have blob capability, so drivers can safely omit this event.
 
 ABS_MT_TRACKING_ID
 
 The TRACKING_ID identifies an initiated contact throughout its life cycle
-[5]. This event is mandatory for type B devices. The value range of the
-TRACKING_ID should be large enough to ensure unique identification of a
-contact maintained over an extended period of time.
+[5]. The value range of the TRACKING_ID should be large enough to ensure
+unique identification of a contact maintained over an extended period of
+time. For type B devices, this event is handled by input core, via the
+input_mt interface.
 
 
 Event Computation
@@ -321,6 +336,6 @@ difference between the contact position and the approaching tool position
 could be used to derive tilt.
 [2] ABS_MT_ENVELOPE contacts represent an envelope of the contacts rather
 than the actual contacts. Used with older, not fully MT capable, devices.
-[3] Multitouch X driver project: http://bitmath.org/code/multitouch/.
+[3] The mtdev project: http://bitmath.org/code/mtdev/.
 [4] See the section on event computation.
 [5] See the section on finger tracking.
-- 
1.7.1


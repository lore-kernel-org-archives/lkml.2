Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0LQNNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:13:14 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:38858 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051Ab0LQNNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:13:12 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Document interface updates
Date: Fri, 17 Dec 2010 14:12:52 +0100
Message-Id: <1292591572-4067-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTa7H-0006y3-9m.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PTa7H-0006y3-9m fc701f14ed42d5305085989cef1fe5e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the recent input-mt interface changes.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/multi-touch-protocol.txt |   27 +++++++++++++++----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 07215fa..77ec34f 100644
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
+protocol, ABS_MT_TOOL_TYPE and ABS_MT_TRACKING_ID are implicitly handled by
+input core; drivers should instead call input_mt_report_slot_state().
 
 
 Event Semantics
@@ -247,21 +249,24 @@ ABS_MT_TOOL_TYPE
 The type of approaching tool. A lot of kernel drivers cannot distinguish
 between different tool types, such as a finger or a pen. In such cases, the
 event should be omitted. The protocol currently supports MT_TOOL_FINGER and
-MT_TOOL_PEN [2].
+MT_TOOL_PEN [2]. For type B devices, this event is handled by input core;
+drivers should instead use input_mt_report_slot_state().
 
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
+time. For type B devices, this event is handled by input core; drivers
+should instead use input_mt_report_slot_state().
 
 
 Event Computation
@@ -320,6 +325,6 @@ where examples can be found.
 difference between the contact position and the approaching tool position
 could be used to derive tilt.
 [2] The list can of course be extended.
-[3] Multitouch X driver project: http://bitmath.org/code/multitouch/.
+[3] The mtdev project: http://bitmath.org/code/mtdev/.
 [4] See the section on event computation.
 [5] See the section on finger tracking.
-- 
1.7.2.3


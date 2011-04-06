Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1DFUTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:19:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34888 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab1DFUTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:19:40 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH v4] Documentation: Add evdev type and code definitions (changes)
Date: Wed,  6 Apr 2011 16:19:32 -0400
Message-Id: <1302121172-16703-2-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302121172-16703-1-git-send-email-chase.douglas@canonical.com>
References: <1302121172-16703-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the documentation is getting longer, having a diff between revisions
is helpful. Please use this only as informational, and reply only to the
proposed patch.

Thanks,

-- Chase

diff --git a/Documentation/input/evdev-codes.txt b/Documentation/input/evdev-codes.txt
index 473ce9d..b50bc49 100644
--- a/Documentation/input/evdev-codes.txt
+++ b/Documentation/input/evdev-codes.txt
@@ -2,6 +2,12 @@ The evdev protocol uses a map of types and codes to express input device values
 to userspace. This document describes the types and codes and how and when they
 may be used.
 
+A single hardware event generates multiple input events. Each input event
+contains the new value of a single data item. A special event type, EV_SYN, is
+used to separate input events into packets of input data changes occurring at
+the same moment in time. In the following, the term "event" refers to a single
+input event encompassing a type, code, and value.
+
 The evdev protocol is a stateful protocol. Events are emitted only when values
 of evdev codes have changed. However, the state is maintained within the Linux
 input subsystem; drivers do not need to maintain the state and may attempt to
@@ -22,19 +28,19 @@ for details on valid codes for each type.
     space, such as with the multitouch protocol.
 
 * EV_KEY:
-  - Used to describe keyboard and other key-like input events.
+  - Used to describe state changes of keyboards, buttons, or other key-like
+    devices.
 
 * EV_REL:
-  - Used to describe relative input events, e.g. moving the mouse 5 units to the
-    left.
+  - Used to describe relative axis value changes, e.g. moving the mouse 5 units
+    to the left.
 
 * EV_ABS:
-  - Used to describe absolute input events, e.g. describing the coordinates of a
-    touch on a touchscreen.
+  - Used to describe absolute axis value changes, e.g. describing the
+    coordinates of a touch on a touchscreen.
 
 * EV_MSC:
-  - Used to describe miscellaneous input events that do not fit into other
-    types.
+  - Used to describe miscellaneous input data that do not fit into other types.
 
 * EV_SW:
   - Used to describe binary state input switches.
@@ -63,14 +69,14 @@ Codes define the precise type of event.
 
 EV_SYN:
 ----------
-EV_SYN event values are undefined. Their usage is
-defined only by when they are sent in the evdev event stream.
+EV_SYN event values are undefined. Their usage is defined only by when they are
+sent in the evdev event stream.
 
 * SYN_REPORT:
-  - Used to synchronize and separate events into frames of time. For example,
-    motion of a mouse may set the REL_X and REL_Y values for one motion, then
-    emit a SYN_REPORT. The next motion will emit more REL_X and REL_Y values and
-    send another SYN_REPORT.
+  - Used to synchronize and separate events into packets of input data changes
+    occurring at the same moment in time. For example, motion of a mouse may set
+    the REL_X and REL_Y values for one motion, then emit a SYN_REPORT. The next
+    motion will emit more REL_X and REL_Y values and send another SYN_REPORT.
 
 * SYN_CONFIG:
   - TBD
@@ -157,9 +163,10 @@ A few EV_ABS codes have special meanings:
 
 * ABS_DISTANCE:
   - Used to describe the distance of a tool from an interaction surface. This
-    should only be used while the tool is hovering, meaning in close proximity
-    of the device. If the input device may be used freely in three dimensions,
-    consider ABS_Z instead.
+    event should only be emitted while the tool is hovering, meaning in close
+    proximity of the device and while the value of the BTN_TOUCH code is 0. If
+    the input device may be used freely in three dimensions, consider ABS_Z
+    instead.
 
 * ABS_MT_<name>:
   - Used to describe multitouch input events. Please see
@@ -224,8 +231,8 @@ Touchscreens:
 ----------
 ABS_{X,Y} must be reported with the location of the touch. BTN_TOUCH must be
 used to report when a touch is active on the screen.
-BTN_{MOUSE,LEFT,MIDDLE,RIGHT} must not be reported. BTN_TOOL_<name> events
-should be reported where possible.
+BTN_{MOUSE,LEFT,MIDDLE,RIGHT} must not be reported as the result of touch
+contact. BTN_TOOL_<name> events should be reported where possible.
 
 Trackpads:
 ----------
@@ -236,3 +243,14 @@ Trackpads that provide absolute touch position must report ABS_{X,Y} for the
 location of the touch. BTN_TOUCH should be used to report when a touch is active
 on the trackpad. Where multi-finger support is available, BTN_TOOL_<name> should
 be used to report the number of touches active on the trackpad.
+
+Tablets:
+----------
+BTN_TOOL_<name> events must be reported when a stylus or other tool is active on
+the tablet. ABS_{X,Y} must be reported with the location of the tool. BTN_TOUCH
+should be used to report when the tool is in contact with the tablet.
+BTN_{STYLUS,STYLUS2} should be used to report buttons on the tool itself. Any
+button may be used for buttons on the tablet except BTN_{MOUSE,LEFT}.
+BTN_{0,1,2,etc} are good generic codes for unlabeled buttons. Do not use
+meaningful buttons, like BTN_FORWARD, unless the button is labeled for that
+purpose on the device.

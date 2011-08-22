Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab1HVLHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:07:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab1HVLGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:06:18 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 6/9 v5] Input: mt - document devices reporting more touches than slots
Date: Mon, 22 Aug 2011 19:06:00 +0800
Message-Id: <1314011163-19098-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
References: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices are capable of identifying and/or tracking more contacts than
they can report to the driver.  Document how a driver should handle this,
and what userspace should expect.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 Documentation/input/multi-touch-protocol.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 71536e7..543101c 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -65,6 +65,20 @@ the full state of each initiated contact has to reside in the receiving
 end.  Upon receiving an MT event, one simply updates the appropriate
 attribute of the current slot.
 
+Some devices identify and/or track more contacts than they can report to the
+driver.  A driver for such a device should associate one type B slot with each
+contact that is reported by the hardware.  Whenever the identity of the
+contact associated with a slot changes, the driver should invalidate that
+slot by changing its ABS_MT_TRACKING_ID.  If the hardware signals that it is
+tracking more contacts than it is currently reporting, the driver should use
+a BTN_TOOL_*TAP event to inform userspace of the total number of contacts
+being tracked by the hardware at that moment.  The driver should do this by
+explicitly sending the corresponding BTN_TOOL_*TAP event and setting
+use_count to false when calling input_mt_report_pointer_emulation().
+The driver should only advertise as many slots as the hardware can report.
+Userspace can detect that a driver can report more total contacts than slots
+by noting that the largest supported BTN_TOOL_*TAP event is larger than the
+total number of type B slots reported in the absinfo for the ABS_MT_SLOT axis.
 
 Protocol Example A
 ------------------
-- 
1.7.3.1


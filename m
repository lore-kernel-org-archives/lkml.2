Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0CTWjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 18:39:51 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:34032 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab0CTWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 18:39:50 -0400
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Mar 2010 18:39:49 EDT
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: clarify the no-finger event
Date: Sat, 20 Mar 2010 23:18:06 +0100
Message-Id: <1269123486-2621-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Nt715-0001hk-8J.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Nt715-0001hk-8J b566bcc121e80b1375525bc77e22075d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current documentation does not explicitly specify how to report
zero fingers, leaving a potential problem in the driver implementations
and giving no parsing directive to userland. This patch defines two
equally valid ways.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/multi-touch-protocol.txt |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 8490480..eacb226 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -68,6 +68,22 @@ like:
    SYN_MT_REPORT
    SYN_REPORT
 
+Here is the sequence after lifting one of the fingers:
+
+   ABS_MT_POSITION_X
+   ABS_MT_POSITION_Y
+   SYN_MT_REPORT
+   SYN_REPORT
+
+And here is the sequence after lifting the remaining finger:
+
+   SYN_MT_REPORT
+   SYN_REPORT
+
+If the driver reports one of BTN_TOUCH or ABS_PRESSURE in addition to the
+ABS_MT events, the last SYN_MT_REPORT event may be omitted. Otherwise, the
+last SYN_REPORT will be dropped by the input core, resulting in no
+zero-finger event reaching userland.
 
 Event Semantics
 ---------------
-- 
1.6.3.3


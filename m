Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0H3LFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:05:13 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36971 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261Ab0H3LFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:05:11 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: bcm5974: Adjust major / minor to scale
Date: Mon, 30 Aug 2010 13:04:29 +0200
Message-Id: <1283166269-2302-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Oq2AO-0006Rj-9r.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Oq2AO-0006Rj-9r 3a9566b8cd19922441d4c21fe71d7932
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By visual inspection, the reported touch_major and touch_minor axes
are a factor of two too small. Presumably the device actually reports
the semi-major and semi-minor axes. Corrected with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ea67c49..b952317 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -337,10 +337,14 @@ static void report_finger_data(struct input_dev *input,
 			       const struct bcm5974_config *cfg,
 			       const struct tp_finger *f)
 {
-	input_report_abs(input, ABS_MT_TOUCH_MAJOR, raw2int(f->force_major));
-	input_report_abs(input, ABS_MT_TOUCH_MINOR, raw2int(f->force_minor));
-	input_report_abs(input, ABS_MT_WIDTH_MAJOR, raw2int(f->size_major));
-	input_report_abs(input, ABS_MT_WIDTH_MINOR, raw2int(f->size_minor));
+	input_report_abs(input, ABS_MT_TOUCH_MAJOR,
+			 raw2int(f->force_major) << 1);
+	input_report_abs(input, ABS_MT_TOUCH_MINOR,
+			 raw2int(f->force_minor) << 1);
+	input_report_abs(input, ABS_MT_WIDTH_MAJOR,
+			 raw2int(f->size_major) << 1);
+	input_report_abs(input, ABS_MT_WIDTH_MINOR,
+			 raw2int(f->size_minor) << 1);
 	input_report_abs(input, ABS_MT_ORIENTATION,
 			 MAX_FINGER_ORIENTATION - raw2int(f->orientation));
 	input_report_abs(input, ABS_MT_POSITION_X, raw2int(f->abs_x));
-- 
1.7.1


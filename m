Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0ISI46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 04:56:58 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:44232 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654Ab0ISI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 04:56:57 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] hid: 3m: Output proper orientation range
Date: Sun, 19 Sep 2010 10:56:03 +0200
Message-Id: <1284886564-30928-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OxFhB-0001oI-6U.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OxFhB-0001oI-6U 04bf2752b60efe7ad6f98b838a680e4e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The range of orientation values for height/width devices should
be [0, 1], but is currently set to [1, 1]. Having min == max also
breaks uinput device setup. Fixed with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-3m-pct.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index cd4b125..860d47c 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -110,7 +110,7 @@ static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			input_set_abs_params(hi->input, ABS_MT_TOUCH_MINOR,
 					     f1, f2, df / SN_WIDTH, 0);
 			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
-					1, 1, 0, 0);
+					0, 1, 0, 0);
 			return 1;
 		case HID_DG_CONTACTID:
 			field->logical_maximum = MAX_TRKID;
-- 
1.7.1


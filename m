Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab1CRN2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:28:44 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:39060 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab1CRN1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:27:48 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] hid-multitouch: refactor initialization of ABS_MT_ORIENTATION
Date: Fri, 18 Mar 2011 14:27:55 +0100
Message-Id: <1300454876-5017-5-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No semantic changes, it's just easier to read the code.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Reviewed-by: Stéphane Chatty <chatty@enac.fr>
---

new in v3

 drivers/hid/hid-multitouch.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e6e1ea2..d31301e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -235,9 +235,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
-			field->logical_maximum = 1;
-			field->logical_minimum = 0;
-			set_abs(hi->input, ABS_MT_ORIENTATION, field, 0);
+			input_set_abs_params(hi->input,
+					ABS_MT_ORIENTATION, 0, 1, 0, 0);
 			td->last_slot_field = usage->hid;
 			return 1;
 		case HID_DG_TIPPRESSURE:
-- 
1.7.4


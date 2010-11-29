Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0K2Ho0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 02:44:26 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:56976 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150Ab0K2HoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 02:44:24 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 4/7] hid: egalax: Report zero as minimum pressure (rev2)
Date: Mon, 29 Nov 2010 08:43:29 +0100
Message-Id: <1291016612-25102-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PMyOz-0000Ug-Cs.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PMyOz-0000Ug-Cs 45a928fcbd1b5db0aa8f56d95b09df38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware reports a logical minimum of one, but in order for
userspace applications to correctly map all reported values to
non-zero pressure, the driver needs to report a logical minimum of
zero.  Fixed with this patch.

Tested-by: Philipp Merkel <mail@philmerk.de>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-egalax.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index b3a1139..a6ab617 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -90,6 +90,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			set_abs(input, ABS_MT_TRACKING_ID, field, 0);
 			return 1;
 		case HID_DG_TIPPRESSURE:
+			field->logical_minimum = 0;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_PRESSURE);
 			set_abs(input, ABS_MT_PRESSURE, field, 0);
-- 
1.7.1


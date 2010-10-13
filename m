Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0JMOAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:00:34 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:50935 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703Ab0JMOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:00:31 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 4/6] hid: egalax: Report zero as minimum pressure
Date: Wed, 13 Oct 2010 15:58:20 +0200
Message-Id: <1286978302-30034-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P61rX-00076t-8q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1P61rX-00076t-8q fa791d5f350111384df4b3be89e29624
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
index 3b490a3..2aba897 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -93,6 +93,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			input_set_events_per_packet(input, MAX_EVENTS);
 			return 1;
 		case HID_DG_TIPPRESSURE:
+			field->logical_minimum = 0;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_PRESSURE);
 			set_abs(input, ABS_MT_PRESSURE, field, 0);
-- 
1.7.1


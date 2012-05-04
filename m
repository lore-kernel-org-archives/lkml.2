Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2EDMzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:55:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56751 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab2EDMyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:54:09 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] HID: hid-multitouch: support arrays for the split of the touches in a report
Date: Fri,  4 May 2012 14:53:48 +0200
Message-Id: <1336136030-18503-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Win8 certification introduced the ability to transmit two X and two Y per
touch. The specification precises that it must be in an array, with a
report count == 2.

This test guarantees that we split the touches on the last element
in this array.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e205d1e..3ee22ec 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -589,7 +589,10 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			return 0;
 		}
 
-		if (usage->hid == td->last_slot_field)
+		if (usage->hid == td->last_slot_field &&
+			usage == &field->usage[field->maxusage - 1])
+			/* we only take into account the last report
+			 * of a field if report_count > 1 */
 			mt_complete_slot(td);
 
 		if (field->index == td->last_field_index
-- 
1.7.7.6


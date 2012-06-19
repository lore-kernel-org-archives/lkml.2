Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2FSMkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:40:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54214 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2FSMkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:40:14 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] HID: hid-multitouch: support arrays for the split of the touches in a report
Date: Tue, 19 Jun 2012 14:39:53 +0200
Message-Id: <1340109594-10732-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
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
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 9a3891e..a5ef877 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -601,7 +601,10 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
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
1.7.10.2


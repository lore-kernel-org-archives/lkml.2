Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0LJD3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:29:33 -0500
Received: from mail.perches.com ([173.55.12.10]:2469 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab0LJD3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:29:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] hid: Remove unnecessary multiplies from loops
Date: Thu,  9 Dec 2010 19:29:06 -0800
Message-Id: <67316ae8b002a45449b518f5414d3d6133fa8640.1291951482.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
In-Reply-To: <cover.1291951482.git.joe@perches.com>
References: <cover.1291951482.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use += instead of multiply.
Use correct indentation.
Move logical tests continuations to the more commonly used
end of previous line.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-core.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d6dffcc..932266a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -897,33 +897,41 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
 	for (n = 0; n < count; n++) {
 
 		value[n] = min < 0 ?
-			snto32(extract(hid, data, offset + n * size, size),
-			       size) :
-			extract(hid, data, offset + n * size, size);
+			snto32(extract(hid, data, offset, size), size) :
+			extract(hid, data, offset, size);
 
 		/* Ignore report if ErrorRollOver */
 		if (!(field->flags & HID_MAIN_ITEM_VARIABLE) &&
 		    value[n] >= min && value[n] <= max &&
 		    field->usage[value[n] - min].hid == HID_UP_KEYBOARD + 1)
 			goto exit;
+
+		offset += size;
 	}
 
 	for (n = 0; n < count; n++) {
 
 		if (HID_MAIN_ITEM_VARIABLE & field->flags) {
-			hid_process_event(hid, field, &field->usage[n], value[n], interrupt);
+			hid_process_event(hid, field, &field->usage[n],
+					  value[n], interrupt);
 			continue;
 		}
 
-		if (field->value[n] >= min && field->value[n] <= max
-			&& field->usage[field->value[n] - min].hid
-			&& search(value, field->value[n], count))
-				hid_process_event(hid, field, &field->usage[field->value[n] - min], 0, interrupt);
-
-		if (value[n] >= min && value[n] <= max
-			&& field->usage[value[n] - min].hid
-			&& search(field->value, value[n], count))
-				hid_process_event(hid, field, &field->usage[value[n] - min], 1, interrupt);
+		if (field->value[n] >= min &&
+		    field->value[n] <= max &&
+		    field->usage[field->value[n] - min].hid &&
+		    search(value, field->value[n], count))
+			hid_process_event(hid, field,
+					  &field->usage[field->value[n] - min],
+					  0, interrupt);
+
+		if (value[n] >= min &&
+		    value[n] <= max &&
+		    field->usage[value[n] - min].hid &&
+		    search(field->value, value[n], count))
+			hid_process_event(hid, field,
+					  &field->usage[value[n] - min],
+					  1, interrupt);
 	}
 
 	memcpy(field->value, value, count * sizeof(__s32));
@@ -945,11 +953,11 @@ static void hid_output_field(const struct hid_device *hid,
 
 	for (n = 0; n < count; n++) {
 		if (field->logical_minimum < 0)	/* signed values */
-			implement(hid, data, offset + n * size, size,
+			implement(hid, data, offset, size,
 				  s32ton(field->value[n], size));
 		else				/* unsigned values */
-			implement(hid, data, offset + n * size, size,
-				  field->value[n]);
+			implement(hid, data, offset, size, field->value[n]);
+		offset += size;
 	}
 }
 
-- 
1.7.3.3.464.gf80b6


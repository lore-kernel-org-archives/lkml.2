Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423111Ab2KNQB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:01:28 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38882 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423016Ab2KNP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:59:56 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/14] Input: mt: add input_mt_is_used
Date: Wed, 14 Nov 2012 16:59:22 +0100
Message-Id: <1352908766-4492-11-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extracts the test (slot->frame == mt->frame) so that it can
be used in third party drivers.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/input/input-mt.c | 2 +-
 include/linux/input/mt.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c0ec7d4..475b9d4 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -247,7 +247,7 @@ void input_mt_sync_frame(struct input_dev *dev)
 
 	if (mt->flags & INPUT_MT_DROP_UNUSED) {
 		for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
-			if (s->frame == mt->frame)
+			if (input_mt_is_used(mt, s))
 				continue;
 			input_mt_slot(dev, s - mt->slots);
 			input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index cc5cca7..2e86bd0 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -69,6 +69,12 @@ static inline bool input_mt_is_active(const struct input_mt_slot *slot)
 	return input_mt_get_value(slot, ABS_MT_TRACKING_ID) >= 0;
 }
 
+static inline bool input_mt_is_used(const struct input_mt *mt,
+				    const struct input_mt_slot *slot)
+{
+	return slot->frame == mt->frame;
+}
+
 int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 			unsigned int flags);
 void input_mt_destroy_slots(struct input_dev *dev);
-- 
1.8.0


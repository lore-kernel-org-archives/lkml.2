Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0HVNrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 09:47:20 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:46965 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377Ab0HVNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 09:47:19 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] input: mt: Initialize slots to unused
Date: Sun, 22 Aug 2010 15:46:49 +0200
Message-Id: <1282484809-8554-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OnAt9-00053j-9e.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OnAt9-00053j-9e 390c654becaf956587d92262f2197469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For MT slots, the ABS_MT_TRACKING_ID determines whether a slot is in use,
but currently leaves initialization up to the drivers. This patch sets the
slot state to unused upon creation.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index a9b025f..9325844 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1599,8 +1599,9 @@ EXPORT_SYMBOL(input_free_device);
  * @dev: input device supporting MT events and finger tracking
  * @num_slots: number of slots used by the device
  *
- * This function allocates all necessary memory for MT slot handling
- * in the input device, and adds ABS_MT_SLOT to the device capabilities.
+ * This function allocates all necessary memory for MT slot handling in the
+ * input device, and adds ABS_MT_SLOT to the device capabilities. All slots
+ * are initially unused with ABS_MT_TRACKING_ID == -1.
  */
 int input_mt_create_slots(struct input_dev *dev, unsigned int num_slots)
 {
@@ -1613,6 +1614,8 @@ int input_mt_create_slots(struct input_dev *dev, unsigned int num_slots)
 
 	dev->mtsize = num_slots;
 	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
+	while (num_slots--)
+		dev->mt[num_slots].abs[ABS_MT_TRACKING_ID - ABS_MT_FIRST] = -1;
 
 	return 0;
 }
-- 
1.7.1


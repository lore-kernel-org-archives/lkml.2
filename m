Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1CJEeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:34:18 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:48017 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1CJEeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:34:15 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr, Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 1/2] hid: ntrig NO_INIT_REPORTS
Date: Wed,  9 Mar 2011 23:33:51 -0500
Message-Id: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.4.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-10_03:2011-03-10,2011-03-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probing reports does bad things with some ntrig firmwares, better to
just leave them alone.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

---

This resolves an annoying delay on initialization and reduces the
chance of the device coming up in an odd state or crashing.
---
 drivers/hid/hid-ntrig.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index b1e9cca..850ba14 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -837,7 +837,8 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct hid_report *report;
 
 	if (id->driver_data)
-		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+		hdev->quirks |= HID_QUIRK_MULTI_INPUT
+				| HID_QUIRK_NO_INIT_REPORTS;
 
 	nd = kmalloc(sizeof(struct ntrig_data), GFP_KERNEL);
 	if (!nd) {
-- 
1.7.4.1


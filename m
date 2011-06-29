Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1F2FJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:09:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60273 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1F2FID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:03 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 08/12] Input: synaptics - rename set_slot to be more descriptive
Date: Wed, 29 Jun 2011 13:07:18 +0800
Message-Id: <1309324042-22943-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4e5e454..0a51b0ba 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -489,7 +489,8 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 	return 0;
 }
 
-static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
+static void synaptics_report_semi_mt_slot(struct input_dev *dev, int slot,
+					  bool active, int x, int y)
 {
 	input_mt_slot(dev, slot);
 	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
@@ -505,14 +506,16 @@ static void synaptics_report_semi_mt_data(struct input_dev *dev,
 					  int num_fingers)
 {
 	if (num_fingers >= 2) {
-		set_slot(dev, 0, true, min(a->x, b->x), min(a->y, b->y));
-		set_slot(dev, 1, true, max(a->x, b->x), max(a->y, b->y));
+		synaptics_report_semi_mt_slot(dev, 0, true, min(a->x, b->x),
+					      min(a->y, b->y));
+		synaptics_report_semi_mt_slot(dev, 1, true, max(a->x, b->x),
+					      max(a->y, b->y));
 	} else if (num_fingers == 1) {
-		set_slot(dev, 0, true, a->x, a->y);
-		set_slot(dev, 1, false, 0, 0);
+		synaptics_report_semi_mt_slot(dev, 0, true, a->x, a->y);
+		synaptics_report_semi_mt_slot(dev, 1, false, 0, 0);
 	} else {
-		set_slot(dev, 0, false, 0, 0);
-		set_slot(dev, 1, false, 0, 0);
+		synaptics_report_semi_mt_slot(dev, 0, false, 0, 0);
+		synaptics_report_semi_mt_slot(dev, 1, false, 0, 0);
 	}
 }
 
-- 
1.7.3.1


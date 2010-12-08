Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0LHXIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:08:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59925 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab0LHXIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:08:11 -0500
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: magicmouse: Don't report REL_{X,Y} for Magic Trackpad
Date: Wed,  8 Dec 2010 15:08:04 -0800
Message-Id: <1291849685-2623-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent switch to having the hid layer handle standard axis
initialization, the Magic Trackpad now reports relative axes. This would
be fine in the normal mode, but the driver puts the device in multitouch
mode where no relative events are generated. Also, userspace software
depends on accurate axis information for device type detection. Thus,
ignoring the relative axes from the Magic Trackpad is best.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/hid/hid-magicmouse.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index e6dc151..ed732b7 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -433,6 +433,11 @@ static int magicmouse_input_mapping(struct hid_device *hdev,
 	if (!msc->input)
 		msc->input = hi->input;
 
+	/* Magic Trackpad does not give relative data after switching to MT */
+	if (hi->input->id.product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD &&
+	    field->flags & HID_MAIN_ITEM_RELATIVE)
+		return -1;
+
 	return 0;
 }
 
-- 
1.7.1


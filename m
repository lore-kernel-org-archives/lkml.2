Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2ENQNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:13:49 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:60069 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756897Ab2ENQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:13:48 -0400
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz
Cc: linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] HID: wacom: Remove raport header check.
Date: Mon, 14 May 2012 17:13:26 +0100
Message-Id: <1337012006-6854-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.10.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That check was valid when hid-wacom was only supporting Wacom Graphire, as the
device raports always start with 0x03. Intuos4 WL high-speed raports
begin with 0x04, so the check would be filtering out valid reports.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 29372ed..324ea74 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -578,10 +578,6 @@ static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
 	hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
 	input = hidinput->input;
 
-	/* Check if this is a tablet report */
-	if (data[0] != 0x03)
-		return 0;
-
 	switch (hdev->product) {
 	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
 		return wacom_gr_parse_report(hdev, wdata, input, data);
-- 
1.7.10.1


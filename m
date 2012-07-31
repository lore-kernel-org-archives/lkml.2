Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2GaSYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:24:05 -0400
Received: from 50.97.138.99-static.reverse.softlayer.com ([50.97.138.99]:41134
	"EHLO wren.arvixe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab2GaSYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:24:01 -0400
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz, linux-doc@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 1/2] HID: wacom: Use half of brightness for low state
Date: Tue, 31 Jul 2012 18:27:55 +0100
Message-Id: <1343755676-2999-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.11.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intuos4 WL leds have 2 states: high and low. With no activity tablet
uses low state; using pen triggers high state. Both can be set
independently, but it would require setting another led device to
control them separately. This patch uses the brightness set through leds
subsytem as high and half of that value as low.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index fe23a1e..848842e 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -91,7 +91,8 @@ static void wacom_leds_set_brightness(struct led_classdev *led_dev,
 	if (buf) {
 		buf[0] = WAC_CMD_LED_CONTROL;
 		buf[1] = led;
-		buf[2] = value;
+		buf[2] = value >> 2;
+		buf[3] = value;
 		hdev->hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
 		kfree(buf);
 	}
-- 
1.7.10.2


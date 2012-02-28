Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467Ab2B1RT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:19:59 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:52467 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756528Ab2B1RT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:19:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
	b=W5h5WzH24hXhR+HGIwJTHwXSYyQdojvAaRud2Rl9o8gGZ4TJ16gxMSRoas94mXIJqUGKwHEPUiIftpNt8vQovmIiYATK0h7hKuc7WNaiC/vUqh0L3IeBuovsNNzdYgyu;
From: Przemo Firszt <przemo@firszt.eu>
To: jkosina@suse.cz, pinglinux@gmail.com, peter.hutterer@who-t.net
Cc: linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 1/2] HID: wacom: report distance for Intuos4 WL
Date: Tue, 28 Feb 2012 17:19:04 +0000
Message-Id: <1330449545-6217-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reporting of distance of tool to the tablet surface. Maximum
reported value is 63 (0x3F).

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
---
 drivers/hid/hid-wacom.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index a3476f9..5a58db2 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -320,6 +320,7 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 			struct input_dev *input, unsigned char *data)
 {
 	__u16 x, y, pressure;
+	__u8 distance;
 
 	switch (data[1]) {
 	case 0x80: /* Out of proximity report */
@@ -353,6 +354,7 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 		y = data[4] << 9 | data[5] << 1 | (data[9] & 0x01);
 		pressure = (data[6] << 3) | ((data[7] & 0xC0) >> 5)
 			| (data[1] & 0x01);
+		distance = (data[9] >> 2) & 0x3f;
 
 		input_report_key(input, BTN_TOUCH, pressure > 1);
 
@@ -362,6 +364,7 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 		input_report_abs(input, ABS_X, x);
 		input_report_abs(input, ABS_Y, y);
 		input_report_abs(input, ABS_PRESSURE, pressure);
+		input_report_abs(input, ABS_DISTANCE, distance);
 		input_report_abs(input, ABS_MISC, wdata->id);
 		input_event(input, EV_MSC, MSC_SERIAL, wdata->serial);
 		input_report_key(input, wdata->tool, 1);
@@ -484,6 +487,7 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		input_set_abs_params(input, ABS_X, 0, 40640, 4, 0);
 		input_set_abs_params(input, ABS_Y, 0, 25400, 4, 0);
 		input_set_abs_params(input, ABS_PRESSURE, 0, 2047, 0, 0);
+		input_set_abs_params(input, ABS_DISTANCE, 0, 63, 0, 0);
 		break;
 	}
 
-- 
1.7.6.4


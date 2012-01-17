Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2AQKwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:52:15 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:40785 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab2AQKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:52:13 -0500
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ogay@logitech.com, jzanone@logitech.com
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: [PATCH 1/1] FIX mask to enable DJ mode
Date: Tue, 17 Jan 2012 11:50:11 +0100
Message-Id: <1326797411-26520-1-git-send-email-nlopezcasad@logitech.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
---
Hi everyone, 

This is a minor bug I discovered while developing the 'soon to be posted'
driver for the Logitech Unifying Wireless Touchpad.

The user can only experience the bug if she pairs 6 devices to a Unifying
receiver. The sixth paired device would not work.

The value changed is actually a bitmask that enables reporting from each
paired device. As the sixth bit was not set, the sixth device reports are
ignored by the receiver and never get to the driver.

Jiri, this is a minor change and a real bug fix which might be posted to 
stable, but as I anticipate that user impact will be really low I would say
that there is no problem on letting this fix going to your branch only.

Cheers, 
    Nestor

 drivers/hid/hid-logitech-dj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 38b12e4..2b56efc 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -445,7 +445,7 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 	dj_report.report_id = REPORT_ID_DJ_SHORT;
 	dj_report.device_index = 0xFF;
 	dj_report.report_type = REPORT_TYPE_CMD_SWITCH;
-	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x1F;
+	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
 	dj_report.report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
 	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
 }
-- 
1.7.5.3


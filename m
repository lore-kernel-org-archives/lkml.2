Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2LDPe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:34:56 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54690 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2LDPew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:34:52 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] HID: i2c-hid: i2c_hid_get_report may fail
Date: Tue,  4 Dec 2012 16:27:50 +0100
Message-Id: <1354634875-5182-10-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If i2c_hid_get_report fails, exit i2c_hid_init_report.
The printk log is already called by i2c_hid_get_report, so no need
to add some more printks.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index da04948..dcacfc4 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -400,9 +400,10 @@ static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
 	unsigned int size, ret_size;
 
 	size = i2c_hid_get_report_length(report);
-	i2c_hid_get_report(client,
+	if (i2c_hid_get_report(client,
 			report->type == HID_FEATURE_REPORT ? 0x03 : 0x01,
-			report->id, buffer, size);
+			report->id, buffer, size))
+		return;
 
 	i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, ihid->inbuf);
 
-- 
1.8.0.1


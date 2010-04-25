Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0DYUPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 16:15:49 -0400
Received: from legolas.restena.lu ([158.64.1.34]:56841 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0DYUPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 16:15:47 -0400
Date: Sun, 25 Apr 2010 21:31:40 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH] hid: fix picolcd's version parsing
Message-ID: <20100425213140.371194b0@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During grouping of version checking code bootloader mode's version
bytes got swapped. Fix their order.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 0fbc7d3..6f71c60 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1196,16 +1196,14 @@ static int picolcd_check_version(struct hid_device *hdev)
 	}
 
 	if (verinfo->raw_size == 2) {
+		data->version[0] = verinfo->raw_data[1];
+		data->version[1] = verinfo->raw_data[0];
 		if (data->status & PICOLCD_BOOTLOADER) {
 			dev_info(&hdev->dev, "PicoLCD, bootloader version %d.%d\n",
-					verinfo->raw_data[0], verinfo->raw_data[1]);
-			data->version[0] = verinfo->raw_data[0];
-			data->version[1] = verinfo->raw_data[1];
+					verinfo->raw_data[1], verinfo->raw_data[0]);
 		} else {
 			dev_info(&hdev->dev, "PicoLCD, firmware version %d.%d\n",
 					verinfo->raw_data[1], verinfo->raw_data[0]);
-			data->version[0] = verinfo->raw_data[1];
-			data->version[1] = verinfo->raw_data[0];
 		}
 	} else {
 		dev_err(&hdev->dev, "confused, got unexpected version response from PicoLCD\n");
-- 
1.6.4.4


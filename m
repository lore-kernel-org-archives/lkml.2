Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2HSReU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:34:20 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:38359 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2HSReR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:34:17 -0400
Date: Sun, 19 Aug 2012 19:33:33 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] HID: picoLCD: fix dumping of IR_DATA report
Message-ID: <20120819193333.14698886@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120819192859.74136bb0@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first payload byte indicates how many IR data bytes are following, not
including itself. The IR data bytes appear in pairs as they represent a
series of 16bit intervals.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_debugfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
index dbefab7..9683339 100644
--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -702,9 +702,9 @@ void picolcd_debug_raw_event(struct picolcd_data *data,
 			hid_debug_event(hdev, buff);
 		} else if (raw_data[1] + 1 <= size) {
 			snprintf(buff, BUFF_SZ, "\tData length: %d\n\tIR Data: ",
-					raw_data[1]-1);
+					raw_data[1]);
 			hid_debug_event(hdev, buff);
-			dump_buff_as_hex(buff, BUFF_SZ, raw_data+2, raw_data[1]-1);
+			dump_buff_as_hex(buff, BUFF_SZ, raw_data+2, raw_data[1]);
 			hid_debug_event(hdev, buff);
 		} else {
 			snprintf(buff, BUFF_SZ, "\tOverflowing data length: %d\n",
-- 
1.7.8.6


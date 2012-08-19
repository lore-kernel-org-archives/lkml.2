Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2HSRdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:33:52 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:59771 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2HSRdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:33:47 -0400
Date: Sun, 19 Aug 2012 19:33:02 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] HID: picoLCD: optimize for inactive debugfs
Message-ID: <20120819193302.71e682e9@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120819192859.74136bb0@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthieu CASTET adjusted picolcd_debug_out_report() to only operate when
there is an active listener on debugfs for events.

Do the same on the more important picolcd_debug_raw_event() that is
called in interrupt context as opposed to picolcd_debug_out_report()
which happens in whichever context that sends reports to device.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
index f18a4c2..dbefab7 100644
--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -656,7 +656,7 @@ void picolcd_debug_raw_event(struct picolcd_data *data,
 
 #define BUFF_SZ 256
 	/* Avoid unnecessary overhead if debugfs is disabled */
-	if (!hdev->debug_events)
+	if (list_empty(&hdev->debug_list))
 		return;
 
 	buff = kmalloc(BUFF_SZ, GFP_ATOMIC);
-- 
1.7.8.6


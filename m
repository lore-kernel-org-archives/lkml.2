Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab2I3UFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 16:05:23 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:48783 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2I3UFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 16:05:21 -0400
Date: Sun, 30 Sep 2012 22:04:19 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: HID: picoLCD: optimize for inactive debugfs
Message-ID: <20120930220419.01408e0e@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthieu CASTET adjusted picolcd_debug_out_report() to only operate when
there is an active listener on debugfs for events.

His change got lost while splitting hid_picolcd.c, restore it.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---


diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
index 6ef03be..4809aa1 100644
--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -402,7 +402,7 @@ void picolcd_debug_out_report(struct picolcd_data *data,
 #define BUFF_SZ 256
 
 	/* Avoid unnecessary overhead if debugfs is disabled */
-	if (!hdev->debug_events)
+	if (list_empty(&hdev->debug_list))
 		return;
 
 	buff = kmalloc(BUFF_SZ, GFP_ATOMIC);

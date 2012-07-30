Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2G3Tjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:39:37 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53134 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2G3Tja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:39:30 -0400
Date: Mon, 30 Jul 2012 21:38:54 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayalk@intworks.biz>, linux-fbdev@vger.kernel.org
Subject: [PATCH 4/7] HID: picoLCD: satify some checkpatch warnings
Message-ID: <20120730213854.4bb52224@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120730213656.0a9f6d30@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: static const char * array should probably be static const char * const
+static const char *error_codes[] = {

WARNING: min() should probably be min_t(size_t, 20, s)
+       raw_data[2] = min((size_t)20, s);

Note: the second min_t suggestion cannot be followed because GCC is not
smart enough to track constants through it and make
copy_from_user_overflow() check happy.

WARNING: min() should probably be min_t(u8, 20, raw_data[2])
+       if (copy_from_user(raw_data+3, u, min((u8)20, raw_data[2])))
                return -EFAULT;

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_debugfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
index ff74645..f2491fa 100644
--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -135,7 +135,7 @@ static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
 	memset(raw_data, 0, sizeof(raw_data));
 	raw_data[0] = *off & 0xff;
 	raw_data[1] = (*off >> 8) & 0xff;
-	raw_data[2] = min((size_t)20, s);
+	raw_data[2] = min_t(size_t, 20, s);
 	if (*off + raw_data[2] > 0xff)
 		raw_data[2] = 0x100 - *off;
 
@@ -370,7 +370,7 @@ static const struct file_operations picolcd_debug_flash_fops = {
 /*
  * Helper code for HID report level dumping/debugging
  */
-static const char *error_codes[] = {
+static const char * const error_codes[] = {
 	"success", "parameter missing", "data_missing", "block readonly",
 	"block not erasable", "block too big", "section overflow",
 	"invalid command length", "invalid data length",
-- 
1.7.8.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0L0P2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:28:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:50842 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab0L0P2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:28:07 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 1/3] HID: picolcd: fix misuse of logical operation in place of bitop
Date: Mon, 27 Dec 2010 16:27:43 +0100
Message-Id: <1293463663-21198-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.3.4.578.g6068a
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Bruno Prémont <bonbons@linux-vserver.org>
CC: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 drivers/hid/hid-picolcd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index bc2e077..0aff3cd 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1544,7 +1544,7 @@ static ssize_t picolcd_debug_eeprom_read(struct file *f, char __user *u,
 
 	/* prepare buffer with info about what we want to read (addr & len) */
 	raw_data[0] = *off & 0xff;
-	raw_data[1] = (*off >> 8) && 0xff;
+	raw_data[1] = (*off >> 8) & 0xff;
 	raw_data[2] = s < 20 ? s : 20;
 	if (*off + raw_data[2] > 0xff)
 		raw_data[2] = 0x100 - *off;
@@ -1583,7 +1583,7 @@ static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
 
 	memset(raw_data, 0, sizeof(raw_data));
 	raw_data[0] = *off & 0xff;
-	raw_data[1] = (*off >> 8) && 0xff;
+	raw_data[1] = (*off >> 8) & 0xff;
 	raw_data[2] = s < 20 ? s : 20;
 	if (*off + raw_data[2] > 0xff)
 		raw_data[2] = 0x100 - *off;
-- 
1.7.3.4.578.g6068a


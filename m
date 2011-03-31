Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab1CaSfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:35:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35088 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1CaSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:35:37 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] vt: remove uneeded retval check before tty->ops->open inside tty_open
Date: Thu, 31 Mar 2011 15:35:31 -0300
Message-Id: <1301596531-6852-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current check is uneeded, since !retval will always returns true,
as retval returned from tty_add_file is checked earlier and tty_open
exits if it's not zero.

Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/tty/tty_io.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 936a4ea..349fa67 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1902,12 +1902,10 @@ got_driver:
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "opening %s...", tty->name);
 #endif
-	if (!retval) {
-		if (tty->ops->open)
-			retval = tty->ops->open(tty, filp);
-		else
-			retval = -ENODEV;
-	}
+	if (tty->ops->open)
+		retval = tty->ops->open(tty, filp);
+	else
+		retval = -ENODEV;
 	filp->f_flags = saved_flags;
 
 	if (!retval && test_bit(TTY_EXCLUSIVE, &tty->flags) &&
-- 
1.7.1


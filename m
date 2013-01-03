Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3ACOxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:53:19 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60977 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] TTY: synclink, remove unneeded tests
Date: Thu,  3 Jan 2013 15:53:09 +0100
Message-Id: <1357224789-2853-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

info in synclink bottom-halves cannot be NULL because it is taken from
work_struct using container_of. Remove the tests.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/pcmcia/synclink_cs.c | 3 ---
 drivers/tty/synclink_gt.c         | 2 --
 drivers/tty/synclinkmp.c          | 3 ---
 3 files changed, 8 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index a046b17..a1ef7bb 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -765,9 +765,6 @@ static void bh_handler(struct work_struct *work)
 	struct tty_struct *tty;
 	int action;
 
-	if (!info)
-		return;
-
 	if (debug_level >= DEBUG_LEVEL_BH)
 		printk( "%s(%d):bh_handler(%s) entry\n",
 			__FILE__,__LINE__,info->device_name);
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 1654b7e..7cb74e8 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1958,8 +1958,6 @@ static void bh_handler(struct work_struct *work)
 	struct slgt_info *info = container_of(work, struct slgt_info, task);
 	int action;
 
-	if (!info)
-		return;
 	info->bh_running = true;
 
 	while((action = bh_action(info))) {
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 22d94a1..68bfce0 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -2008,9 +2008,6 @@ static void bh_handler(struct work_struct *work)
 	SLMP_INFO *info = container_of(work, SLMP_INFO, task);
 	int action;
 
-	if (!info)
-		return;
-
 	if ( debug_level >= DEBUG_LEVEL_BH )
 		printk( "%s(%d):%s bh_handler() entry\n",
 			__FILE__,__LINE__,info->device_name);
-- 
1.8.1


